# 第10回課題
以下の３つ（ネットワーク層・セキュリティ層・アプリケーション層）にテンプレートを分割して.ymlファイルを作成し、CloudFormationにて環境構築を行った。

* [lecture10_Network.yml](./lecture10-templates/lecture10_Network.yml)
* [lecture10_Security.yml](./lecture10-templates/lecture10_Security.yml)
* [lecture10_Application.yml](./lecture10-templates/lecture10_Application.yml)

## コンソール画面にて構築した環境を確認
### ネットワーク関連

リソース
![ネットワーク](./lecture10-images/10-01_resouce_Network.png)

* VPC
![VPC](./lecture10-images/10-02_VPC.png)

* インターネットゲートウェイ
![IGW](./lecture10-images/10-03_IGW.png)

* サブネット
![サブネット](./lecture10-images/10-04_subnet.png)


### セキュリティ関連

リソース
![セキュリティ](./lecture10-images/10-05_resource_Security.png)

* セキュリティグループ全般
![SG](./lecture10-images/10-06_SG.png)

* EC2セキュリティグループ
![EC2-SG](./lecture10-images/10-07_EC2SG.png)

* RDSセキュリティグループ
![RDS-SG](./lecture10-images/10-08_RDSSG.png)

* ALBセキュリティグループ
![ALB-SG](./lecture10-images/10-09_ALBSG.png)

* IAMロール：AmazonS3FullAccessを許可
![IAMロール](./lecture10-images/10-10_IAMrole.png)


### アプリケーション関連

リソース
![アプリケーション](./lecture10-images/10-11_resouce_Application.png)

* EC2
![EC2](./lecture10-images/10-12_EC2.png)

* RDS
![RDS](./lecture10-images/10-13_RDS.png)

* ALB
![ALB](./lecture10-images/10-14_ALB.png)

* ALBターゲットグループ
![ALB-TG](./lecture10-images/10-15_ALBTG.png)

* S3バケット
![S3](./lecture10-images/10-16_S3.png)


## 第１０回講座・課題作成で学んだこと
### 講座での学び
* Infrastructure as Code (IaC)：インフラ自動化の前提であり、インフラ環境を全てコードで表現するという考え方
* クラウドサービスはAWSの他にAzure（Microsoft社）、Google Cloudがある。
* 自動化のメリットとして「再現性」が挙げられ、問題解決の利点、再現の速さ、環境が仮想化されていることによるサーバー管理が不要といったことによるコスト削減が可能。また、コードで管理されていることによってバージョン管理も可能。しかしデメリットとして自動化のための人員確保が必要である。

### 課題作成時における学び
実際にCloudFormationのテンプレートファイルやスタックを作成することによって各々のリソースの役割やつながりを理解することができた。
* CloudFormationで用いる組み込み関数は下記を活用した。
    * `!Sub`：入力文字列の変数を、指定した値に置き換える。変数は`${MyVarName}`として書き込む。
    * `!Ref`：指定したパラメータまたはリソースの値を返す。
    * `!ImportValue`：別のスタックによってエクスポートされた出力の値を返す。（クロススタック参照）
    * `Base64`：`UserData`プロパティを介して AmazonEC2インスタンスにエンコードされたデータを渡す。

* .ymlファイルを作成する際にインデントの誤りで多数エラーを経験した。参照元をコピー＆ペーストをするとインデントがずれることもあったため、テンプレート作成時には気をつけたい。
