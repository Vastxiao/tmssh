# get_hosts_data.sh
#
# 功能: 加载变量到bash中,
#
# use: 
#      source get_hosts_data.sh [groups]         加载变量: TMSSH_GROUPS
#      source get_hosts_data.sh group_hosts      加载变量: TMSSH_GROUPS TMSSH_GROUP_HOSTS
#      source get_hosts_data.sh host_data        加载变量: TMSSH_GROUPS TMSSH_GROUP_HOSTS TMSSH_HOST_DATA
#

source ${TMSSH_HOME%/}/lib/load_hosts_file.sh
[ ! -r ${TMSSH_HOSTS_FILE?unset} ] && echo "${TMSSH_HOME%/}/lib/get_hosts_data.sh ERROR: $TMSSH_HOSTS_FILE can not readable." 1>&2 && return 1
hosts_file_data=$(grep -v '^#' $TMSSH_HOSTS_FILE |grep -v '^$' |grep -v '^[[:space:]]')

# 获取所有group 的列表
# 字符串带回车符,每行为一个group
TMSSH_GROUPS=$(printf "$hosts_file_data" |awk '{print $2}' |sed -e 's/,/\n/g' |sort |uniq)

# Use: get_group_hosts group_name
# 返回的 TMSSH_GROUP_HOSTS 值的内容是以回车符分隔每个host,host内容为hosts.txt的行内容.
get_group_hosts() {
  [[ ${TMSSH_GROUP} == "" ]] && echo "${TMSSH_HOME%/}/lib/get_hosts_data.sh ERROR: Variable TMSSH_GROUP not set." 1>&2 && return 1
  TMSSH_GROUP_HOSTS=$(printf "$hosts_file_data" |grep "\<${TMSSH_GROUP}\>")
}

get_host_data() {
  [[ ${TMSSH_HOST} == "" ]] && echo "${TMSSH_HOME%/}/lib/get_hosts_data.sh ERROR: Variable TMSSH_HOST not set." 1>&2 && return 1
  TMSSH_HOST_DATA=$(printf "${TMSSH_GROUP_HOSTS?empty.}" |grep "^\<${TMSSH_HOST}\>")
  ([[ "$TMSSH_HOST_DATA" == "" ]] || [[ $(printf "$TMSSH_HOST_DATA" |wc -l) != 0 ]]) && unset TMSSH_HOST_DATA && echo "${TMSSH_HOME%/}/lib/get_hosts_data.sh ERROR: Variable $TMSSH_HOST not found or not unique." 1>&2 && return 1
}


case $1 in
  'groups'|'')
    # 默认已取得TMSSH_GROUPS 值
    #echo "$TMSSH_GROUPS"
    return 0
    ;;
  'group_hosts')
    # 取得变量 TMSSH_GROUP_HOSTS 值
    TMSSH_GROUP_HOSTS=""
    get_group_hosts
    ;;
  'host_data')
    TMSSH_GROUP_HOSTS=""
    TMSSH_HOST_DATA=""
    get_group_hosts
    get_host_data
    ;;
  *)
    echo "${TMSSH_HOME%/}/lib/get_hosts_data.sh ERROR: type error." 1>&2 && return 1
    ;;
esac
unset TMSSH_HOSTS_FILE
unset hosts_file_data


