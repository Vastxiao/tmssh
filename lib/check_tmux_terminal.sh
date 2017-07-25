# 判断当前终端在不在tmux中
# 使用: source 
# 返回状态码:
#     在tmux中 0
#     不在tmux中 1
env |grep '^TMUX=' &>/dev/null
