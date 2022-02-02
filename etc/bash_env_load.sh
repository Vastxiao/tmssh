# bash 环境加载
# 可以在 ~/.bashrc ~/.zshrc 等加载这个文件：
#    source TMSSH_HOME/etc/bash_env_load.sh
#
# 如果出现 complete: command not found 错误，就在bash_env_load.sh前加载以下两行：
# autoload bashcompinit
# bashcompinit




# tmssh home 目录，根据目录位置修改
export TMSSH_HOME=${TMSSH_HOME:-"/usr/local/tmssh"}

# 指定文本编辑器
#export EDITOR=vim

# 指定默认ssh用户名
#export TMSSH_SSH_USER=root

[ ! -f ${TMSSH_HOME%/}/bin/tmssh ] && echo "${TMSSH_HOME%/}/lib/bash_env_load.sh ERROR: ${TMSSH_HOME%}/bin/tmssh not exist." 1>&2 && return 1
# 加载bin下命令
export PATH=${TMSSH_HOME%/}/bin:$PATH


source ${TMSSH_HOME%/}/lib/bash_env_load_complete.sh

