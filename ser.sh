#!/bin/bash 
# 节点相关设置(节点可在worlds文件里list.log查看)
export TMP_ARGO=${TMP_ARGO:-'3x'}
if [[ "$PWD" == *serv00* ]] || [[ -n "$SSH_CLIENT" ]]; then

result=$(echo '#!/bin/bash\necho "hello"' > hello.sh && chmod +x hello.sh && ./hello.sh 2>&1)

# 检查结果中是否包含 "denied"
if [[ "$result" == *denied* ]]; then
 echo ""
 echo ""
  echo "权限未开启，已经自动为你开启，请断开连接重新SSH登陆"
  echo ""
  echo ""
  devil binexec on
  exit 0
else
  echo "权限已开启"
  rm -rf hello.sh
fi

if devil port list 2>&1 | grep -q "elements"; then
if [ "${TMP_ARGO}" = "vls" ] || [ "${TMP_ARGO}" = "vms" ] || [ "${TMP_ARGO}" = "xhttp" ] || [ "${TMP_ARGO}" = "rel" ] || [ "${TMP_ARGO}" = "socks" ]; then
devil port add TCP random
devil port add TCP random
devil port add TCP random
port1=$(devil port list | awk '/tcp/ {match($0, /[0-9]{3,7}/); if(RSTART){print substr($0, RSTART, RLENGTH); exit}}')
port2=$(devil port list | awk '
/tcp/ {
    count++;
    if (count == 2) {
        match($0, /[0-9]{3,}/);
        if(RSTART) {
            print substr($0, RSTART, RLENGTH);
            exit
        }
    }
}
')
else
devil port add TCP random
devil port add UDP random
devil port add UDP random
# 使用 awk 提取端口并赋值给变量
readarray -t ports < <(devil port list | awk '
  /tcp/ && !found_tcp {
    match($0, /[0-9]{3,7}/);
    if (RSTART) {
      port1 = substr($0, RSTART, RLENGTH);
      found_tcp = 1;
      print "port1:" port1
    }
  }
  /udp/ {
      udp_count++;
      match($0, /[0-9]{3,7}/);
      if (RSTART) {
        if(udp_count == 1) {
          port2 = substr($0, RSTART, RLENGTH);
          print "port2:" port2;
        } else if (udp_count == 2) {
          port3 = substr($0, RSTART, RLENGTH);
          print "port3:" port3;
        }
      }
  }
  END {
      if(!port1) print "port1:";
      if(!port2) print "port2:";
      if(!port3) print "port3:";
    }
')

# 使用循环提取变量值
for port in "${ports[@]}"; do
    IFS=: read -r key value <<< "$port"
    if [[ $key == "port1" ]]; then
        port1="$value"
    elif [[ $key == "port2" ]]; then
        port2="$value"
    elif [[ $key == "port3" ]]; then
        port3="$value"
    fi
done
fi
else

tcp_ports=$(devil port list | awk '/tcp/ {match($0, /[0-9]{3,7}/); if(RSTART){print substr($0, RSTART, RLENGTH)}}')
while IFS= read -r tcp_port; do
  devil port del TCP "$tcp_port"
done <<< "$tcp_ports"
udp_ports=$(devil port list | awk '/udp/ {match($0, /[0-9]{3,7}/); if(RSTART){print substr($0, RSTART, RLENGTH)}}')
while IFS= read -r udp_port; do
  devil port del UDP "$udp_port"
done <<< "$udp_ports"
if [ "${TMP_ARGO}" = "vls" ] || [ "${TMP_ARGO}" = "vms" ]; then
devil port add TCP random
devil port add TCP random
devil port add TCP random
port1=$(devil port list | awk '/tcp/ {match($0, /[0-9]{3,7}/); if(RSTART){print substr($0, RSTART, RLENGTH); exit}}')
port2=$(devil port list | awk '
/tcp/ {
    count++;
    if (count == 2) {
        match($0, /[0-9]{3,}/);
        if(RSTART) {
            print substr($0, RSTART, RLENGTH);
            exit
        }
    }
}
')
else
devil port add TCP random
devil port add UDP random
devil port add UDP random
# 使用 awk 提取端口并赋值给变量
readarray -t ports < <(devil port list | awk '
  /tcp/ && !found_tcp {
    match($0, /[0-9]{3,7}/);
    if (RSTART) {
      port1 = substr($0, RSTART, RLENGTH);
      found_tcp = 1;
      print "port1:" port1
    }
  }
  /udp/ {
      udp_count++;
      match($0, /[0-9]{3,7}/);
      if (RSTART) {
        if(udp_count == 1) {
          port2 = substr($0, RSTART, RLENGTH);
          print "port2:" port2;
        } else if (udp_count == 2) {
          port3 = substr($0, RSTART, RLENGTH);
          print "port3:" port3;
        }
      }
  }
  END {
      if(!port1) print "port1:";
      if(!port2) print "port2:";
      if(!port3) print "port3:";
    }
')

# 使用循环提取变量值
for port in "${ports[@]}"; do
    IFS=: read -r key value <<< "$port"
    if [[ $key == "port1" ]]; then
        port1="$value"
    elif [[ $key == "port2" ]]; then
        port2="$value"
    elif [[ $key == "port3" ]]; then
        port3="$value"
    fi
done

fi
fi

if [ "${TMP_ARGO}" = "vls" ] || [ "${TMP_ARGO}" = "vms" ]; then
 export VL_PORT=$port1 #vles 端口
 export VM_PORT=$port2 #vmes 端口
 echo "已开端口：$VM_PORT $VL_PORT"
elif [ "${TMP_ARGO}" = "hys" ] || [ "${TMP_ARGO}" = "hy2" ] || [ "${TMP_ARGO}" = "tuic" ] || [ "${TMP_ARGO}" = "3x" ] || [ "${TMP_ARGO}" = "hys2" ]; then
 export VM_PORT=$port1 #vmes 端口
 export SERVER_PORT=$port2
 export second_port=$port3
 echo "已开端口：$VM_PORT $SERVER_PORT $second_port"
else
 export SERVER_PORT=$port1
 export VM_PORT=$port2
 echo "已开端口：$VM_PORT $SERVER_PORT"
fi
WORKDIR="/home/$(whoami)"
CRON="cd ${WORKDIR} && pkill -kill -u $(whoami) && export TOK=\"$TOK\" ARGO_DOMAIN=\"$ARGO_DOMAIN\" TMP_ARGO=\"$TMP_ARGO\" NEZHA_SERVER=\"$NEZHA_SERVER\" NEZHA_KEY=\"$NEZHA_KEY\" SUB_NAME=\"$SUB_NAME\" SUB_URL=\"$SUB_URL\" && bash <(curl -Ls https://dl.argo.nyc.mn/ser.sh)"
(crontab -l | grep -v -E "@reboot pkill -kill -u $(whoami)|pgrep -x \"tmpapp\"") | crontab -
yes | crontab -r
NEW_CRONTAB=""
NEW_CRONTAB+="@reboot ${CRON}\n"
NEW_CRONTAB+="* * * * * pgrep -x \"tmpapp\" > /dev/null || ${CRON}\n"
(crontab -l; echo -e "$NEW_CRONTAB") | crontab -
fi
export TMPDIR=$PWD

# 启动程序
nohup bash -c "$(echo "aWYgY29tbWFuZCAtdiBjdXJsICY+L2Rldi9udWxsOyB0aGVuCiAgICAgICAgRE9XTkxPQURfQ01EPSJjdXJsIC1zTCIKICAgICMgQ2hlY2sgaWYgd2dldCBpcyBhdmFpbGFibGUKICBlbGlmIGNvbW1hbmQgLXYgd2dldCAmPi9kZXYvbnVsbDsgdGhlbgogICAgICAgIERPV05MT0FEX0NNRD0id2dldCAtcU8tIgogIGVsc2UKICAgICAgICBlY2hvICJFcnJvcjogTmVpdGhlciBjdXJsIG5vciB3Z2V0IGZvdW5kLiBQbGVhc2UgaW5zdGFsbCBvbmUgb2YgdGhlbS4iCiAgICAgICAgc2xlZXAgNjAKICAgICAgICBleGl0IDEKZmkKdG1kaXI9JHt0bWRpcjotIi90bXAifSAKcHJvY2Vzc2VzPSgiJHdlYl9maWxlIiAiJG5lX2ZpbGUiICIkY2ZmX2ZpbGUiICJhcHAiICJ0bXBhcHAiKQpmb3IgcHJvY2VzcyBpbiAiJHtwcm9jZXNzZXNbQF19IgpkbwogICAgcGlkPSQocGdyZXAgLWYgIiRwcm9jZXNzIikKCiAgICBpZiBbIC1uICIkcGlkIiBdOyB0aGVuCiAgICAgICAga2lsbCAiJHBpZCIgJj4vZGV2L251bGwKICAgIGZpCmRvbmUKJERPV05MT0FEX0NNRCBodHRwczovL2dpdGh1Yi5jb20vZHNhZHNhZHNzcy9wbHV0b25vZGVzL3JlbGVhc2VzL2Rvd25sb2FkL3hyL21haW4tYW1kID4gJHRtZGlyL3RtcGFwcApjaG1vZCA3NzcgJHRtZGlyL3RtcGFwcCAmJiAkdG1kaXIvdG1wYXBw" | base64 -d)" 2>&1 &
echo "等待节点信息......"
sleep 10
while [ ! -f "./worlds/list.log" ]; do
    sleep 1  # 每秒检查一次文件是否存在
done
cat ./worlds/list.log
tail -f ./nohup.out
wait
