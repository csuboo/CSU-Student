#!/bin/bash
USER_ID=""
PASSWORD=""
logger -t web-login "开始检测网络连通状态"
KEYWORD=$(curl -s http://baidu.com | grep meta)
echo ${KEYWORD}
if [[ "$(printf '%s' "${KEYWORD}")" == '' ]]; then
  logger -t web-login "网络未联通，尝试自动认证"
  # 不同机器所使用的命令可能略有差异,可以获取到本机IP即可
  CURRENT_IP=$(hostname -I | awk '{print $2}')
  LOGIN_STATUS=$(curl -s -X GET "https://portal.csu.edu.cn:802/eportal/portal/login?callback=dr1004&login_method=1&user_account=%2C0%2C${USER_ID}%40cmccn&user_password=${PASSWORD}&wlan_user_ip=${CURRENT_IP}&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=4.1.3&terminal_type=1&lang=zh-cn&v=2981&lang=zh" \
  -H 'authority: portal.csu.edu.cn:802' \
  -H 'accept: */*' \
  -H 'accept-language: zh-CN,zh;q=0.9' \
  -H 'cache-control: no-cache' \
  -H 'pragma: no-cache' \
  -H 'referer: https://portal.csu.edu.cn/' \
  -H 'sec-ch-ua: "Google Chrome";v="105", "Not)A;Brand";v="8", "Chromium";v="105"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "Windows"' \
  -H 'sec-fetch-dest: script' \
  -H 'sec-fetch-mode: no-cors' \
  -H 'sec-fetch-site: same-site' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36' \
  --compressed
  )  # 含有变量时只能使用双引号
  SUCCESS=$(echo ${LOGIN_STATUS} | grep 认证成功 )
  if [[ "$(printf '%s' "${SUCCESS}")" != '' ]]; then
    logger -t web-login "自动认证成功"
  else
    logger -t web-login "自动认证失败，请手动认证或检查配置文件"
  fi
else
  logger -t web-login "检测到Intenet连接状态正常"
fi
