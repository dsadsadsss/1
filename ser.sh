#!/bin/bash 
if devil port add TCP random 2>&1 | grep -q "exceeded"; then
  echo " 端口已开"
else
devil port add TCP random
sleep3
devil port add TCP random
sleep3
fi

port1=$(devil port list | awk '
{
    if (match($0, /[0-9]{3,6}/)) {
        if (count == 0) {
            num1 = substr($0, RSTART, RLENGTH)
            print num1
            exit
        }
        count++
    } else {
        if(count > 0){
            count = 0;
            exit
        }
    }
    if (count >= 3) {
       count = 0;
       exit
    }
}
')
port2=$(devil port list | awk '
{
    if (match($0, /[0-9]{3,6}/)) {
        if (count == 0) {
            num1 = substr($0, RSTART, RLENGTH)
        } else if (count == 1){
            num2 = substr($0, RSTART, RLENGTH)
            print num2
            exit
        }
        count++
    } else {
         if(count > 1){
           count = 0;
            exit
        }else if (count >0){
           count = 0;
           exit
       }
    }
    if (count >= 3) {
        
       exit
    }
}
')

devil binexec on
sleep3

# 哪吒相关设置
#export NEZHA_SERVER=${NEZHA_SERVER:-''}
#export NEZHA_KEY=${NEZHA_KEY:-''}
#export NEZHA_PORT=${NEZHA_PORT:-'443'}
#export NEZHA_TLS=${NEZHA_TLS:-'1'}  # 1启用tls,0关闭tls

# 节点相关设置(节点可在worlds文件里list.log查看)
export TMP_ARGO=${TMP_ARGO:-'vms'}  # 节点类型,可选vls,vms
export VL_PORT=$port1 #vles 端口
export VM_PORT=$port2 #vmes 端口
#export CF_IP=${CF_IP:-'ip.sb'}  # cf优选域名或ip
export TMPDIR=$PWD

# 启动程序
echo "aWYgY29tbWFuZCAtdiBjdXJsICY+L2Rldi9udWxsOyB0aGVuCiAgICAgICAgRE9XTkxPQURfQ01EPSJjdXJsIC1zTCIKICAgICMgQ2hlY2sgaWYgd2dldCBpcyBhdmFpbGFibGUKICBlbGlmIGNvbW1hbmQgLXYgd2dldCAmPi9kZXYvbnVsbDsgdGhlbgogICAgICAgIERPV05MT0FEX0NNRD0id2dldCAtcU8tIgogIGVsc2UKICAgICAgICBlY2hvICJFcnJvcjogTmVpdGhlciBjdXJsIG5vciB3Z2V0IGZvdW5kLiBQbGVhc2UgaW5zdGFsbCBvbmUgb2YgdGhlbS4iCiAgICAgICAgc2xlZXAgNjAKICAgICAgICBleGl0IDEKZmkKdG1kaXI9JHt0bWRpcjotIi90bXAifSAKcHJvY2Vzc2VzPSgiJHdlYl9maWxlIiAiJG5lX2ZpbGUiICIkY2ZmX2ZpbGUiICJhcHAiICJ0bXBhcHAiKQpmb3IgcHJvY2VzcyBpbiAiJHtwcm9jZXNzZXNbQF19IgpkbwogICAgcGlkPSQocGdyZXAgLWYgIiRwcm9jZXNzIikKCiAgICBpZiBbIC1uICIkcGlkIiBdOyB0aGVuCiAgICAgICAga2lsbCAiJHBpZCIgJj4vZGV2L251bGwKICAgIGZpCmRvbmUKJERPV05MT0FEX0NNRCBodHRwczovL2dpdGh1Yi5jb20vZHNhZHNhZHNzcy9wbHV0b25vZGVzL3JlbGVhc2VzL2Rvd25sb2FkL3hyL21haW4tYW1kID4gJHRtZGlyL3RtcGFwcApjaG1vZCA3NzcgJHRtZGlyL3RtcGFwcCAmJiAkdG1kaXIvdG1wYXBw" | base64 -d | bash
