require 'spec_helper'

listen_port = 80 # 80に変更

# nginxがインストールされているか確認
describe package('nginx') do
  it { should be_installed }
end

# 指定したポートがリッスンされているかどうかを確認
describe port(listen_port) do
  it { should be_listening }
end

# HTTPリクエストを送った際に正常な応答が得られるかを確認。ステータスコード200はHTTPリクエストが成功したことを示す。
describe command('curl http://127.0.0.1:#{listen_port}/_plugin/head/ -o /dev/null -w "%{http_code}\n" -s') do
  its(:stdout) { should match /^200$/ }
end

# Railsが指定したバージョンでインストールされているか確認 
describe command('rails --version') do
  its(:stdout) { should match /Rails (\d+\.\d+\.\d+)/ }
  its(:stdout) { should match /Rails 7\.0\.4/ }
end

# MySQLのサービスが正常に稼働している
describe service('mysqld') do
  it { should be_enabled   }
end
