# locales
export LC_ALL=""
export LC_COLLATE=C
export LANG=de_DE.UTF-8

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# Options
setopt \
NO_all_export \
   always_last_prompt \
NO_always_to_end \
   append_history \
   auto_cd \
   auto_list \
   auto_menu \
NO_auto_name_dirs \
   auto_param_keys \
   auto_param_slash \
   auto_pushd \
   auto_remove_slash \
NO_auto_resume \
   bad_pattern \
   bang_hist \
NO_beep \
   brace_ccl \
   correct_all \
NO_bsd_echo \
   cdable_vars \
NO_chase_links \
NO_clobber \
   complete_aliases \
   complete_in_word \
   correct \
   correct_all \
   csh_junkie_history \
NO_csh_junkie_loops \
NO_csh_junkie_quotes \
NO_csh_null_glob \
NO_dvorak \
   equals \
   extended_glob \
   extended_history \
   function_argzero \
   glob \
NO_glob_assign \
   glob_complete \
   glob_dots \
   glob_subst \
   hash_cmds \
   hash_dirs \
   hash_list_all \
   hist_allow_clobber \
   hist_beep \
   hist_ignore_dups \
   hist_ignore_space \
NO_hist_no_store \
NO_hist_save_no_dups \
   hist_verify \
NO_hup \
NO_ignore_braces \
NO_ignore_eof \
   interactive_comments \
NO_list_ambiguous \
NO_list_beep \
   list_types \
   long_list_jobs \
   magic_equal_subst \
NO_mail_warning \
NO_mark_dirs \
   menu_complete \
   multios \
NO_nomatch \
   notify \
NO_null_glob \
   numeric_glob_sort \
NO_overstrike \
   path_dirs \
   posix_builtins \
NO_print_exit_value \
NO_prompt_cr \
   prompt_subst \
   pushd_ignore_dups \
NO_pushd_minus \
NO_pushd_silent \
   pushd_to_home \
   rc_expand_param \
NO_rc_quotes \
NO_rm_star_silent \
NO_sh_file_expansion \
   sh_option_letters \
   short_loops \
NO_sh_word_split \
NO_single_line_zle \
NO_sun_keyboard_hack \
   unset \
NO_verbose \
NO_xtrace \
   zle

# Completions
autoload -U compinit ; compinit -i

# Follow GNU LS_COLORS
zmodload -i zsh/complist
autoload -U colors
colors
zstyle :compinstall filename '~/.zshrc'
# Compliations for make
compile=(install clean remove uninstall deinstall)
compctl -k compile make
# cd : only in directories
compctl -g '*(-/)' + -g '.*(/)' cd chdir dirs pushd rmdir dircmp cl
# add original string alwasys to the completion list
zstyle ':completion:*:correct:*' original true
zstyle ':completion:*:correct:*' insert-unambiguous true # RTFM :P
# function list that are use for completion
zstyle ':completion:*' completer _complete _correct _approximate
# Globbing
zstyle ':completion:*' glob true

# Verbose
#zstyle ':completion:*' verbose yes
# Format for correction, warnings...
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}%d%{\e[0m%}'
zstyle ':completion:*:messages' format $'%{\e[0;31m%}%d%{\e[0m%}'
zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches for: %d%{\e[0m%}'
zstyle ':completion:*' group-name ''
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

zstyle ':completion:*' list-colors ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# completion menu
zstyle ':completion:*' menu yes=long-list
zstyle ':completion:*' menu select=2

# completions for programs
# SSH - user, Host
zstyle ':completion:*:ssh:*' group-order 'users' 'hosts'
# rm - first backupfiles, then bytecompiled files, third core-Files, all other files 
zstyle ':completion:*:*:rm:*' file-patterns '(*~|\\#*\\#):backup-files' '*.zwc:zsh\ bytecompiled\ files' 'core(|.*):core\ files' '*:all-files'
# kill 
zstyle ':completion:*:kill:*' command 'ps -eo pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:kill:*' insert-ids single
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# bindkey
bindkey -e
bindkey "\e[3~" delete-char
# Home/End keys.
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
# completion menu vi bindings
bindkey -M menuselect 'h' vi-backward-char                # links
bindkey -M menuselect 'j' vi-down-line-or-history         # unten
bindkey -M menuselect 'k' vi-up-line-or-history           # oben
bindkey -M menuselect 'l' vi-forward-char                 # rechts
# bindkey up and down for search history (type "ssh" and press up)
bindkey "\e[A" history-search-backward
bindkey "\e[B" history-search-forward

# envvars
umask 077
export COLORTERM=yes
export EDITOR=/usr/bin/vim
export PAGER=less
export LESS=aCeiMR
export BROWSER=elinks
export PATH=$PATH:/opt/bin:$HOME/bin:$HOME/scripts/bash

# colors for ls
if [[ -f ~/.dir_colors ]] ; then
   eval $(dircolors -b ~/.dir_colors)
elif [[ -f /etc/DIR_COLORS ]] ; then
   eval $(dircolors -b /etc/DIR_COLORS)
fi

# Prompt
if [[ `whoami` == "root" ]]; then are_im_root="$fg[red]"; else; are_im_root="$fg[blue]"; fi
if [[ "${${DISPLAY}#*:}" != "0.0" ]]; then hostcolor="yellow"; else; hostcolor="green"; fi

export PS1="$fg[black]______________________________________________
$fg[red]<<<$fg[white] %D{%Y-%m-%d} %D{%k:%M:%S} $fg[red]>>>
$fg_bold[$hostcolor]%n@%m  -  $fg_bold[blue]%~ $are_im_root%# $terminfo[sgr0]
$fs[white]> "
export PS2="> "
SPROMPT='zsh: correct '%R' to '%r'? ([Y]es/[N]o/[E]dit/[A]bort) '

# source
[ -f ~/.alias ] && source ~/.alias
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# zsh specific aliases
alias mkdir='nocorrect mkdir'
