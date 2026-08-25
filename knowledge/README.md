# AI Knowledge Base

このdirectoryはAIが作業前に参照する、実機固有の高密度な運用知識を置く。人間向け導入説明ではない。

## 記述規則

- 症状、環境、観測事実、原因、復旧、検証、失敗例、未解決を分離する。
- 「接続済み」「processあり」など弱い指標で完了させず、機能ごとの完了条件を書く。
- 実測値、stable identifier、error全文、順序依存を残す。動的PID/node IDは固定値として再利用しない。
- 確定事実と推論を区別する。未検証の回避策を修正済みと書かない。
- 再現に不要な会話経緯、謝罪、一般論は削る。文字数あたりの判断材料を増やす。
- 同種障害では既存文書を更新し、類似文書を増やさない。

## Index

- [WH-1000XM5 Bluetooth通話障害](bluetooth-audio.md): MediaTek controllerのautosuspend、mSBC、PipeWire/WirePlumber、Noctalia、Discordの複合障害。
