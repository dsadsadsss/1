#!/bin/bash
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

while [ ! -s "/tmp/list.log" ]; do
    sleep 1  # 每秒检查一次文件是否存在
done
echo "===========部署完成，复制下面节点即可=========="
cat "/tmp/list.log"
echo "=================================="
echo ""
echo "         祝你玩的愉快!开开心心     "
wait
