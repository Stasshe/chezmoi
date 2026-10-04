---
name: codex4claude
description: Claudeがtmux経由でcodex TUIを起動し、実装を委譲する手順。ユーザーが /codex4claude と明示したときのみ使う。
disable-model-invocation: true
argument-hint: "<task>"
---

# codex4claude

tmux上でcodex TUI(`codex exec`ではない)を操作し実装させる。
厳しすぎる検証をするなある程度で切り上げろ。速度も意識しろ。ただし/fastは使うな。
遅すぎるとキレるから、速くやれ。どうせお前の出来は悪いのだから、すぐに結果を出せ

## 役割

- Claude: オーケストレータのオーケストレータ。依頼・監視・質問への回答・セッション間の中継・レビュー手配。**コードは書かない。** 触ってよいのはユーザー決定事項のdocs記録と、scratchpadの依頼文・指摘md・監視スクリプトだけ。
- codex `gpt-6.1-sol`(固定、effort high): 領域の責任者オーケストレータ。洗い出し・分解・subagent割当・統合・検証。自分ではコードを書かない。
- subagent `gpt-6-luna`: 実装担当。最大限並列。難所(状態機械・DB権限/並行性・認証・中核の業務計算など)は `gpt-6.1-sol` subagent可。
- レビュー: Claudeのsubagent(Sonnet、難所はOpus)。
- 進め方は rapid-prototype-coder エージェントと同じ方針: 全体を先に動かす。細部の完璧主義で止めない。型安全・800行上限・デッドコードなしは守る。

## 体制

- 粒度は粗く: 「サーバー側全部」「画面側全部」＋必要なら専門(例: a11y改善)の2〜3本を並列。細かいタスクを逐次投げない。
- 各セッションは領域の責任者。正本を示し、残作業の洗い出しから完了まで任せる。正本はプロジェクトの業務仕様・設計文書・移植元の旧実装など(例: htj-platformでは 業務=docs/domain、設計=docs/design・docs/plan、外観=旧アプリ)。
- 依頼文に**担当範囲**と**触るな範囲**、docker project名・ポートの分離を明記。同じアプリを2本で触る時は「編集前に読み直し、最小差分、相手を上書きしない」を両方へ伝える。
- セッション間の依存はClaudeが中継する。例: 画面側が「API契約の追加」を求めたら、Claudeがサーバー側の一括タスクへ追記し、完了したら画面側へ合図する(接続先・再seed・再ビルド要否も)。
- ユーザーが見る共有環境(dev server・API・DB)はClaudeかサーバー側が維持し、他は止めない・作り直さない。開発データやログイン情報が変わったら、接続先とログイン情報をユーザーに伝える(プロジェクトにアカウント一覧の文書があれば、それも更新させる)。
- あるセッションが担当外の不具合を見つけたら、自分で直させず内容を報告させ、Claudeが担当セッションへ回す(並行編集の衝突を防ぐ)。

## 起動

1. `tmux ls` で既存確認(既存は触らない)。`tmux new-session -d -s codex4claude-<slug> -c <pwd>`(cmdは渡さない)。
2. `tmux send-keys -t <name> "codex -m gpt-6.1-sol -c model_reasoning_effort=\"high\" -c agents.max_concurrent_threads_per_session=30" Enter`
3. `until tmux capture-pane -p -t <name> | grep -q "Ask Codex"; do sleep 2; done`。更新ダイアログは `2`+Enter。
4. 依頼文をscratchpadに書き(codexにもscratchpadの絶対パスを使わせる。リポジトリ直下に作業ファイルを作らせない)、`send-keys -l 'Read <path> and follow it.'` → 別呼び出しで `Enter`。paneで送信を確認(残っていればEnter再送)。
   - 作業中の追加指示は次のtool呼出し後に届く(キュー)。急ぐ時だけEsc(2回目は中断)。
- codexにインストール済みのスキル(例: ui-ux-pro-max)は、Claude側に無くても使える。「無い」と判断しない。

## 監視

Monitor 1本(`timeout_ms` 1800000、切れたら即張り直し)で全sessionを見る:
```
( while :; do a=$(awk '/MemAvailable/{print int($2/1048576)}' /proc/meminfo); if [ "$a" -lt 5 ]; then echo "LOW MEMORY: ${a}GiB available"; sleep 60; fi; for s in <sessions>; do if tmux capture-pane -p -t $s 2>/dev/null | tail -6 | grep -q "at capacity"; then echo "$s: model at capacity"; sleep 50; fi; done; sleep 10; done ) & bash ~/.claude/skills/codex4claude/watch.sh <sessions> 2>&1; kill %1
```
- `turn finished` / `pending questions` / `compacting (#n)` / `stalled 3min` / `session ended` / `model at capacity` / `LOW MEMORY`。必ず `capture-pane -p -S -60` で中身を見て判断。
- `model at capacity`: 「続きを再開せよ」と送るだけで復帰する。
- `LOW MEMORY`: 原因(`ps` で MainThread=Nodeワーカー、chrome)を見て、重いプロセスを絞る指示を全セッションへ(例: テストのワーカー数を4に、build・型検査はセッション内で同時1つ、agent-browserは使用後すぐclose)。subagentの並列数は下げない。
- `stalled` は完了後の待機であることが多い。
- Monitorを張り直すと `compacting (#n)` の数が0に戻る。セッションごとの通算圧縮回数はClaudeが控えておく(切替判断に使う)。
- 区切りごとに `tmux ls` と `docker ps -a` を見て、codexが作って放置した検証用tmux(例 `codex-*-vitest`)・コンテナが無いか確認し、使用中でなければ消して担当へ注意する。

