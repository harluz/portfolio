<img src="https://img.shields.io/badge/-HTML5-333.svg?logo=html5&style=flat"><img src="https://img.shields.io/badge/-CSS3-1572B6.svg?logo=css3&style=flat">
<img src="https://img.shields.io/badge/Javascript-276DC3.svg?logo=javascript&style=flat">
<img src="https://img.shields.io/badge/-Ruby-CC342D.svg?logo=ruby&style=flat">
<img src="https://img.shields.io/badge/-MySQL-4479A1.svg?logo=mysql&style=flat">
<img src="https://img.shields.io/badge/-Bootstrap-563D7C.svg?logo=bootstrap&style=flat">
<img src="https://img.shields.io/badge/-jQuery-0769AD.svg?logo=jquery&style=flat">
<img src="https://img.shields.io/badge/-Rails-CC0000.svg?logo=rubyonrails&style=flat">
<img src="https://img.shields.io/badge/-Rubocop-000000.svg?logo=rubocop&style=flat">
<img src="https://img.shields.io/badge/-CircleCI-343434.svg?logo=circleci&style=flat">
<img src="https://img.shields.io/badge/-Docker-2496ED.svg?logo=docker&style=flat">

# BranChannel
日々の生活に新たな行動を起こすキッカケを提供するサービスです。
<br />
具体的には、このアプリではユーザー達により現実世界で達成できるクエストが作成されます。
<br />
これらのクエストはいつでも挑戦することができ、達成後は経験値が貰えるなどゲーム要素も取り入れています。
<br />
獲得経験値に連動して称号が付与されますので、最上級の称号を目指してより多くのクエストに挑戦してみましょう！
<br />
<br />

# URL
https://branchannel.herokuapp.com/
<br />
<br />
ゲストログインを実装しています。ヘッダーのゲストログインボタンからログイン可能です。
![ゲストログイン](/README_images/guestlogin.png)
<br />
<br />

# なぜ作成したのか
私自身が日々の行動を変え新しい体験をすることで自分を変えていきたいと思うようになることが多くなりました。普段やらないことをあえてやる。ただし、自分のアイディアにも限界がありますし、変わりたいのは自分だけでは無いはずです。だからこそ、様々な人の変わろうとする行動のアイディアを共有する場所があれば、各々が想像も出来なかった行動（クエスト）に出会うことができると考えました。このようなクエストに挑戦した後の自分は普段得られない結果と向き合い、そこから新たな視点で物事を考え、結果的には自然と自分が変わっていけるようなサービスを作成したいと思ったためです。
<br />
<br />

# こだわりポイント
## 1.ゲーム要素を取り入れる
新しい行動を起こすことは簡単なことではありません。この状況下においても少しでも楽しく行動を起こせるようゲーム要素などを取り入れました。（経験値の獲得、称号の付与、達成状況の可視化）
![テスト状況](/README_images/profilepage.png)
<br />
<br />

## 2.テストコードの充実
ユーザーが安心して使用できるようテストコードを徹底しました。また、テストコードを充実させることで総合的に見て開発期間を短縮できるとも考えました。
<br />
約400のテストを書きました。
<br />
<br />
![テスト状況](/README_images/totaltest.png)
<br />
<br />

## 3.参考にしたサイトをほぼ全てNotionアプリに記録
今後同じような実装が必要になった際に過去どのようなサイトを参考にしたのか把握できるようNotionアプリに参考にしたサイトのURLを記録しています。
<br />
一部抜粋
<br />
![記録状況1](/README_images/notion1.png)
![記録状況2](/README_images/notion2.png)
<br />
<br />

## 4.リアルタイムチャット機能の実装
クエストに関するトークルームを設けました。
<br />
クエストが達成できたら、達成してみての感想などを語れる場所があれば楽しめると思ったため実装しました。
<br />
また、挑戦するためにあとひと押し背中を押してほしい人をサポートするなどトークルームの使い方は自由です。
<br />
サイトを参考にしながらメッセージの作成・削除機能を実装しました。
<br />
自分もしくは他のユーザーのメッセージかによって削除ボタンの有無をリアルタイムに反映させる処理は苦戦しましたが、実装できました。
<br />

https://github.com/harluz/portfolio/assets/58869301/8c4ae52a-06ac-4dc3-836e-fa1a1a062c4b


<br />

## 5.Dockerによる環境構築及びCircleCIの活用
現場で使用されているDockerを導入して環境構築を行いました。
また、CircleCIを使用し、コミットからデプロイまでの自動化に挑戦しました。
<br />
### Docker
![dockercompose](/README_images/usedocker.png)
<br />
### CircleCI
![CircleCI](/README_images/circleCI.png)
<br />
<br />

# 開発環境及び使用技術
macOS Ventura 13.2.1

HTML / CSS

JavaScript / jQuery 3.3.1

Ruby 3.0.3

Rails 6.1.7.3

MySQL 8.0.27

Docker 20.10.7

docker-compose 1.29.2

CircleCI 2.1
<br />
<br />

# ER図
![ER図](/README_images/ER_diagram.png)
<br />
<br />

# 機能一覧
## ユーザー
・登録、編集、削除
<br />
・ログイン機能(devise)、ゲストログイン
<br />
・獲得経験値に応じた称号の付与
<br />

## クエスト
・作成、編集、削除
<br />
・クエスト作成と同時に挑戦リストに登録
<br />
・クエストの公開、非公開を選択可
<br />
・公開クエスト一覧、マイクエスト一覧、タイトル検索機能
<br />

## チャレンジ
・クエスト挑戦、達成(更新)、諦める（削除）
<br />
・挑戦中一覧、クエスト達成済み一覧
<br />

## タグ
・クエストタグの作成、更新、タグ検索
<br />

## メッセージ
・リアルタイムチャット機能(Action Cable)
<br />
・メッセージ作成、削除機能
<br />

## フロントエンド
・レスポンシブ対応
<br />
<br />

# 今後の実装予定
FatControllerの解消
<br />
「フォームオブジェクト」の修正（ロジックの集約）
<br />
検索機能の充実
<br />
非同期処理（ajax）の活用
<br />
AWSへのデプロイ挑戦
