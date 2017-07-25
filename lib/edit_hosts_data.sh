# edit_hosts_data.sh

#hosts_file="${TMSSH_HOME%/}/etc/hosts.txt"
source ${TMSSH_HOME%/}/lib/load_hosts_file.sh
[ ! -r ${TMSSH_HOSTS_FILE?unset} ] && echo "${TMSSH_HOME%/}/lib/get_hosts_data.sh ERROR: $TMSSH_HOSTS_FILE can not readable." 1>&2 && return 1
#exec vim $HOSTS_FILE
exec ${EDITOR:-"vim"} $TMSSH_HOSTS_FILE
unset TMSSH_HOSTS_FILE
