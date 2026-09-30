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
3. 起動: `tmux send-keys -t <name> 'codex -m <model> -c model_reasoning_effort="high"' Enter`。
4. `tmux capture-pane -p -t <name>` でTUI入力待ちを確認。信頼確認等のダイアログが出ていればユーザーに確認して応答。
5. 依頼文をscratchpadに `codex-task.md` として書く(下記テンプレ)。TUIへ長文を直接打たず、`tmux send-keys -t <name> -l 'Read <path> and follow it.'` → 別呼び出しで `tmux send-keys -t <name> Enter`。
6. 監視: `capture-pane -p -S -200 -t <name>` を間隔を空けて読む。作業中表示が消えて入力待ちに戻ったら1ターン完了。完了は必ずpane内容で判断(推測しない)。
7. codexが質問したら、基本はClaudeが答える(DX・実装方針・命名・構成・軽微な仕様など、妥当な既定で進めてよいもの)。ユーザーへ中継するのは、業務ロジックなどClaudeに判断材料がないもの、または後戻りが重い重要判断だけ(AskUserQuestion)。回答は `send-keys -l` + `Enter` で返す。
   - Claudeが答えた分も含め、何を聞かれ何と答えたかを記録し、完了報告に載せる。
8. 承認プロンプトが出たら内容をユーザーに見せて判断を仰ぐ。sandbox回避オプション(`--dangerously-*`)は使わない。
9. 完了後、`git diff` 等の読み取りで成果を確認しユーザーへ数行で報告。質問と回答の一覧(誰が答えたか)も添える。不要になったら `tmux kill-session -t <name>`。

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
- 完了時、変更内容を数行で報告せよ。
```

必要なら repo固有の追加文脈(参照ファイル、規約)を `# 制約` に足す。
