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

- Claude: オーケストレータのオーケストレータ。依頼・監視・codexの質問への回答・レビュー手配・成果確認。**コードは書かない。** 触ってよいのはユーザー決定事項のdocs記録と、scratchpadの依頼文・指摘md・監視スクリプトだけ。
- codex `gpt-6.1-sol`(固定): オーケストレータ。タスク分解・subagentへの割当・統合・検証。自分ではコードを書かない。
- subagent `gpt-6-luna`: コードを書く実装担当。数・並列度の制限なし、最大限並列でガンガン使わせる。難所(状態機械設計・RLS/並行性・認証など)は `gpt-6.1-sol` subagentでもよい。
- レビュー: Claudeのsubagent(Sonnet、難所はOpus)。下記「レビュー」。

## 引数

- 全体がタスク。曖昧ならcodexへ投げる前にユーザーへ確認。
- model `gpt-6.1-sol`、effort `high` 固定。

## 手順

1. `codex --version` と `tmux -V` 確認。`tmux ls` で既存sessionを確認(既存は触らない)。
2. session作成: `tmux new-session -d -s codex4claude-<slug> -c <pwd>`。cmdは直接渡さない(shellだけ起動)。
3. 起動: `tmux send-keys -t <name> "codex -m gpt-6.1-sol -c model_reasoning_effort=\"high\" -c agents.max_concurrent_threads_per_session=30" Enter`
   - 並列数自体は問題にならない。OOMの原因はClaudeが過剰な検証を課し、多数のsubagentが各自Chrome(agent-browser)・build・全体テストを立ち上げたこと。
   - 重い検証（agent-browserの画面確認、スクショ比較）は求められた時だけ。format・lint・typecheck・build・単体テストは常に必須で、専用subagentに並列でやらせ実装を止めない。最後は全部グリーンで報告させる。
4. `capture-pane` が `Ask Codex` を含むまで待つ(`until ...; do sleep 2; done`)。更新ダイアログは `2`(Skip)+Enter、その他はユーザーに確認。
5. 依頼文をscratchpadに書く(下記テンプレ)。`send-keys -l 'Read <path> and follow it.'` → 別呼び出しで `send-keys Enter`。送信後paneで確認し、入力欄に残っていればEnter再送。
   - 作業中に送った追加指示は「Messages to be submitted after next tool call」にキューされ、次のtool呼出し後に届く。急ぐ時だけEscで即時送信(Esc2回目は中断)。
6. 監視: Monitor 1本(`timeout_ms` 1800000)で全sessionを見る。`bash ~/.claude/skills/codex4claude/watch.sh <session> [<session>...]`
   - 出力: `turn finished`(working表示が30秒消えた)、`pending questions`、`compacting (#n)`、`stalled 3min`、`session ended`。
   - いずれも `capture-pane -p -S -80 -t <name>` を読みpane内容で判断(推測しない)。working表示は再描画でちらつくので誤検知はあり得る。
   - notify hookはJSONに改行が入らず、ターン完了の判定に使えないので使わない。
   - timeoutで切れたら張り直す。session構成が変わったら旧Monitorを TaskStop して張り直す。
7. codexの質問:
   - 「Queued follow-up inputs / ? N questions」は `send-keys S-Left` で開く。選択肢は数字キーで即送信。Otherは数字で選んでから `send-keys -l '<文>'` → Enter。`S-Left`/`S-Right` で問の移動。
   - 基本はClaudeが答える(DX・実装方針・命名・構成・軽微な仕様、ユーザー決定からの論理的帰結)。業務ロジック・後戻りが重い判断・権限や外部設定が要るものはユーザーへ(AskUserQuestion、まとめて最大4問)。
   - ユーザーの業務決定は**即**docs(domain等)へ反映し、codexにも伝える。
   - 何を聞かれ誰が何と答えたかを記録し、報告に載せる。
8. 完了後、`git diff` 等の読み取りで成果を確認しユーザーへ報告。不要sessionは `tmux kill-session`。codexが起動したプロセス・dockerが残っていないか確認し、今回作られたものだけ消す。

