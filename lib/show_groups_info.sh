# 查看项目列表和主机列表信息
# 使用 source show_groups_info.sh

if [[ "$TMSSH_GROUP" == "" ]];then 
  source ${TMSSH_HOME%/}/lib/get_hosts_data.sh groups 
  printf "${TMSSH_GROUPS}\n" |column
else 

  source ${TMSSH_HOME%/}/lib/get_hosts_data.sh group_hosts
  #printf "${TMSSH_GROUP_HOSTS}\n" |column -t
  printf "${TMSSH_GROUP_HOSTS}\n"
fi
