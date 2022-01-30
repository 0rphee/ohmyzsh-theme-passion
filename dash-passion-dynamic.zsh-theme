
# gdate for macOS
# REF: https://apple.stackexchange.com/questions/135742/time-in-milliseconds-since-epoch-in-the-terminal
if [[ "$OSTYPE" == "darwin"* ]]; then
    {
        gdate
    } || {
        echo "\n$fg_bold[yellow]passsion.zsh-theme depends on cmd [gdate] to get current time in milliseconds$reset_color"
        echo "$fg_bold[yellow][gdate] is not installed by default in macOS$reset_color"
        echo "$fg_bold[yellow]to get [gdate] by running:$reset_color"
        echo "$fg_bold[green]brew install coreutils;$reset_color";
        echo "$fg_bold[yellow]\nREF: https://github.com/ChesterYue/ohmyzsh-theme-passion#macos\n$reset_color"
    }
fi


# time
function real_time() {
    local color="%{$fg_no_bold[cyan]%}";                    # color in PROMPT need format in %{XXX%} which is not same with echo
    local time="[$(date +%H:%M:%S)]";
    local color_reset="%{$reset_color%}";
    echo "${color}${time}${color_reset}";
}

# login_info
function login_info() {
    local color="%{$fg_no_bold[cyan]%}";                    # color in PROMPT need format in %{XXX%} which is not same with echo
    local ip
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # Linux
        ip="$(ifconfig | grep ^eth1 -A 1 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | head -1)";
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        ip="$(ifconfig | grep ^en1 -A 4 | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | head -1)";
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
    else
        # Unknown.
    fi
    local color_reset="%{$reset_color%}";
    echo "${color}[%n@${ip}]${color_reset}";
}


# directory
function directory() {
    # local color="%{$fg_no_bold[cyan]%}";
    local color="$FG[111]";
    # REF: https://stackoverflow.com/questions/25944006/bash-current-working-directory-with-replacing-path-to-home-folder
    local directory="${PWD/#$HOME/~}";
    local color_reset="%{$reset_color%}";
    echo "${color}[${directory}]${color_reset}";
}


# git
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_no_bold[blue]%}❮%{$fg_no_bold[red]%}";
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}";
ZSH_THEME_GIT_PROMPT_END_SUFFIX="%{$fg_no_bold[blue]%}❯%{$reset_color%}";

ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_AHEAD_PREFIX="$FG[005]⇡"
ZSH_THEME_GIT_PROMPT_AHEAD_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_BEHIND_PREFIX="$FG[005]⇣"
ZSH_THEME_GIT_PROMPT_BEHIND_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_STAGED="%{$fg_bold[green]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg_bold[yellow]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}⬢%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[red]%}!%{$reset_color%}"