## 並列オーケストレータ

- 依頼の粒度は「サーバー側全部」「画面側全部」「その他」程度に大きく。各オーケストレータを領域の責任者にし、正本(plan/docs/旧実装)を示して残作業の洗い出しから完了まで任せる。Claudeが細かい指示を逐次投げない。

- `gpt-6.1-sol` オーケストレータは2〜3本並列してよい(例: API担当 / 画面群A / 画面群B)。
- 各依頼文に**担当範囲**と**触るな範囲**を明記し、ファイル衝突を防ぐ。共通部品を作る側を1本に決め、完成したら途中報告させて他へ中継する。
- docker compose project名・ホストポートをsessionごとに分ける。他sessionの環境は停止・作り直し禁止。
- API側の修正完了などsession間の依存は、Claudeが合図(接続先・再seed・再ビルドの要否)を中継する。

## セッションの切替

- codexが異常終了・PC再起動で落ちたら、新規ではなく `codex resume`（直近は `codex resume --last`、または一覧から選択）で文脈ごと再開する。

- 文脈圧縮が3回程度、または性能劣化(同じ質問の繰返し、指示の取りこぼし)が見えたらClaude判断で新規sessionへ。
- 手順: 区切りでEsc中断 → 「subagent全停止・コード変更禁止・`handoff.md` に段階ごとの完了/未完了・検証結果・既知の問題・起動物を書き、起動物を片付けよ」と指示 → `kill-session` → 元タスク＋決定事項＋handoff＋追加指示を渡して新session。

## レビュー

- codexが完了しても報告して止まらない。完了→即レビュー→指摘を担当codexへ→修正のループを、ユーザーが止めるまで自走で回す。待機中のcodexを放置しない。

- ある程度実装が進んだら、Claudeのsubagentで読取専用レビュー。1体あたり数千行、領域ごとに数体を並列。普通はSonnet、難所(中核ロジック・並行性・RLS)はOpus。
- 共通のレビュー観点はscratchpadのmdにまとめ、各subagentには範囲だけ渡す。出力は `path:line — severity — 問題 — 失敗シナリオ — 修正`。
- 戻った指摘をClaudeが精査(ユーザー方針に反する指摘・要件追加・業務判断が要るものを除外/ユーザーへ確認)し、scratchpadに領域別md＋横断方針mdとして保存。担当codex sessionへ渡す。
- ユーザーが「不要」と言った観点(例: 手動workflowの安全策、E2E強化)は以後の指摘から外す。

## ユーザー閲覧

- ユーザーは `tmux attach -t <name>`(`-r` なし)で直接見る。`-r` の読み取り専用クライアントが付くとClaudeの `send-keys` が `client is read-only` で失敗するため、`-r` は案内しない。閲覧用の別sessionも作らない。

## 依頼文テンプレ

```
あなたはオーケストレータ。自分ではコードを書くな。タスクを分解し、コードは全てmodel `gpt-6-luna` のsubagentに書かせよ。
subagentは並列度最大で使え。独立したファイル群は全て同時に投げろ(利用は許可済み)。難所は model `gpt-6.1-sol` のsubagentでよい。あなたは割当・統合・検証に専念せよ。
業務判断が必要な不明点は実装前に必ず私へ質問せよ。推測で進めるな。それ以外は止まらず最後まで進めよ。

# タスク
<task>

# 担当範囲(並列時)
あなた: <paths>。触るな: <paths>(別sessionが担当)。

# 制約
- 余計な機能を足さない。シンプルに。
- gitの書き込み操作(commit/stage/push等)はするな。gitの状態変化は利用者の操作なので気にするな。
- 設計・仕様変更があればREADME/docsの該当箇所も更新。
- 起動したプロセス(dev server、tmux session等)とdockerコンテナ・イメージ・volumeは、使い終わったら必ず停止・削除せよ。既存・他sessionのものは触るな。docker project名・ポートは <指定>。
- 完了時、変更内容・検証結果・未完了を細かく報告せよ。
```

必要なら repo固有の追加文脈(参照ファイル、規約)を `# 制約` に足す。
