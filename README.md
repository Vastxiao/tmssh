# tmssh

tmux的增强工具，用于批量ssh远程主机(类似windows下xshell这类软件批量打开远程终端)，适用于操作多服务器的运维们。

特性：

* 配合tmux使用，在tmux中批量远程服务器(类xshell软件的多标签窗口)。
* 支持使用命令的分组和IP地址自动补全。
* 纯bash工具，安装和配置简单。

## install

tmssh工具包安装：

```bash
git clone https://github.com/Vastxiao/tmssh /usr/local/tmssh

```

## config

tmssh环境配置很简单，仅需要在 bash 环境中加载 bash_env_load.sh 环境配置:

```bash
# 可以在/etc/profile ~/.profile ~/.bashrc 等加载这个文件:
export TMSSH_HOME=/usr/local/tmssh
source ${TMSSH_HOME%/}/etc/bash_env_load.sh

# 你也可以直接将 bash_env_load.sh 文件放入 /etc/profile.d/ 目录下。
# 然后也可以根据需要修改或配置 bash_env_load.sh 中的参数到shell环境中。

# 另外[可选项]可以指定默认的ssh用户名
export TMSSH_SSH_USER=root
```

接着就是编辑hosts文件信息了，相关的hosts文件模板是hosts.txt.template：

```bash
cp ${TMSSH_HOME%/}/etc/hosts.txt.template ${TMSSH_HOME%/}/etc/hosts.txt
vim ${TMSSH_HOME%/}/etc/hosts.txt
```

配置完成后就可以使用tmssh了。

## usage

tmssh 的命令帮助：

```bash
help usage:

  tmssh -h         Show this message.
  tmssh -v         Report the tmssh version.

  tmssh -l         Show all groups.
  tmssh -l group_name
                   Show hosts in group.
  tmssh -e         Edit hosts.

  tmssh [-Auis] group_name
                   Connect to a group
  tmssh [-Anpuiw] group_name host_id
                   Connect to a host
  options:
     -A            Enables forwarding of the authentication agent connection.
     -n <1-9>      Use specified ip to connect to the remote host if possible.
     -p port       Port to connect to on the remote host.
     -u username   Login whith this username.
     -i identity_file
                   Selects a file from which the identity (private key) for public key authentication is read.
     -s tmux_session_name
                   Use tmux_session_name on tmux instead of group_name.
     -w tmux_window_name
                   Use tmux_window_name on tmux instead of ip.
```