# Copy from the `bureau` theme
bureau_git_branch () {
  local ref
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

bureau_git_status() {
  local result gitstatus

  # check status of files
  gitstatus=$(command git status --porcelain -b 2> /dev/null)
  if [[ -n "$gitstatus" ]]; then
    if $(echo "$gitstatus" | command grep -q '^[AMRD]. '); then
      result+="$ZSH_THEME_GIT_PROMPT_STAGED"
    fi
    if $(echo "$gitstatus" | command grep -q '^.[MTD] '); then
      result+="$ZSH_THEME_GIT_PROMPT_UNSTAGED"
    fi
    if $(echo "$gitstatus" | command grep -q -E '^\?\? '); then
      result+="$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    fi
    if $(echo "$gitstatus" | command grep -q '^UU '); then
      result+="$ZSH_THEME_GIT_PROMPT_UNMERGED"
    fi
  else
    result+="$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  # check status of local repository
  if $(echo "$gitstatus" | command grep -q '^## .*ahead'); then
    result+="${ZSH_THEME_GIT_PROMPT_AHEAD_PREFIX}$(git_commits_ahead)${ZSH_THEME_GIT_PROMPT_AHEAD_SUFFIX}"
  fi

  if $(echo "$gitstatus" | command grep -q '^## .*behind'); then
    result+="${ZSH_THEME_GIT_PROMPT_BEHIND_PREFIX}$(git_commits_behind)${ZSH_THEME_GIT_PROMPT_BEHIND_SUFFIX}"
  fi

  if $(echo "$gitstatus" | command grep -q '^## .*diverged'); then
    result+="$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  if $(command git rev-parse --verify refs/stash &> /dev/null); then
    result+="$ZSH_THEME_GIT_PROMPT_STASHED"
  fi

  if [[ $(git ls-files -u) != "" ]]; then
    result+="$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  echo $result
}

function update_git_status() {
    GIT_STATUS=$(bureau_git_branch);
    local git_status="$(bureau_git_status)"
    if [[ $git_status != "" ]]; then
        GIT_STATUS+=" $(bureau_git_status)";
    fi 
    GIT_STATUS+=${ZSH_THEME_GIT_PROMPT_END_SUFFIX};
}

function git_status() {
    # update git status for every second.
    update_git_status
    echo "${GIT_STATUS}"
}


# command
function update_command_status() {
    local arrow="";
    local color_reset="%{$reset_color%}";
    local reset_font="%{$fg_no_bold[white]%}";
    COMMAND_RESULT=$1;
    export COMMAND_RESULT=$COMMAND_RESULT
    if $COMMAND_RESULT;
    then
        arrow="%{$fg_bold[red]%}❱%{$fg_bold[yellow]%}❱%{$fg_bold[green]%}❱";
    else
        arrow="%{$fg_bold[red]%}❱❱❱";
    fi
    COMMAND_STATUS="${arrow}${reset_font}${color_reset}";
}
update_command_status true;

function command_status() {
    echo "${COMMAND_STATUS}"
}

# settings
typeset +H return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
typeset +H my_gray="$FG[237]"
typeset +H my_orange="$FG[214]"

# separator dashes size
function afmagic_dashes {
    local ratio=1
    echo $((COLUMNS * ratio))
}

# output command execute after
output_command_execute_after() {
    if [ "$COMMAND_TIME_BEIGIN" = "-20200325" ] || [ "$COMMAND_TIME_BEIGIN" = "" ];
    then
        return 1;
    fi

    # cmd
    local cmd="${$(fc -l | tail -1)#*  }";
    local color_cmd="";
    if $1;
    then
        color_cmd="$fg_no_bold[green]";
    else
        color_cmd="$fg_bold[red]";
    fi
    local color_reset="$reset_color";
    cmd="${color_cmd}${cmd}${color_reset}"

    # time
    local time="[$(date +%H:%M:%S)]"
    local color_time="$fg_no_bold[cyan]";
    time="${color_time}${time}${color_reset}";

    # cost
    local time_end="$(current_time_millis)";
    local cost=$(bc -l <<<"${time_end}-${COMMAND_TIME_BEIGIN}");
    COMMAND_TIME_BEIGIN="-20200325"
    local length_cost=${#cost};
    if [ "$length_cost" = "4" ];
    then
        cost="0${cost}"
    fi
    cost="[cost ${cost}s]"
    local color_cost="$fg_no_bold[yellow]";
    cost="${color_cost}${cost}${color_reset}";

    echo -e "${time} ${cost} ${cmd}";
    echo -e "";
    local echo_dark_gray="\033[2;49;39m"

    echo -e "$echo_dark_gray${(l.$(afmagic_dashes)..-.)}${color_reset}"
}


# command execute before
# REF: http://zsh.sourceforge.net/Doc/Release/Functions.html
preexec() {
    COMMAND_TIME_BEIGIN="$(current_time_millis)";
}

current_time_millis() {
    local time_millis;
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # Linux
        time_millis="$(date +%s.%3N)";
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        time_millis="$(gdate +%s.%3N)";
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
    else
        # Unknown.
    fi
    echo $time_millis;
}


# command execute after
# REF: http://zsh.sourceforge.net/Doc/Release/Functions.html
dash_passion_precmd() {
    # last_cmd
    local last_cmd_return_code=$?;
    local last_cmd_result=true;
    if [ "$last_cmd_return_code" = "0" ];
    then
        last_cmd_result=true;
    else
        last_cmd_result=false;
    fi

    # update_command_status
    update_command_status $last_cmd_result;

    # output command execute after
    output_command_execute_after $last_cmd_result;

}

# timer
#REF: https://stackoverflow.com/questions/26526175/zsh-menu-completion-causes-problems-after-zle-reset-prompt
TMOUT=1;
TRAPALRM() {
    # $(git_prompt_info) cost too much time which will raise stutters when inputting. so we need to disable it in this occurence.
    # if [ "$WIDGET" != "expand-or-complete" ] && [ "$WIDGET" != "self-insert" ] && [ "$WIDGET" != "backward-delete-char" ]; then
    # black list will not enum it completely. even some pipe broken will appear.
    # so we just put a white list here.
    if [ "$WIDGET" = "" ] || [ "$WIDGET" = "accept-line" ] ; then
        zle reset-prompt;
    fi
}

setopt prompt_subst
PROMPT='$(real_time) $(directory) $(git_status) $(command_status) ';
RPROMPT='%{$FG[242]%}%n@%m $(battery_pct_prompt)${color_reset}';

autoload -Uz add-zsh-hook
add-zsh-hook precmd dash_passion_precmd