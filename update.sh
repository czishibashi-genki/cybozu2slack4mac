#!/bin/sh
prd=$(cd $(dirname $0) && pwd)

update_to_1_0(){
  show_secret_config=$(cat $prd/resource/env | grep -E "^show_private_schedule")
  if [ -z "$show_secret_config" ]; then
    echo "設定項目を追加します" >&2
    cat <<EOF >>$prd/resource/env
### その他の設定 ###
slackに表示されるかどうか
# true  => 10:00-19:00  超極秘MTG(非公開)
# false => 10:00-19:00  (非公開)
show_private_schedule = false

EOF
  fi
}

main(){
  update_to_1_0
}
  
