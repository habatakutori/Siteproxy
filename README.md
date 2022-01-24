# siteproxy
リバースプロキシ、壁越しのyoutube / twitter / googleへの無料アクセス、電報Webページログインのサポート。 google / youtubeへの純粋なWebプロキシ、ゼロクライアント構成。すべてのインターネットへのリバースプロキシ。ワンクリック展開、壁を克服するための強力なツール。

```
                                                 +----> google/youtube
                             +----------------+  |
                             |                |  |
user browser +-------------->+ siteproxy      +-------> wikipedia
                             |                |  |
                             +----------------+  |
                                                 +----> chinese forums
```
このアイテムを違法な目的で使用しないでください。使用しないと、結果に対して責任を負います。

## 目录

- [特点](#特点)
- [原理](#原理)
- [支持代理的网站](#支持代理的网站)
- [部署到cloudflare_worker](#部署到cloudflare_worker)
- [部署到now服务器](#部署到now服务器)
- [部署到heroku服务器](#部署到heroku服务器)
- [部署到vps服务器](#部署到vps服务器)
- [cloudflare_worker_deployment](#cloudflare_worker_deployment)
- [now_deployment](#now_deployment)
- [vps_deployment](#vps_deployment)
- [联系方式](#联系方式)

### 特点
- コードの量はjsproxyの約4分の1です
-サービスワーカーは使用されません。Webサイト自体のサービスワーカーと競合しません。
-siteproxyのアドレスを入力し、検閲なしでインターネットをサーフィンします
-クライアント側からのプロキシ設定は必要ありません。クライアントブラウザからの設定はゼロです。
--now.shへの簡単なデプロイ
-ファイルのダウンロードをサポート

### 原理
```
 1. user browser url: https://siteproxy.herokuapp.com/https/www.google.com
 2. siteproxy.herokuapp.com received the url and request www.google.com, and get response from www.google.com
 3. siteproxy replace all returned strings in javascript/html:
    https://www.google.com => https://siteproxy.herokuapp.com/https/www.google.com
    url(/xxx) => url(/https/www.google.com/xxx)
    https://xxx => https://siteproxy.herokuapp.com/https/xxx
    etc.
 4. send back the modified html/javascript to user browser.
```

### 支持代理的网站
```
1. www.google.com, and search action.
2. www.youtube.com, only firefox browser is supported.
3. zh.wikipedia.org, and search action.
4. facebook, login is not verified.
5. twitter, search in twitter, login is not supported.
6. telegram web login
7. 中文论坛等
```
### 部署到cloudflare_worker
```
1. cloudflareアカウントにサインアップ
2. cloudflareでワーカーを作成し、abcd123.xxxx.workers.devなどのワーカーのサブドメインを書き留めます
3.このリポジトリのbuild / worker.jsファイルを見つけ、テキストエディターで開き、siteproxy.netptop.workers.devを検索して、サブドメイン名に置き換えます。
4. cloudflareで作成したワーカーを編集し、worker.jsのすべてのコンテンツをコピーし、上書きしてワーカーに貼り付け、保存します
5.これで、ブラウザでサブドメインにアクセスできるようになります。
`` ``
### 部署到now服务器
```
（問題があるかもしれません、今のところアカウントテストはありません）
1.今すぐアカウントを登録するhttps://zeit.co/home
2. githubアカウントをお持ちでない場合は、githubアカウントを登録し、このリポジトリをフォークします
3.今のコンソールでアプリケーションを作成し、フォークしたばかりのリポジトリにバインドすると、同様のドメイン名を持つドメイン名が取得されます：your-domain-name.now.sh
4. githubでフォークしたばかりのリポジトリを変更し、config.jsのserverNameを新しいドメイン名に変更します。
   serverName： 'siteproxy.netptop.com' ====> 'your-domain-name.now.sh'
5.これで、ブラウザで新しいドメイン名にアクセスできます：https：//your-domain-name.now.sh
`` ``
### 部署到heroku服务器
```
1. herokuアカウントにサインアップします：https：//www.heroku.com/
2. githubアカウントをお持ちでない場合は、githubアカウントを登録し、このリポジトリをフォークします
3. herokuコンソールでアプリケーションを作成し、フォークしたばかりのリポジトリにバインドすると、同様のドメイン名を持つドメイン名が取得されます：your-domain-name.herokuapp.com
4. herokuの[Deloy]ページで、[Enable AutomaticDeploys]ボタンをクリックします
5. githubでフォークしたばかりのリポジトリを変更し、procfileのドメイン名を新しいドメイン名に変更します（httpsプレフィックスを追加しないでください）。
         "web：herokuAddr = siteproxy.herokuapp.com npm run start"
   ====> "web：herokuAddr = your-domain-name.herokuapp.com npm run start"
6.これで、ブラウザで新しいドメイン名にアクセスできます：https：//your-domain-name.herokuapp.com
`` ``
### 部署到vps服务器
```
1. ssl Webサイトを作成し（certbotとnginxを使用、googleで使用）、nginxを構成し、
   / etc / nginx / sites-enabled / defaultには次のものが含まれている必要があります。
   ..。
   サーバー{
      server_name siteproxy.your.domain.name
      位置 / {
        proxy_set_header X-Real-IP $ remote_addr;
        proxy_set_header X-Forwarded-For $ proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $ schema;
        proxy_pass http://127.0.0.1:8011;
      }
   }
2.実行：sudo systecmctl start nginx
3.ユーザー環境で次のコマンドを実行してノード環境をインストールします。すでにノード環境がある場合は、この手順を無視してください。
   （1）curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
   （2）ソース〜/ .bashrc
   （3）nvm install v12.16.3
3.実行：npm install -g forever
4.実行：git clone https://github.com/netptop/siteproxy.git;
5.実行：cd siteproxy; npm install;
6. config.jsファイルを開き、serverNameが定義されている場所を見つけて、次のように変更します。
   serverName： 'siteproxy.herokuapp.com' ====> 'これはあなたのドメイン名です'
7.実行：forever start -c'node --tls-min-v1.0 'index.js
8.これで、ブラウザでドメイン名にアクセスできます。
9. CloudFlareアクセラレーションを設定する場合は、CloudFlareの手順を参照してください
`` ``

がばがば翻訳草
### cloudflare_worker_deployment
```
1. register a cloudflare account
2. create a worker in cloudflare, remember worker's sub-domain name, like abcd123.xxxx.workers.dev
3. search build/worker.js in this repo, open it in a text editor, search and replace 'siteproxy.netptop.workers.dev' with your sub-domain name.
4. edit the worker just created in cloudflare, replace worker's content with content of build/worker.js, save.
5. done.
```

### now_deployment
```
1. register one now.sh account from https://zeit.co/home
2. npm install -g now
3. git clone https://github.com/netptop/siteproxy.git
4. cd siteproxy
5. now
6. find your domain name from now cli, then replace serverName in 'config.js', like:
   serverName: 'siteproxy.herokuapp.com' ====> 'your-domain-name.now.sh'
7. change "blockedSites = ['www.youtube.com', 'm.youtube.com']" ====> "blockedSites = []" if you want to support youtube
8. now --prod
9. done

```
### vps_deployment
```
1. create ssl website(using certbot and nginx), and configure nginx as follow:
   vi /etc/nginx/sites-enabled/default:
   ...
   server {
      server_name siteproxy.your.domain.name
      location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass       http://127.0.0.1:8011;
      }
   }
2. systecmctl start nginx
3. npm install -g forever
4. git clone https://github.com/netptop/siteproxy.git; 
5. cd siteproxy; npm install;
6. replace serverName in 'config.js', like:
   serverName: 'siteproxy.herokuapp.com' ====> 'siteproxy.your.domain.name'
7. forever start -c 'node --tls-min-v1.0' index.js
8. done, now you can access your domain name from browser.
```
### 联系方式
Telegram群: @siteproxy
<br />
email: netptop@gmail.com
