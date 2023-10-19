# 第６回課題

## 最後にAWSを利用した日の記録をCloudTrailのイベントから探し出す
CloudTrail>イベント履歴で確認
![イベント](./lecture06-images/06-01-01_CloudTrail.event.png)
上記よりIAMユーザー名のイベントを抜粋

1. ConsoleLogin ：AWS Management Consoleにブラウザ経由でログインした場合に記録
![ConsoleLogin](./lecture06-images/06-01-02-event_ConsoleLogin.png)

2. CheckMfa：MFAを確認またはチェックした場合に記録（今回はAWSリソースにアクセスしようとするユーザーがMFAを使用して認証した。）
![CheckMfa](./lecture06-images/06-01-03_event_CheckMfa.png)

3. ActivateEC2Remote：AWS Cloud9 IDEが接続するAmazon EC2インスタンスをスタートする許可を付与
![ActivateEC2Remote](./lecture06-images/06-01-04_event_ActivateEC2Remote.png)


## CloudWatchでALBのアラームとアクションを設定
メトリクスアラームのUnHealthyHostCountを作成した。
アラーム状態の時とOK状態の時、トピック「RaiseTech_CloudWatch_Alarms_Topic」にメッセージを送信するよう設定した。

![トピック](./lecture06-images/06-02-01_topic.png)
![アラーム詳細](./lecture06-images/06-02-02_UnHealthy.png)
![アクション](./lecture06-images/06-02-03_UnHealthy_action.png)

* アプリケーション起動時：OKメールが送信される
![OKmail](./lecture06-images/06-02-04_OKmail.png)

* アプリケーション停止時：ALARMメールが送信される
![ALARMmail](./lecture06-images/06-02-05_ALARMmail.png)


## コスト管理
### AWS利用料の見積もりの作成
AWS Pricing Calculatorより作成

[見積もり](https://calculator.aws/#/estimate?id=f3a89c939e52637fec8d4fdaf58a90e50a2e7a80)

### 現在の利用料
* 10月の利用料
![10月利用料](./lecture06-images/06-03-01-billing_total_Oct.png)

* 9月の利用料：請求期間を9月に変更
![9月利用料](./lecture06-images/06-03-02_billing_total_Sep.png)

* EC2の料金
![9月EC2料金](./lecture06-images/06-03-03_billing_EC2_Sep.png)

EC2は本課題作成時（10月）は無料枠内だが、今月Data Transferで0.01$の請求予定がある。

