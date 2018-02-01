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
alias difflint='clear ; git diff origin/master --name-only | xargs ~/workspace/main/open_tools/codereview/cpplint.py'
alias review='~/workspace/main/open_tools/codereview/upload.py --no_oauth2_webbrowser'
alias bid='rm ID ; mkid -p build -p builds -s ; mv ID build/ ; ln -s build/ID ./ID'
alias btags='find . -type f -iname "*.proto" | grep -v "/builds/" | etags -'

alias pass='sshpass -p fr8shst8rt ssh -o StrictHostKeyChecking=no'
alias qapass='sshpass -p Cohe\$1ty ssh -o StrictHostKeyChecking=no'
alias mkexp='make -j30 EXPERIMENTAL_SUBDIR=zheng'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
fi

function grunt-prod() {
  rm -rf $TOP/four/build/iris/static
  $TC_BASE/$TC_VERSION/iris/grunttools/node_modules/grunt-cli/bin/grunt prod \
    --gruntfile $TOP/toolchain/x86_64-linux/$TC_VERSION/iris/grunttools/Gruntfile-2.0.js \
    --app $TOP/four/iris/go/server/ \
    --toolchain $TC_BASE/$TC_VERSION/iris \
    --build_dir $TOP/four/build/iris/static
}

function grunt-dev() {
  $TC_BASE/$TC_VERSION/iris/grunttools/node_modules/grunt-cli/bin/grunt dev \
    --gruntfile $TOP/toolchain/x86_64-linux/$TC_VERSION/iris/grunttools/Gruntfile-2.0.js \
    --app $TOP/four/iris/go/server/ \
    --toolchain $TC_BASE/$TC_VERSION/iris \
    --build_dir $TOP/four/build/iris/static
}