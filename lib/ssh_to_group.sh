# ssh_to_groups.sh

type -p tmux &>/dev/null
[ $? -ne 0 ] && echo "${TMSSH_HOME%/}/lib/ssh_to_groups.sh ERROR: command tmux not found." 1>&2 && return 1

# 禁用选项
TMSSH_OPTION_W=0
TMSSH_OPTION_N=0

# 获取session name
TMSSH_USE_TMUX_SESSION_NAME=""
if [[ $TMSSH_OPTION_S == 1 ]];then
  TMSSH_USE_TMUX_SESSION_NAME=$TMSSH_TMUX_SESSION_NAME
else
  TMSSH_USE_TMUX_SESSION_NAME=$TMSSH_GROUP
fi

# 检测tmux session中如果没有group就创建
tmux has-session -t "=$TMSSH_USE_TMUX_SESSION_NAME" &>/dev/null
if [ $? -ne 0 ];then
  # 获取group的所有hosts
  source ${TMSSH_HOME%/}/lib/get_hosts_data.sh group_hosts
  tmssh_host_list="$(echo -e "${TMSSH_GROUP_HOSTS}" |sed 's#[[:space:]].*$##g;s#/.*$##g')"
  for i in $tmssh_host_list
  do
    TMSSH_HOST=$i
    #echo $TMSSH_HOST
    source ${TMSSH_HOME%/}/lib/ssh_to_host.sh
  done
fi

# 最后切换到group
source ${TMSSH_HOME%/}/lib/check_tmux_terminal.sh
if [ $? -eq 0 ];then
  # 在tmux中
  tmux switch-client -t "=$TMSSH_USE_TMUX_SESSION_NAME"
else
  # 不在tmux中
  tmux attach-session -t "=$TMSSH_USE_TMUX_SESSION_NAME"
fi

unset TMSSH_USE_TMUX_SESSION_NAME


