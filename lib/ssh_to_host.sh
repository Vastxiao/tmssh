# ssh_to_host.sh

# use: check_host_data_option 选项(如-A)
check_host_data_option() {

  # 处理 hosts.txt 中的选项
  local i=""
  i="${TMSSH_host_data_opts//$1/=@=}"
  i="${i%=*}"
  i="${i#*=}"
  if [[ "$i" == "@" ]];then
    return 0
  else
    return 1
  fi
}

# use: get_host_data_option_value 选项(如-A)
get_host_data_option_value() {
  local option_v=""
  option_v=${TMSSH_host_data_opts##*$1}
  option_v=${option_v#*[[:space:]]}
  option_v=${option_v%%[[:space:]]*}
  #option_v="$1 ${option_v}"
  echo "${option_v}"
}

check_ssh_options() {

  # 处理选项 -A
  if [[ "$TMSSH_OPTION_A" == "1" ]];then
    TMSSH_ssh_a="-A"
  else
    # 拿hosts.txt中配置项 -A
    check_host_data_option -A
    [[ "$?" == 0 ]] && TMSSH_ssh_a="-A"
  fi

  # 处理选项 -n
  local j=0
  if [[ "$TMSSH_OPTION_N" != "1" ]];then
    # 拿hosts.txt中配置项 -n
    check_host_data_option -n
    if [[ "$?" == 0 ]];then
      j=$(get_host_data_option_value -n)
    fi
  else
    j=$TMSSH_IP_OFFSET
  fi
  #j=${j//\'/}
  if [[ $j != 0 ]];then
    # 获取 TMSSH_HOST_DATA
    TMSSH_ssh_host="${TMSSH_HOST_DATA%%[[:space:]]*}"
    #for ((OPTION_N=1;$OPTION_N<${TMSSH_IP_OFFSET};OPTION_N++))
    local i
    for ((i=1;$i<$j;i++))
    do
      TMSSH_ssh_host="${TMSSH_ssh_host#*/}"
    done
    TMSSH_ssh_host="${TMSSH_ssh_host%%/*}"
  else
    TMSSH_ssh_host="$TMSSH_HOST"
  fi

  # 处理选项 -u
  if [[ "$TMSSH_OPTION_U" == "1" ]];then
    TMSSH_ssh_u="${TMSSH_USERNAME}@"
  else
    # 拿hosts.txt中配置项 -u
    check_host_data_option -u
    if [[ $? == 0 ]];then
      TMSSH_ssh_u="$(get_host_data_option_value -u)@"
    elif [[ $TMSSH_SSH_USER != "" ]];then
      TMSSH_ssh_u="${TMSSH_SSH_USER}@"
    fi
  fi

  # 处理选项 -i
  if [[ "$TMSSH_OPTION_I" == "1" ]];then
    TMSSH_ssh_i="-i ${TMSSH_IDENTITY_FILE}"
  else
    # 拿hosts.txt中配置项 -i
    check_host_data_option -i
    if [[ $? == 0 ]];then
      TMSSH_ssh_i="-i $(get_host_data_option_value -i)"
    fi
  fi

  # 处理选项 -p
  if [[ "$TMSSH_OPTION_P" == "1" ]];then
    TMSSH_ssh_p="-p ${TMSSH_PORT}"
  else
    # 拿hosts.txt中配置项 -p
    check_host_data_option -p
    if [[ $? == 0 ]];then
      TMSSH_ssh_p="-p $(get_host_data_option_value -p)"
    fi
  fi

  # 处理选项 -w
  if [[ "${TMSSH_USE_TMUX_SESSION_NAME}" == "" ]] && [[ "$TMSSH_OPTION_W" == "1" ]];then
    TMSSH_ssh_w="$TMSSH_TMUX_WINDOW_NAME"
  else
    # 拿hosts.txt中配置项 -p
    check_host_data_option -w
    if [[ $? == 0 ]];then
      TMSSH_ssh_w="$(get_host_data_option_value -w)"
    else
      TMSSH_ssh_w=${TMSSH_HOST}
    fi
  fi
}


# ---------- #
# start main #
# ---------- #

# 读取TMSSH_HOST的数据
source ${TMSSH_HOME%/}/lib/get_hosts_data.sh host_data

# TMSSH_host_data_opts 是 MSSH_HOST_DATA 的选项
TMSSH_host_data_opts=$(echo $TMSSH_HOST_DATA) #不加引号只保留一个空格
TMSSH_host_data_opts=${TMSSH_host_data_opts#*[[:space:]]} #去掉ip的项
TMSSH_host_data_opts=${TMSSH_host_data_opts#*[[:space:]]} #去掉group的项
TMSSH_host_data_opts=${TMSSH_host_data_opts//=/}
TMSSH_host_data_opts=${TMSSH_host_data_opts//@/}
#echo ${TMSSH_host_data_opts}

TMSSH_ssh_a=""
TMSSH_ssh_host=""
TMSSH_ssh_u=""
TMSSH_ssh_i=""
TMSSH_ssh_p=""
TMSSH_ssh_w=""
check_ssh_options

TMSSH_ssh_cmd="ssh ${TMSSH_ssh_a} ${TMSSH_ssh_i} ${TMSSH_ssh_p} ${TMSSH_ssh_u}${TMSSH_ssh_host}"
TMSSH_ssh_cmd=$(echo $TMSSH_ssh_cmd) #不加引号只保留一个空格
#echo $TMSSH_ssh_cmd

if [[ "${TMSSH_USE_TMUX_SESSION_NAME}" != "" ]];then
  tmux has-session -t "=$TMSSH_USE_TMUX_SESSION_NAME" &>/dev/null
  if [ $? -ne 0 ];then
    tmux new-session -d -s $TMSSH_USE_TMUX_SESSION_NAME -n tmssh_init
  else
    tmux new-window -d -t "=${TMSSH_USE_TMUX_SESSION_NAME}" -n tmssh_init
  fi
  #sleep 0.2
  tmux send-keys -t "=${TMSSH_USE_TMUX_SESSION_NAME}:=tmssh_init" "${TMSSH_ssh_cmd}"
  tmux send-keys -t "=${TMSSH_USE_TMUX_SESSION_NAME}:=tmssh_init" "C-m"
  tmux rename-window -t "=${TMSSH_USE_TMUX_SESSION_NAME}:=tmssh_init" ${TMSSH_ssh_w}
else
  # ssh host到当前shell
  source ${TMSSH_HOME%/}/lib/check_tmux_terminal.sh
  if [ $? -eq 0 ];then
    # 在tmux中, 当前panes只有一个，就rename window name
    [[ "$(tmux show-options -qwv automatic-rename)" != "off" ]] && tmux rename-window ${TMSSH_ssh_w}
  fi
  exec ${TMSSH_ssh_cmd}
fi

unset TMSSH_HOST_DATA TMSSH_host_data_opts TMSSH_ssh_a TMSSH_ssh_host TMSSH_ssh_u TMSSH_ssh_i TMSSH_ssh_p TMSSH_ssh_w TMSSH_ssh_cmd


