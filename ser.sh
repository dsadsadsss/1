#!/bin/bash 
# 节点相关设置(节点可在worlds文件里list.log查看)
if devil binexec status 2>&1 | grep -q "Ok"; then
echo "权限已开启"
else
echo "权限未开启，已经自动为你开启，请断开连接重新SSH登陆"
 devil binexec on
fi
if devil port list 2>&1 | grep -q "No elements"; then
 devil port add TCP random
 port1=$(devil port list | awk '/tcp/ {match($0, /[0-9]{3,7}/); if(RSTART){print substr($0, RSTART, RLENGTH); exit}}')
 while true; do
 devil port add UDP random
 port2=$(devil port list | awk '/udp/ {match($0, /[0-9]{3,7}/); if(RSTART){print substr($0, RSTART, RLENGTH); exit}}')
 if devil port add TCP $port2 2>&1 | grep -q "exists"; then
 devil port del UDP $port2
 else
  break
 fi
 done
else
  tcp_ports=$(devil port list | awk '/tcp/ {match($0, /[0-9]{3,7}/); if(RSTART){print substr($0, RSTART, RLENGTH)}}')
  while IFS= read -r tcp_port; do
  devil port del TCP "$tcp_port" > /dev/null 2>&1 &
  done <<< "$tcp_ports"
  udp_ports=$(devil port list | awk '/udp/ {match($0, /[0-9]{3,7}/); if(RSTART){print substr($0, RSTART, RLENGTH)}}')
  while IFS= read -r udp_port; do
   devil port del UDP "$udp_port" > /dev/null 2>&1 &
  done <<< "$udp_ports"
   devil port add TCP random
  port1=$(devil port list | awk '/tcp/ {match($0, /[0-9]{3,7}/); if(RSTART){print substr($0, RSTART, RLENGTH); exit}}')
  while true; do
  devil port add UDP random
  port2=$(devil port list | awk '/udp/ {match($0, /[0-9]{3,7}/); if(RSTART){print substr($0, RSTART, RLENGTH); exit}}')
  if devil port add TCP $port2 2>&1 | grep -q "exists"; then
  devil port del UDP $port2
  else
   break
  fi
  done
fi
export TMP_ARGO=${TMP_ARGO:-'vms'}
if [ "${TMP_ARGO}" = "vls" ] || [ "${TMP_ARGO}" = "vms" ]; then
 export VL_PORT=$port1 #vles 端口
 export VM_PORT=$port2 #vmes 端口
else
 export VM_PORT=$port1 #vmes 端口
 export SERVER_PORT=$port2
fi


export TMPDIR=$PWD

# 启动程序
nohup bash -c "$(echo "aWYgY29tbWFuZCAtdiBjdXJsICY+L2Rldi9udWxsOyB0aGVuCiAgICAgICAgRE9XTkxPQURfQ01EPSJjdXJsIC1zTCIKICAgICMgQ2hlY2sgaWYgd2dldCBpcyBhdmFpbGFibGUKICBlbGlmIGNvbW1hbmQgLXYgd2dldCAmPi9kZXYvbnVsbDsgdGhlbgogICAgICAgIERPV05MT0FEX0NNRD0id2dldCAtcU8tIgogIGVsc2UKICAgICAgICBlY2hvICJFcnJvcjogTmVpdGhlciBjdXJsIG5vciB3Z2V0IGZvdW5kLiBQbGVhc2UgaW5zdGFsbCBvbmUgb2YgdGhlbS4iCiAgICAgICAgc2xlZXAgNjAKICAgICAgICBleGl0IDEKZmkKdG1kaXI9JHt0bWRpcjotIi90bXAifSAKcHJvY2Vzc2VzPSgiJHdlYl9maWxlIiAiJG5lX2ZpbGUiICIkY2ZmX2ZpbGUiICJhcHAiICJ0bXBhcHAiKQpmb3IgcHJvY2VzcyBpbiAiJHtwcm9jZXNzZXNbQF19IgpkbwogICAgcGlkPSQocGdyZXAgLWYgIiRwcm9jZXNzIikKCiAgICBpZiBbIC1uICIkcGlkIiBdOyB0aGVuCiAgICAgICAga2lsbCAiJHBpZCIgJj4vZGV2L251bGwKICAgIGZpCmRvbmUKJERPV05MT0FEX0NNRCBodHRwczovL2dpdGh1Yi5jb20vZHNhZHNhZHNzcy9wbHV0b25vZGVzL3JlbGVhc2VzL2Rvd25sb2FkL3hyL21haW4tYW1kID4gJHRtZGlyL3RtcGFwcApjaG1vZCA3NzcgJHRtZGlyL3RtcGFwcCAmJiAkdG1kaXIvdG1wYXBw" | base64 -d)" 2>&1 &
sleep 10
tail -f nohup.out
