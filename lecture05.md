# 第5回課題

## 組み込みサーバー（Puma）でのサンプルアプリケーションの動作確認

```shell
# EC2内のソフトウェアをアップデート
$ sudo yum update -y
# ：必要なパッケージをインストール
$ sudo yum install git make gcc-c++ patch openssl-devel libyaml-devel libffi-devel libicu-devel libxml2 libxslt libxml2-devel libxslt-devel zlib-devel readline-devel
```

* rbenv（Rubyのバージョン管理ツール）をインストール
```shell
# rbenvをインストール
$ git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
# パスを通す
$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
# shims と autocompletion の有効化設定を追記
$ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
# 設定ファイルを反映させる
$ source ~/.bash_profile
```

```shell
# ruby-build のインストール
$ git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
$ rbenv rehash
# Rubyをバージョン指定をしてインストール
$ rbenv install -v 3.1.2

# Rubyのバージョン確認
$ ruby -v
# Railsのインストール
$ gem install rails -v7.0.4
# Bundlerのインストール
* $ gem install bundler -v 2.3.14
```

* Node.js  のインストール
```shell
# Node.jsのバージョン管理ツールnvmをインストール
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
# プロンプトに「nvm」と表示されることを確認
$ command -v nvm
# nvmが表示されなかった場合はこのコマンドを実行
$ source ~/.bash_profile
# Node.jsをバージョン指定でインストール
$ nvm install v17.9.1
```

```shell
# yarnのインストール
$ npm install --globalyarn
# サンプルアプリケーションをクローン
$ git clone https://github.com/yuta-ushijima/raisetech-live8-sample-app.git
# サンプルアプリケーションに移動
$ cd raisetech-live8-sample-app
# MySQLをインストール
$ curl -fsSL https://raw.githubusercontent.com/MasatoshiMizumoto/raisetech_documents/main/aws/scripts/mysql_amazon_linux_2.sh | sh
# database.ymlを作成
$ cp config/database.yml.sample config/database.yml
# database.ymlを編集（defaultの欄に以前設定したRDSのusername,PWを記入＆hostの項目を追加しエンドポイントを追記）
$ vim config/database.yml
$ bin/setup
# yarnをインストールするよう指示される
$ npm install --global yarn
$ bin/setup
$ bin/dev
```

* インバウンドルールを追加：ポート範囲3000を追加
* http://IPアドレス:3000/ でサンプルアプリケーションの動作確認ができた
![Puma動作確認](./lecture05-images/05-01_kumikomi.png)


## NginxとUnicornに分けてのサンプルアプリケーションの動作確認

### Nginx側の設定
* Nginxのインストール
```shell
# amazon-linux-extrasを使ってインストールできるパッケージの確認
$ which amazon-linux-extras/usr/bin/amazon-linux-extras
$ amazon-linux-extras
# Nginxのインストール。y＋エンターキー
$ sudo amazon-linux-extras install nginx1
# Nginxのバージョン確認
$ nginx -v
```

```shell
# 初期設定ファイルのバックアップを取る
$ sudo cp -a /etc/nginx/nginx.conf /etc/nginx/nginx.conf.back
# Nginxの起動
$ sudo systemctl start nginx
# インスタンス起動時にNginxも自動で起動させる
$ sudo systemctl enable nginx
# Nginxの設定確認
$ systemctl status nginx
```
![Nginx起動確認](./lecture05-images/05-02-01_Nginx_setting.png)

```shell
#ポート確認→インバウンドルールでポート範囲80を追加する。
$ cat /etc/nginx/nginx.conf
```
* Nginxの接続確認
![Nginxの接続確認](./lecture05-images/05-02-02_Nginx.png)

```shell
# Nginxの停止
$ sudo systemctl stop nginx
```

```shell
# Nginxの設定ファイルの作成＆編集
$ sudo vi /etc/nginx/conf.d/raisetech-live8-sample-app.conf
```
![Nginx設定ファイル](./lecture05-images/05-02-03_raisetech-live8-sample-app.conf.png)
```shell
# nginxの権限をrootからec2-userに変更
$ sudo chown -R nginx nginx
```


### Unicornの設定
```shell
# サンプルアプリケーションのディレクトリに移動
cd raisetech-live8-sample-app
# Gemfileの編集。group :production, :staging doの項目に gem 'unicorn'を追記
$ vi Gemfile
$ bundle install
# Unicornの設定ファイルを編集
$ vim config/unicorn.rb
```
```ruby:unicorn.rb
listen '/home/ec2-user/raisetech-live8-sample-app/unicorn.sock'
pid    '/home/ec2-user/raisetech-live8-sample-app/unicorn.pid'
```

```shell
# ec2-userディレクトリに他のユーザー(nginx)の権限を付与する（書き込みと実行の権限付与）
$ chmod 755 /home/ec2-user
```
Nginxの再起動
```shell
# Unicornの起動
$ bundle exec unicorn_rails -c config/unicorn.rb -E development
# Unicornの起動確認
$ ps -ef | grep unicorn | grep -v grep
```
![Unicorn起動確認](./lecture05-images/05-02-04_unicorn.png)

ブラウザ表示させるもCSSが反映されていない。
→config/environments/development.rbの`config.assets.debug = true`を`config.assets.debug = false`に変更

サンプルアプリケーショの動作確認
![サーバーを分けての動作確認](./lecture05-images/05-02-05_NginxUnicorn.png)


## ALBの追加
* マネジメントコンソールよりALBを作成（EC2＞ロードバランサー）
![ALB](./lecture05-images/05-03-01_ALB.png)
![TG](./lecture05-images/05-03-02_TG.png)
![SG](./lecture05-images/05-03-03_SG.png)

DNS名でブラウザ表示させるとエラーが表示される。
* config/environments/development.rbの最終行に`config.hosts<<DNS名`を追加
* サンプルアプリケーションの動作確認
![ALB追加で動作確認](./lecture05-images/05-03-04_addALB.png)

## S3の追加
* マネジメントコンソールよりバケットを作成する
* IAMロールを作成し、EC2に割り当てる
![IAMロール](./lecture05-images/05-04-01_IAMrole.png)
* config/storage.ymlのバケット名を作成したバケット名に変更
* config/environments/development.rbの`active storage service`を`amazon`に変更
* サンプルアプリケーションの動作確認
![S3追加で動作確認](./lecture05-images/05-04-02_addS3.png)
* S３に保存されていることも確認
![バケット](./lecture05-images/05-04-03_ bucket.png)
![S3コマンド](./lecture05-images/05-04-04_awsS3ls.png)


## 構成図の作成
![画像](./lecture05-images/raisetech_lecture05.drawio.png)
