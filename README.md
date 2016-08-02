# 概要
- サイボウズの予定をcrawlingして予定5分前にslackに通知するmac用スクリプトです
- 平日の朝9:53に,サイボウズをcarwlingして,5分前の時刻にremindするjobをatコマンドに登録します
- ただし、パソコンがスリープ状態・シャットダウン状態の時は、すでに登録されているreminderに限ってスリープ解除・起動時に通知されます
- 同様に、9:53の時点でパソコンがスリープ状態であったとしても、reminderを登録するスクリプトはスリープ解除時に実行されます
　(ただし、スリープ解除時刻より早い予定のリマインダーは登録されません)

# インストール
1. [ここ](http://qiita.com/tt2004d/items/50d79d1569c0ace118d6)を参考に、slackに対してmessageを送るためのurlを取得してください

2. 以下のスクリプトを実行する 

```
git clone https://github.com/cznagao-kazuma/cybozu2slack4mac.git
sh cybozu2slack4mac/install.sh
```

# 設定の変更
- cybozu2slack4mac/resource/envを編集すると次回分から設定が反映されます

# reminderの確認
- atコマンドを使います
- 一覧表示 `at -l` または `atq`
- 詳細確認 `at -c job番号`
- 削除　　 `at -r job番号`
- 全件削除 `at -r $(atq | cut -f1)`

# ログ
- slack.log : slackに送ったメッセージが出力されます
- register_command.log: atコマンドに登録するときのコマンドが出力されます
- register_info.log: atコマンドにjobを登録したときのlogが出力されます

# コマンドの詳細
## regist_reminder
- cybozuコマンドとsend2slackコマンドを使ってリマインドを登録するコマンド
- cybozuに登録されている予定5分前にslackに通知するjobをatコマンドに登録します

## cybozu
- **usage** `cybozu [-p] [-d day] [account_name] [password]`
- cybozuから予定をcralwingします.
- cookieが残っている場合はそれを使ってログインします
- account_nameとpasswordを省略した場合かつcookieでloginできない場合は入力を求められます.
- 予定の時間がかぶっている場合は行頭に「∆」がつきます
- pオプションをつけると予定が被っていても「∆」をつけずに出力します
- dオプションで今日を基準とした相対的な日付を指定できます(デフォルトはコマンドを実行した日)
  - -d0 コマンドを実行したその日の予定
  - -d1 コマンドを実行した次の日の予定
- **ただし-dオプションで指定できるのは6日先までで,それ以降は取得できません**

結果例

```
11:00-11:15  MTG_A
17:00-18:00  開発MTG＠2F
∆ 18:30-19:00  MTG_B
∆ 18:45-19:00  MTG_C
```

## send2slack
- **usage** `send2slack [-i bot_icon] [-n bot_name] [-c channel] [-b] url message`
- bオプションをつけるとバッククウォートでmessageを囲って送信します。(message => ```message```)
- パイプ越しに渡すこともできます

```
echo "hahaha!" | send2slack url
```

- 各オプションを省略した場合はデフォルト値が適用されます

| option | default |
|:------:|:-------:|
| icon   | ghost   |
| name   | my_bot  |
| channel | trash |

- urlを固定したい場合は以下のようなラップコマンドを作ってださい

```
#!/bin/sh
url=###################### ここにurlを入力
send2slack=############### send2slackの絶対パス

#デフォルト値
icon=ghost
name=my_bot
channel=trash

while getopts i:n:c:b opt; do
  case $opt in
    'i') icon="$OPTARG" ;;
    'n') name=$OPTARG ;;
    'c') channel=$OPTARG ;;
    'b') back_quote="-b" ;;
  esac
done

shift $((OPTIND - 1))

echo "${*:-$(cat -)}" |\
  $send2slack -i"$icon"  -n"$name" -c"$channel" $back_quote "$url"
```
