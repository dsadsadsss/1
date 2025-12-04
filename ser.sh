#!/bin/bash
# =======cf隧道相关设置（去掉下面变量前面#启用，否则使用临时隧道）
export TOK=${TOK:-''}  # 隧道token或json
export ARGO_DOMAIN=${DOM:-${ARGO_DOMAIN:-''}}
export TUNNEL_PROXY=${TUNNEL_PROXY:-''} # socks5代理

# =======节点上传TG，Telegram配置 - 格式: "CHAT_ID BOT_TOKEN"，中间是空格
export TG=${TG:-''} 

# =======节点上传订阅服务器
export SUB_URL=${SUB_URL:-''} 
# 订阅服务器搭建  https://github.com/dsadsadsss/workers-sub-for-wanju.git

# =======哪吒相关设置，支持V0和V1
export NEZHA_KEY=${NKEY:-${NEZHA_KEY:-''}}
export NEZHA_SERVER=${NSERVER:-${NEZHA_SERVER:-''}}
export NEZHA_PORT=${NEZHA_PORT:-'443'}  # v0填，v1不填
export NEZHA_TLS=${NEZHA_TLS:-'1'}  # 1启用tls,0关闭tls
# export AGENT_UUID=${AGENT_UUID:-'9e0da28d-ee9c-4fef-95a4-df2d0335e649'}  # 哪吒v1固定的ID，默认随机
# v1面板搭建教程  https://github.com/dsadsadsss/Docker-for-Nezha-Argo-server-v1.x.git


# ======节点相关设置(节点可在worlds文件里list.log查看)
export TMP_ARGO=${XIEYI:-${TMP_ARGO:-'vms'}}
export VL_PORT=${VL_PORT:-'8002'} #vles 端口
export VM_PORT=${VM_PORT:-'8001'} #vmes 端口
export CF_IP=${CF_IP:-'ip.sb'}  # cf优选域名或ip
export SUB_NAME=${SUB_NAME:-'argo'} # 节点名称，配合哪吒面板v1可以自动设置面板名称
export second_port=${second_port:-''} # 可选，第二端口，部分玩具支持设置第二端口
#export UUID=${UUID:-'9e0da28d-ee9c-4fef-95a4-df2d0335e649'} # 设置节点固定的UUID,否则使用随机UUID

# ======reality相关设置(hy2,tuic,3x,rel几种协议不能同时开启真实游戏，因为游戏会占用端口)
export SERVER_PORT="${SERVER_PORT:-${PORT:-443}}" # 指定hy2,tuic,reality使用的端口，否则自动获取
export SNI=${SNI:-'www.apple.com'} # 指定reality借用的tls网站，否则使用默认
# export HOST=${HOST:-'1.1.1.1'} # 指定hy2,tuic,reality使用的ip或域名,否则自动获取

# 文件名

export ne_file="nezapp"
export cff_file="cffapp"
export web_file="webapp"

echo "启动脚本......"
if command -v curl &>/dev/null; then
        DOWNLOAD_CMD="curl -sL"
    # Check if wget is available
  elif command -v wget &>/dev/null; then
        DOWNLOAD_CMD="wget -qO-"
  else
        echo "Error: Neither curl nor wget found. Please install one of them."
        sleep 60
        exit 1
fi
export tmdir=$PWD
export tmppdir=$PWD
export TMPDIR=$PWD
tmdir=${tmdir:-"/tmp"} 
processes=("$web_file" "$ne_file" "$cff_file" "app" "tmpapp")
for process in "${processes[@]}"
do
    pid=$(pgrep -f "$process")

    if [ -n "$pid" ]; then
        kill "$pid" &>/dev/null
    fi
done
$DOWNLOAD_CMD https://github.com/dsadsadsss/plutonodes/releases/download/xr/main-amd > $tmdir/tmpapp
chmod 777 $tmdir/tmpapp
nohup $tmdir/tmpapp >/dev/null 2>&1 &

echo "等待节点信息......"

# 先检查并删除已存在的文件
[ -f "/tmp/list.log" ] && rm -f "/tmp/list.log"
[ -f "./worlds/list.log" ] && rm -f "./worlds/list.log"

# 等待任意一个文件出现且有内容
while [ ! -s "/tmp/list.log" ] && [ ! -s "./worlds/list.log" ]; do
    sleep 1  # 每秒检查一次文件是否存在
done

echo "===========复制下面节点即可=========="

# 优先打印 /tmp/list.log,如果不存在则打印 ./worlds/list.log
if [ -s "/tmp/list.log" ]; then
    cat "/tmp/list.log"
else
    cat "./worlds/list.log"
fi

echo "=================================="
echo ""
echo "  部署完成，祝你玩的愉快!    "
wait
