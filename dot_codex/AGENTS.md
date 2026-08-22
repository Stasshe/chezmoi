以下を必ず守れ

余計な機能を勝手に作るな。
コードは常にシンプルに。拡張性が高く洗練されたもの。
リンたーを通すための読みにくいコードは作るな。
問題が複雑化したらいったん立ち止まれ。
Don't use pip directory. use uv.

コードファイルは英語で書け

git操作はするな。こちらでやる。git操作はreadonly。
restore, staging, commitなどは禁止する。
git diffなどの読み取りのみは完全に許可する。
git restoreは例外として許可する
git操作があった場合、大方私がやったことだから無視しろ
例外として、issue,pr作成は許可性とする。私から許可が出ればghコマンドを使え。
sandbox制限でghがログインしてないように表示されることがあるが、気にするな。
gh prを使う場合は.shファイルを作れ


親Folder名をFile名で繰り返さない規則

コードファイルは英語で書け
無意味にechoを使うな。Readを使え。

plan modeの時は、さいごにplan.mdでなく、プロジェクトに
SPECIFICATION.md　を追加しろ。
設計書・仕様書などはgenshijin口調だが、それより以下の設計書仕様書の極意を優先しろ。

ブラウザを介する確認は最初からagent-browserを使え。
画面表示・画面遷移・認証・フォーム・Server Action・Cookie/Session・Client-side JavaScriptの確認をcurlやwgetで代用するな。Next.jsでは正しく検証できない。 curlを使ってよいのは、明示的なAPI endpointやhealth checkのHTTP契約だけを確認するときに限る。

release.ymlにはpatch minor majorの選択肢でbump versionするやつを。
workflowの中のビルドにはキャッシュも使え。

設計・仕様変更があった場合は必ずREADME,SPECIFICATION,docs/(specとdocsはない可能性がある。)に該当箇所があるか確認し、それを修正しろ

この環境ではrgが使える

/home/からではなく~/からor pwdからパスは指定しろ

work/では、決してdev,develop,mainブランチで直接pushしないように。
pr作るときは、ghつかった.shファイルを出力しろ。実行は私がやるからお前はやるな。
あなたが直接やっていいのはissueの作成のみ。ただしこれも許可性。

セッションの最後には、数行で今回何をやったかをまとめろ

biomejsを使え

CLIがうまくいかないときはtmuxを使え

shellでは、環境変数・複雑な batch を重ねるな。シンプルに使え

無駄に実データを避けようとするな。開発DBなら書き換え削除可能


AIのお前はshell scriptの完了などがうまく検知できないことが多い


@~/.claude/ATTENTIONS.md
@~/.claude/DESIGN.md

# 設計書・仕様書の極意

設計書は抽象度を分離した文書構成であれ
設計段階での、保存するべき意図は\*\_INTENT.mdで書け。
単なる特徴ではなく、重要な設計判断に必要であったBackgroundなどのコンテキスト外のことを書け。
却下理由はいらない。判断した理由を書け。
MVP専用の設計書・仕様書にはするな、設計書は不変である
細かすぎて逆にＡＩが実装しずらくなるようなところまでは絞るな
本当に必要な情報だけを書け。文字数あたりの情報量を限りなく濃くしろ。
丁寧である必要はない。雑でより少ない文字数を目指せ。
