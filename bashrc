if [[ -f ~/.dir_colors ]] ; then
        eval $(dircolors -b ~/.dir_colors)
elif [[ -f /etc/DIR_COLORS ]] ; then
        eval $(dircolors -b /etc/DIR_COLORS)
fi

red='\e[0;31m'
RED='\e[1;31m'
blue='\e[0;34m'
BLUE='\e[1;34m'
cyan='\e[0;36m'
CYAN='\e[1;36m'
green='\e[0;34m'
GREEN='\e[1;34m'
NC='\e[0m'

#shopt -s nocaseglob # Use case-insensitive filename globbing
#shopt -s cdspell # ignore snmall typos
export HISTCONTROL="ignoredups" # ingnore doplicate line in the history

# ssh logins
if [[ $- = *i* ]] ; then
  if [[ "${DISPLAY#$HOST}" != ":0.0" &&  "${DISPLAY}" != ":0.0" ]]; then
    echo -e "${RED}Connected to $HOSTNAME${NC}"
    echo
    export PS1='\n<<< \D{%Y-%m-%d} \t >>>\n\[\033[01;33m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] \n> '
  else
    export PS1='\n<<< \D{%Y-%m-%d} \t >>>\n\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] \n> '
  fi
  export PS2='> '

  # enable bash completion in interactive shells
  if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi

  # history search with up and down arrory keys (type "ssh" and press up)
  bind '"\e[A":history-search-backward'
  bind '"\e[B":history-search-forward'

  export LESS=aCeiMR

  # complete
  complete -W "$(echo `cat ~/.ssh/known_hosts ~/.ssh/verified_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
  complete -A alias      alias unalias
  complete -A directory  mkdir rmdir
  complete -A directory   -o default cd
  complete -f -o default -X '*.+(zip|ZIP)'  zip
  complete -f -o default -X '!*.+(zip|ZIP)' unzip
  complete -f -o default -X '*.+(z|Z)'      compress
  complete -f -o default -X '!*.+(z|Z)'     uncompress
  complete -f -o default -X '*.+(gz|GZ)'    gzip tar
  complete -f -o default -X '!*.+(gz|GZ)'   gunzip
  complete -f -o default -X '*.+(bz2|BZ2)'  bzip2 tar
  complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2

  # colored Manpages
  export LESS_TERMCAP_mb=$'\E[01;31m'
  export LESS_TERMCAP_md=$'\E[01;31m'
  export LESS_TERMCAP_me=$'\E[0m'
  export LESS_TERMCAP_se=$'\E[0m'
  export LESS_TERMCAP_so=$'\E[01;44;33m'
  export LESS_TERMCAP_ue=$'\E[0m'
  export LESS_TERMCAP_us=$'\E[01;32m'

  #function _exit() # function to run upon exit of shell
  #{
  #    echo -e "${RED}KTHXBYE${NC}"
  #    sleep 1
  #}
  #trap _exit EXIT

  PATH=$PATH:~/bin
  export PATH="$PATH:$HOME/.rvm/bin"

  [[ -f ~/.alias ]] && . ~/.alias
fi
