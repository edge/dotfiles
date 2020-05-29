#
# ~/.bashrc
#

### Session
[[ $- != *i* ]] && return

### Editor
if [[ ! -z $(command -v nvim) ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

### Term
alias x256='export TERM=xterm-256color'
alias tmux='tmux -2'

### System
alias sudo='sudo '

### Filesystem
alias ls='ls -G'
alias l='ls -CaFl'
alias lh='l -h'
alias d.='du -hd0'
alias ..='cd ..'

### Directories
alias pd='cd ~/Documents/projects'

### Edit (neovim)
alias nv=$EDITOR

### Git
alias git-update-submodules='git submodule foreach git pull origin master'

### Prompt

# no print
np1="\[\033[38;5;"
np2="m\]"

# reset color
rs="\[$(tput sgr0)\]"

# new color
co() {
  echo "$rs$np1$1$np2"
}

# git aware
ga_branch() {
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    git_branch="($branch)"
  else
    git_branch=""
  fi
}

ga_dirty() {
  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    git_dirty='*'
  else
    git_dirty=''
  fi
}

gitaware() {
  ga_branch
  ga_dirty
  git_prompt=$git_branch$git_dirty
  if [[ "$git_prompt" != "" ]]; then
    git_prompt="$git_prompt "
  fi
}

ttycolor=`[[ -n $SSH_CLIENT ]] && echo $(co 43) || echo $(co 243)`

PROMPT_COMMAND="gitaware; $PROMPT_COMMAND"

PS1="$(co 36)$ttycolor\h$(co 249) \w$(co 131) \$git_prompt$(co 67):: $(co 209)"
trap '[[ -t 1 ]] && tput sgr0' DEBUG

unset rs ttycolor
unset -f co

export PATH=~/.local/bin:$PATH

