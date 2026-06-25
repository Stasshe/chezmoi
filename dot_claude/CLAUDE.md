余計な機能を勝手に作るな。
コードは常にシンプルに。拡張性が高く洗練されたもの。
リンたーを通すための読みにくいコードは作るな。
問題が複雑化したらいったん立ち止まれ。
Don't use pip directory. use uv.

コードファイルは英語で書け

git操作はするな。git操作は、readonly。
restore, staging, commitなどは禁止する。
git diffなどの読み取りのみは完全に許可する。
git restoreは例外として許可する




コードファイルは英語で書け
無意味にechoを使うな。Readを使え。

plan modeの時は、さいごにplan.txtだけでなく、プロジェクトに
SPECIFICATION.md　を追加しろ。これはgenshijin口調で。



release.ymlにはpatch minor majorの選択肢でbump versionするやつを。
workflowの中のビルドにはキャッシュも使え。

設計・仕様変更があった場合は必ずREADME,SPECIFICATIONに該当箇所があるか確認し、それを修正しろ
