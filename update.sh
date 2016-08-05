#!/bin/sh
prd=$(cd $(dirname $0) && pwd)

update_to_1_0(){
  show_secret_config=$(cat $prd/resource/env | grep -E "^show_private_schedule")
  if [ -z "$show_secret_config" ]; then
    cat <<EOF >>$prd/resource/env
### その他の設定 ###
# slackに表示されるかどうか
# true  => 10:00-19:00  超極秘MTG(非公開)
# false => 10:00-19:00  (非公開)
show_private_schedule = false

EOF
    echo "設定項目を追加しました。" >&2
    echo "設定の変更は以下のコマンドで実行できます" >&2
    echo "$prd/src/reminder -e" >&2
  fi
}

main(){
  update_to_1_0
}
  
main
