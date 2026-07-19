# DESIGN

## 基本

親領域を最大限使う。固定最大幅、広い外周余白、箱の入れ子を初期解にしない。

情報密度を高く保つ。余白は階層と誤操作防止に必要な量だけ使う。

## 面の使い分け

Card、独立した操作・編集責務をひとまとまりとして認識させる場合だけ使う。例、基本情報、担当者、スコア管理、遅延時間、設定。

以下、Card化しない。

- page全体の外枠
- Card内のfield、label/value
- 同種データの各item
- tab contentを包むだけの箱
- spacingだけで区別できるsection

一覧、反復情報、overview、罫線grid/tableで分割。Cardを並べない。

編集section、背景差と控えめな角丸で面を作る。shadow不要。面の中に面を作らない。

境界を消すとcontrol、label、actionの所属が曖昧になるなら面を使う。曖昧にならないならheading、spacing、dividerで分ける。

## Layout

pageは利用可能な親幅を使う。個別pageでgutterと最大幅制限を重ねない。長文、dialogなど読み幅自体が要件の場合だけ制限する。

desktopの複数column、狭幅で縦積みへ変える。機能階層と操作順は変えない。

fixed要素と本文offsetを別管理しない。同じlayout treeで領域を確保する。

## 確認

desktopとmobileを実ブラウザで確認する。余白量だけでなく、情報の所属、利用可能面積、操作順、overflowを見る。
