test -r ~/.alias && . ~/.alias
PS1='GRASS 6.4.2 (CA):\w > '
PROMPT_COMMAND="'/usr/lib/grass64/etc/prompt.sh'"
export PATH="/usr/lib/grass64/bin:/usr/lib/grass64/scripts:/home/quinn/grass/bin:/home/quinn/grass/scripts:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
export HOME="/home/quinn"
export GRASS_SHELL_PID=$$
trap "echo \"GUI issued an exit\"; exit" SIGQUIT