## 質問への回答

- `? N questions` は `send-keys S-Left` で開く。選択肢は数字キー、Otherは数字→`send-keys -l '<文>'`→Enter。
- Claudeが答える前に、該当する業務仕様・設計文書を必ず引いて矛盾しないか確認する(記憶で答えない)。廃止済み概念や用語の誤りはその場で訂正する。
- Claudeが答えてよい: 実装方針・命名・構成・docsからの論理的帰結・他セッションへの中継。ユーザーへ聞く: 業務ルール・仕様変更・外部設定や権限が要るもの(AskUserQuestion、まとめて)。
- 業務決定は即docsへ反映し、関係セッションへ伝える。
- codexに、Claudeの回答を「利用者確認済み」「利用者が承認」としてdocs・記録に書かせない(実際にあった)。Claudeの判断はClaudeの判断として扱わせる。
- Claudeが自分で答えた質問も、答えた直後にユーザーへ必ず報告する: 「何を聞かれたか（要約）／Claudeの回答／根拠（参照docsや判断理由）」を数行で。ユーザーが違うと言えば即訂正してcodexへ送り直す。黙って答えて流さない（ユーザーが判断を追えなくなる）。

## 検証

- 冒頭の「厳しすぎる検証をするな」は画面確認・スクショ比較などの重い検証のこと。format等の基本検査は省かない。
- 常に必須: format・lint・typecheck・build・単体テスト。専用subagentに並列でやらせ、実装を止めない。最後は全部グリーンで報告。
- agent-browserの要否はClaudeが判断。全画面確認・スクショ比較はしない。その回の要所(認証・主要操作・ユーザーが報告した不具合)だけ最後に1subagent・同時1〜2セッションで確認。
- 過剰な検証(多数のChrome・並行build)はOOMでPCを固まらせる。subagentの並列数自体は問題ではなく、各subagentが重いプロセスを立てることが問題。

## 自走ループ(止まるな)

- codexが完了しても報告して待機しない。完了 → 即Sonnetレビュー(数千行×数体並列) → 指摘を精査し領域ごとの一括md(batch-*.md)へ → 担当セッションへ → 修正、をユーザーが止めるまで回す。待機中のcodexを放置しない。
- レビュー観点はscratchpadの共通mdにまとめ範囲だけ渡す: 実バグ、業務仕様・計画とのずれ(廃止概念・用語)、旧実装からの明らかな逸脱、重複・不自然な実装。出力 `path:line — severity — 問題 — 修正`。
- 精査: ユーザー方針に反する指摘・要件追加・業務判断が要るものは除外かユーザーへ確認。ユーザーが「不要」と言った観点は以後外す。

## セッションの切替

- 異常終了・PC再起動で落ちたら新規ではなく `codex resume <id>` で文脈ごと再開(IDは `~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl`、初回プロンプトで特定)。並列上限変更も `/quit` → `codex resume <id> -c agents.max_concurrent_threads_per_session=N`。
- 落ちたセッションの未反映の知見は、resumeして「コード変更禁止、作業ツリーから読めない計画・発見を recovered-*.md に書け」と回収し、後継へ渡す。
- 文脈圧縮3回程度か性能劣化で、区切りに引継ぎ(handoff.md)を書かせて新sessionへ。

## ユーザー閲覧

- ユーザーは `tmux attach -t <name>`(`-r` なし)で見る。`-r` が付くと send-keys が `client is read-only` で失敗する。

## 程度感（具体例。迷ったらここに合わせる）

### タスクの粒度
- 良い: 「サーバー側全部（API・proto・migration・seed・CI）の責任者。正本は業務仕様・設計文書。残作業を洗い出して最後まで」。1セッション=1領域で数時間走らせる。
- 良い: レビュー指摘20〜30件を1つの `batch-ui-1.md` にまとめて一度に渡す。
- 悪い: 「在庫の負数を直せ」「次はseedの日付」「次はパスワード」と1件ずつ投げる。毎回codexの立ち上がり・読み直しコストがかかり遅い。
- 悪い: 1つのバグのために新規セッションを立てる。既存の担当セッションへ追記で足りる。
- 悪い: 「focus表示」「hover表示」「a11y再確認」のように観点ごとに専門セッションを次々立てる。画面の観点は画面側の責任者へ「この観点で全画面を洗い出して直せ」と1行で渡す。専門セッションは独立した大きな領域だけ。
- 悪い: レビュー指摘を細かい作業手順まで書き下して渡す。指摘の要点と正本を渡し、直し方は責任者に任せる。
- 新規セッションを立てるのは: 新しい領域（例: a11y改善）を始める時と、既存セッションが圧縮3回に達した時だけ。落ちた時は新規ではなく `codex resume`。

