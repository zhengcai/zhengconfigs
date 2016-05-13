# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# aliases
alias ll='ls -alh'
alias llrt='ls -lrt'
alias la='ls -A'
alias l='ls -CF'
alias less='less -N'
alias em='emacs -nw'
alias qfind='find . -name'
alias rm='rm -rf'
alias untracked='git ls-files . --exclude-standard --others'

alias lint='clear ; find ./ -name "*.h" -o -name "*.cc" | xargs ~/workspace/main/open_tools/codereview/cpplint.py'
alias difflint='clear ; cd ~/workspace/main ; git diff origin/master --name-only | xargs ~/workspace/main/open_tools/codereview/cpplint.py'
alias review='~/workspace/main/open_tools/codereview/upload.py --rev=origin/master --no_oauth2_webbrowser -e zheng@cohesity.com'
alias bid='cd ~/workspace/main ; mkid -p build -p builds -s'
alias btags='cd ~/workspace/main ; find . -type f -iname "*.proto" | grep -v "/builds/" | etags -'

alias pass='sshpass -p fr8shst8rt ssh -o StrictHostKeyChecking=no'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
fi
