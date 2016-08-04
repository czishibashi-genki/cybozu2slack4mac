#!/bin/sh
#Project_Root_Dir
prd=$(cd $(dirname $0) && pwd)
mkdir $prd/log
mkdir $prd/resource

env_file=$prd/resource/env

cat <<EOF >$env_file
# "#"で始まる文をいじると動かなくなる可能性があります
# (/^ *#|^ *$/という正規表現に当てはまらない部分を読み込むので)
# なるべく触らないでください

### slack settings ###
# messageを送るapiのurl
slack_url = 

# botが送信するchannelの設定
channel = trash 

# botのアイコンの設定
bot_icon = nagao

# botの名前の設定
bot_name = my_bot

### cybozu settings ###
# サイボウズのアカウント
cybozu_account = 

# サイボウズのパスワード
cybozu_password = 

### その他の設定 ###
# 非公開の予定がslackに表示されるかどうか
# true  => 10:00-19:00  超極秘MTG(非公開)
# false => 10:00-19:00  (非公開)
is_visible_private_schedule = false

EOF

vim $env_file

chmod 755 $(find $prd/src/)
echo "atコマンドを有効にするために以下のコマンドを実行します."
echo "sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.atrun.plist"
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.atrun.plist

echo "bash $prd/src/regist_reminder" | at $(date -v+3M +"%R %D")
echo "install完了しました。3分後に動き始めます。"