### 並列の量
- オーケストレータ: 2〜3本同時（サーバー／画面／専門1本）。4本以上は中継が破綻しやすい。
- subagent: 各オーケストレータで上限30（`-c agents.max_concurrent_threads_per_session=30`）。8や16は遅すぎると言われた。
- 実際に効くのは並列数ではなく重いプロセス数（例: メモリ27GBのこのPCで）: Chrome多数＋Vitest/tsc/next build の並走でOOM（実績: Chrome 11GB＋Nodeワーカー7GBでPC固まる）。空き5GB割れで警報、Vitest `--maxWorkers=4`。

### 検証の程度
- 毎回必須（省略禁止）: format（例: biome check --write、gofmt）、lint、typecheck、build、単体テスト。検証専用subagentに並列でやらせ、実装は止めない。これを省いて「format回してない」と言われた。
- やりすぎ（禁止）: 全画面agent-browser確認、旧新スクショの画像比較、検証用の別環境を何個も立てる。これでOOMと大幅な遅延を起こした。
- ちょうどよい agent-browser: その回の修正の要所5項目程度（例: ログイン成功/失敗、ボード表示と確定、利用者が報告したエラー文言、地点編集保存）を1subagent・1セッションで最後に確認。
- ユーザーが報告した不具合は、修正後にClaude自身が agent-browser で再現手順を1回なぞって確認してよい（例: ログイン不可の報告→同じ入力で試す）。

### Claudeが答える／ユーザーに聞く（例はhtj-platformのもの）
- Claudeが答える例: 「Headerの氏名表示に全件取得してよいか」（規模数十件→可）、「E2Eのこのspecを誰が直すか」（担当範囲の調整）、「API契約を追加してよいか」（他セッションへ中継）、「0分報告を受けるか」（累計方式の論理的帰結）。
- ユーザーに聞く例: 遅延の上限、借用車両の割当を仕様に入れるか、外部APIキーの有効化、経路計算の代替手段の採否。
- やってはいけない: docsを引かずに記憶で答える（例: 廃止済みの「未割当」を「現状維持でよい」と答え、codexが「利用者確認済み」と記録した）。答えに業務用語が出たら必ず業務仕様の文書を確認。
- やってはいけない: Claude側で見つからないものを「無い」と決めつける（例: codexにだけ入っているスキル）。

### 報告の頻度
- ユーザーへの報告は、セッション完了・Claudeが代わりに答えた質問（回答と根拠）・ユーザー判断が必要な質問・異常（OOM・落ちた・容量エラーが続く）の時。各tool結果ごとの実況はしない。
- codexの完了報告を自分の区切りにしない。完了したら報告と同時に次（レビュー→一括修正）を発射する。「なぜ手を止めていた」と言われた。

### 失敗例（繰り返さない）
- 旧UIを「維持」と書きながら、codexの「比較済み」報告を鵜呑みにして画面を見ず、別物のUIになった。外観の正本がある移植では、最初の画面ができた時点でClaudeが1回だけ実画面を見る。
- seedを「ありものの最小データ」で済ませ、旧seedを活かさず量も整合も足りなかった。seedは旧データ・本番相当の量・システムが自動生成する値まで再現させる。
- 経路APIの403を画面が「APIに接続できません」と表示した。外部サービス不可・権限・入力・競合・通信断はエラー種別ごとに文言を分けさせる。

## 依頼文テンプレ

```
あなたはオーケストレータ。自分ではコードを書くな。コードは全てmodel `gpt-6-luna` のsubagentに書かせよ(並列で大量に)。難所は `gpt-6.1-sol` subagent可。あなたは割当・統合・検証に専念。
あなたは「<領域>全部」の責任者。私の個別指示を待たず、正本(<業務仕様・設計文書・移植元のパス>)に照らして残作業・不具合・重複を自分で洗い出し、最後まで片付けよ。業務判断が必要な時だけ私へ質問せよ。

# タスク
<task>

# 担当範囲
あなた: <paths>。触るな: <paths>(別sessionが担当)。共有環境 <URL/ports> は止めるな。

# 制約
- 余計な機能を足さない。シンプルに。型安全、1ファイル800行以下、デッドコードなし。
- gitの書き込み操作はするな。gitの状態変化は利用者の操作なので気にするな。
- 設計・仕様変更があればdocsの該当箇所も更新。
- format・lint・typecheck・build・単体テストは検証用subagentに並列でやらせ、全部グリーンにする。agent-browserは<要所>だけ、終了後close。
- 起動したプロセス・dockerは使い終わったら停止・削除。既存・他sessionのものは触るな。docker project名・ポートは <指定>。
- 完了時、変更内容・検証結果・未完了を一度だけまとめて報告せよ。
```
