---
name: codex4claude
description: Claudeがtmux経由でcodex TUIを起動し、実装を委譲する手順。ユーザーが /codex4claude と明示したときのみ使う。
disable-model-invocation: true
argument-hint: "[model=sol|luna] <task> (model省略でClaudeが判断)"
---

# codex4claude

tmux上でcodex TUI(`codex exec`ではない)を操作し実装させる。Claudeは依頼・監視・質問中継、実装はcodex。

## 引数

- model: ユーザー指定がなければClaudeがタスクから選ぶ。
  - `gpt-6-sol`: 複数ファイル、設計判断、曖昧さ・難所を含む実装。迷ったらこちら。
  - `gpt-6-luna`: 範囲が明確で小さい、機械的な変更。
  - 指定があればそのまま `-m` へ(`sol`/`luna` は上記IDに展開)。選んだmodelと理由を一行でユーザーへ伝える。
- effort: `high` 固定。
- 残りがタスク。曖昧ならcodexへ投げる前にユーザーへ確認。

## 手順

1. `codex --version` と `tmux -V` 確認。`tmux ls` で既存の `codex4claude-*` sessionを確認、再利用可なら流用。
2. session作成: `tmux new-session -d -s codex4claude-<slug> -c <pwd>`。cmdは直接渡さない(shellだけ起動)。
3. 起動: scratchpadに `<log>`(例 `codex-events.log`)を空で作り、
   `tmux send-keys -t <name> "codex -m <model> -c model_reasoning_effort=\"high\" -c 'notify=[\"sh\",\"-c\",\"printf %s\\\\n \\\"\$1\\\" >> <log>\",\"sh\"]'" Enter`
   (ペインに入力される実体: `codex -m <model> -c model_reasoning_effort="high" -c 'notify=["sh","-c","printf %s\\n \"$1\" >> <log>","sh"]'`。動作確認済み)
   codexはnotify引数の末尾にイベントJSONを付けて呼ぶので、それが `$1` に入る。<log>は絶対パス。
4. `tmux capture-pane -p -t <name>` でTUI入力待ちを確認。起動時に更新ダイアログ(Update now / Skip)や信頼確認が出ることがある。更新は `2`(Skip)+Enter、その他はユーザーに確認して応答。
5. 依頼文をscratchpadに `codex-task.md` として書く(下記テンプレ)。TUIへ長文を直接打たず、`tmux send-keys -t <name> -l 'Read <path> and follow it.'` → 別呼び出しで `tmux send-keys -t <name> Enter`。送信後にpaneを見て、入力欄に文が残っていたらEnterを再送する(1回目のEnterが送信にならないことがあった)。
6. 監視: codexのnotify hook(手順3)がターン完了ごとにJSONを `<log>` へ1行追記する。Monitorは1本だけ(`timeout_ms` 1800000)で、ログ追記・pane停止(ハング)・session消失をまとめて通知する。
   ```
   prev=""; n=0; last=0
   while tmux has-session -t <name> 2>/dev/null; do
     c=$(wc -l < <log>)
     if [ "$c" -gt "$last" ]; then tail -n +$((last+1)) <log> | jq -r .type; last=$c; fi
     cur=$(tmux capture-pane -p -t <name> | md5sum)
     if [ "$cur" = "$prev" ]; then n=$((n+1)); else n=0; fi
     if [ $n -eq 36 ]; then echo "codex stalled 3min"; fi
     prev=$cur; sleep 5
   done
   echo "codex session ended"
   ```
   - `agent-turn-complete` = 完了 or 質問(codexの質問はターン終了として届く)。初回にcodex内部のタイトル生成ターンも同イベントで届くので、依頼直後の通知は作業完了と限らない。
   - `stalled` = ハングか、完了後の待機。`session ended` = クラッシュ等。
   - いずれも `capture-pane -p -S -200 -t <name>` を読み、何が起きたか必ずpane内容で判断する(推測しない)。
   - timeoutで切れたら張り直す。
7. codexが質問したら、基本はClaudeが答える(DX・実装方針・命名・構成・軽微な仕様など、妥当な既定で進めてよいもの)。ユーザーへ中継するのは、業務ロジックなどClaudeに判断材料がないもの、または後戻りが重い重要判断だけ(AskUserQuestion)。回答は `send-keys -l` + `Enter` で返す。
   - Claudeが答えた分も含め、何を聞かれ何と答えたかを記録し、完了報告に載せる。
8. 完了後、`git diff` 等の読み取りで成果を確認しユーザーへ数行で報告。質問と回答の一覧(誰が答えたか)も添える。不要になったら `tmux kill-session -t <name>`。codexが起動したプロセス・dockerが残っていないか(`ps`、`docker ps -a`)を確認し、今回作られたものだけ消す。

## 依頼文テンプレ

```
あなたはオーケストレータ。実装はsubagentを積極的に使って分担・並列化せよ(subagent利用は許可済み)。
少しでも不明点・曖昧点があれば、実装前に必ず私へ質問せよ。推測で進めるな。

# タスク
<task>

# 制約
- 余計な機能を足さない。シンプルに。
- gitの書き込み操作(commit/stage/push等)はするな。
- 設計・仕様変更があればREADME/docsの該当箇所も更新。
- 起動したプロセス(dev server、tmux session等)とdockerコンテナ・イメージ・volumeは、使い終わったら必ず停止・削除せよ。既存のものは触るな。
- 完了時、変更内容を細かく報告せよ。
```

必要なら repo固有の追加文脈(参照ファイル、規約)を `# 制約` に足す。
