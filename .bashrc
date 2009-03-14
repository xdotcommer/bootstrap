# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_colored_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\]\$(parse_git_branch)\$"
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

if [ -a ~/public_html/migraine ]; then
    alias m='cd ~/public_html/migraine'
else
    alias m='cd ~/Development/migraine'
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    [ -e "$HOME/.dircolors" ] && DIR_COLORS="$HOME/.dircolors"
    [ -e "$DIR_COLORS" ] || DIR_COLORS="/etc/dircolors"
    eval "`dircolors -b $DIR_COLORS`"
    alias ls='ls --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias free='free -m'
alias update="sudo aptitude update"
alias install="sudo aptitude install"
alias upgrade="sudo aptitude safe-upgrade"
alias remove="sudo aptitude remove"
alias os="cat /etc/lsb-release"
alias geml="sudo gem list"
alias gemi="sudo gem install"
alias gemu="sudo gem update"
alias disk="df -h"
alias thin_start="sudo /etc/init.d/thin start"
alias thin_stop="sudo /etc/init.d/thin stop"
alias nginx_start="sudo /etc/init.d/nginx start"
alias nginx_stop="sudo /etc/init.d/nginx stop"
alias web_restart="nginx_stop ; thin_stop ; thin_start ; nginx_start"
alias emax="sudo emacs"
alias co='bzr co'
alias ci='bzr ci -m'
alias up='bzr update'
alias ss='./script/server'
alias sc='./script/console'
alias ac='cd ./app/controllers'
alias am='cd ./app/models'
alias av='cd ./app/views'
alias db='cd ./db/migrate'
alias conf='cd ./config'
alias where='find . -name'
alias r='ruby'
alias curlpost="echo '<xml></xml>' | curl -X POST -H 'Content-type: text/xml' -d @- "
alias svn_clean='find . -name .svn -print0 | xargs -0 rm -rf'
alias cleaner='find . -name *~ -print0 | xargs -0 rm -rf'
alias migrate_test='rake environment RAILS_ENV=test db:migrate'
alias fgrep="find . \( -name \"*.rb\" -o -name \"*.rhtml\" -o -name \"*.html\" -o -name \"*.js\" -o -name \"*.css\" -o -name \"*.yml\" \) | xargs grep"
alias h='history'
alias sm='ssh -N www@migraineliving.com -L 8888:127.0.0.1:3306'

alias co='git checkout'
alias new='git checkout -b'
alias branch='git branch -va'
alias ci='git ci -m'
alias all='git ci -am'
alias pull='git pull .'
alias gmtool='git mergetool'
alias merge='git merge'
alias k='gitk --all &'
alias status='git status'
alias dif='git diff'
alias log='git log'
alias master='git checkout master'
alias delete='git branch -d'
alias fetch='git fetch origin'

alias gcom='git checkout -m'
alias grbase='git rebase'

alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff | mate'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'

alias ml='ssh www@migraineliving.com'
alias grep='GREP_COLOR="1;37;41" LANG=C grep --color=auto'

PATH=$PATH:/usr/local/mysql/bin:/opt/local/bin
export PATH


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ ! -r ~/.cheats ] || [[ ! "" == `find ~ '.cheats' -ctime 1 -maxdepth 0` ]]; then
  echo "Rebuilding Cheat cache... " 
  cheat sheets | egrep '^ ' | awk {'print $1'} > ~/.cheats
fi
complete -W "$(cat ~/.cheats)" cheat
complete -C ~/.rake-completion.rb -o default rake