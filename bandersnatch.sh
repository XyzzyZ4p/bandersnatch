#!/bin/bash
# bandersnatch.sh
set -m

HOST='127.0.0.1'
PORT='8000'

# shellcheck disable=SC2317  # Don't warn about unreachable commands in this function
function handler {
  local pid
  
  pid=$1
  echo -en '\bSTOP\nKill Server: '
  kill -9 "$pid" && echo 'OK'
}

cat << EOF

██████╗  █████╗ ███╗   ██╗██████╗ ███████╗██████╗ ███████╗███╗   ██╗ █████╗ ████████╗ ██████╗██╗  ██╗
██╔══██╗██╔══██╗████╗  ██║██╔══██╗██╔════╝██╔══██╗██╔════╝████╗  ██║██╔══██╗╚══██╔══╝██╔════╝██║  ██║
██████╔╝███████║██╔██╗ ██║██║  ██║█████╗  ██████╔╝███████╗██╔██╗ ██║███████║   ██║   ██║     ███████║
██╔══██╗██╔══██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗╚════██║██║╚██╗██║██╔══██║   ██║   ██║     ██╔══██║
██████╔╝██║  ██║██║ ╚████║██████╔╝███████╗██║  ██║███████║██║ ╚████║██║  ██║   ██║   ╚██████╗██║  ██║
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝

by XyzzyZ4p
version: 0.1
revision: 04/28/2023

EOF

echo -n 'Start Server: '
python3 -m http.server -b $HOST $PORT &> /dev/null &
server_pid=$!
echo 'OK'

echo -n 'Run Browser: '
chromium --allow-file-access-from-files bandersnatch.html &> /dev/null &
browser_pid=$!
echo 'OK'

stty_orig=$(stty -g)
stty -echo
tput civis

i=1
sp='/-\|'
echo -n 'Running:  '
while kill -0 $browser_pid &> /dev/null; do
  printf "%s" "${sp:i++%${#sp}:1}"
  echo -en "\033[$1D"
  sleep 1
done

trap 'handler $server_pid 2> /dev/null' EXIT
tput cnorm
stty "$stty_orig"
exit $?
