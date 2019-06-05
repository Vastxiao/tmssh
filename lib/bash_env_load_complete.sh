# bash_env_load_complete.sh
# 用于加载tmssh自动补全
# use: source bash_env_load_complete.sh
# return: none.

# 生成 tmssh命令 自动补全
#complete -W "$groups" tmssh

function _tmssh() {

  # 定义变量，当前命令，前置命令，选项
  #local cur prev opts
  local cur prev prev2

  # complete 内置变量，类型为数组，候选的补全结果。
  # 给COMPREPLY赋值之前，最好将它重置清空，避免被其它补全函数干扰。
  COMPREPLY=()

  # 当前输入命令内容
  cur="${COMP_WORDS[COMP_CWORD]}"
  # 前一个输入的命令内容
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  prev2="${COMP_WORDS[COMP_CWORD-2]}"


  # 处理补全规则
  if [[ $prev == tmssh ]] || [[ $prev == -* ]] || [[ $prev2 == -[npuisw] ]];then
    source ${TMSSH_HOME%/}/lib/get_hosts_data.sh groups
    COMPREPLY=( $(compgen -W "$TMSSH_GROUPS" -- ${cur}) )
  elif [[ "$prev2" != "-l" ]] && ! [[ $prev =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]];then
    TMSSH_GROUP=$prev
    source ${TMSSH_HOME%/}/lib/get_hosts_data.sh group_hosts
    COMPREPLY=( $(compgen -W "$(echo -e "${TMSSH_GROUP_HOSTS}" |sed 's@[[:space:]].*$@@;s@/.*$@@')" -- ${cur}) )
  fi
  unset TMSSH_GROUPS TMSSH_GROUPS_HOSTS
}
complete -F _tmssh tmssh

