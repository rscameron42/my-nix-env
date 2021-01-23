## RC zshrc file

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

export RC_ZSHRC_VERSION="1.0.0"

neofetch

###############################################################################
### Aliases ###################################################################
###############################################################################
# Pull in my aliases from a shell agnostic aliases file
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi
# Define ZSH specific aliases here
# alias alias='command and arguments'

###############################################################################
### Prompt ####################################################################
###############################################################################
#local RC_ARROW='─>'
local RC_ARROW='─▶'  # best on Ubuntu"
#local RC_ARROW='─➤'

local RC_LAST_EXIT_CODE=0

### Functions used to build prompt

_rc_get_host_name() { echo "[%{$FG[157]%}%m%{$reset_color%}]"; }

_rc_get_user_name() {
    local name_prefix="%{$reset_color%}"
    if [[ $USER == 'root' || $UID == 0 ]]; then
        name_prefix="%{$FG[203]%}"
    fi
    echo "${name_prefix}%n%{$reset_color%}"
}

_rc_git_prompt_info () {
    if [[ -z ${RC_REV_GIT_DIR} ]]; then return 1; fi
    local ref
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${RC_GIT_STATUS_PROMPT}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Generate the arrow tip or git status
# Logic to determine git status and change pointer temporarily disabled
# TODO: get git working
_rc_type_tip_pointer() {
    #if [[ -n ${RC_REV_GIT_DIR} ]]; then
    #    if [[ ${RC_IS_GIT_DIRTY} == false ]]; then
    #        echo '(๑˃̵ᴗ˂̵)و'
    #    else
    #        echo '(ﾉ˚Д˚)ﾉ'
    #    fi
    #else
        echo "${RC_ARROW}"
    #fi
}

_rc_current_dir() {
    echo "%{$terminfo[bold]$FG[228]%}%~%{$reset_color%}"
}

_rc_get_date_time() {
    # echo "%{$reset_color%}%D %*"
    command date "+%a %b %d, %H:%M:%S"
}

# Calculate the empty columns to align text at the right side of the shell
_rc_get_space_size() {
    # ref: http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
    local str="$1"
    local zero_pattern='%([BSUbfksu]|([FB]|){*})'
    local len=${#${(S%%)str//$~zero_pattern/}}
    local size=$(( $COLUMNS - $len + 1 ))
    echo "$size"
}

# Get the exit code if !=0 and build the right justified string
_rc_previous_align_right() {
    # CSI ref: https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_sequences
    local new_line_space='\n '
    local str="$1"
    local align_site=`_rc_get_space_size "$str"`
    local previous_line="\e[1A"
    local cursor_cols="\e[${align_site}G"
    echo "${previous_line}${cursor_cols}${str}${new_line_space}"
}

_rc_align_right() {
    local str="$1"
    local align_site=`_rc_get_space_size "$str"`
    local cursor_cols="\e[${align_site}G"
    echo "${cursor_cols}${str}"
}

# pin the last commad exit code at previous line end
_rc_get_pin_exit_code() {
    # RC_LAST_EXIT_CODE changed in `_rc_prompt`, 
    # because $? must be read in the first function of PROMPT
    local exit_code=${RC_LAST_EXIT_CODE}
    if [[ $exit_code != 0 ]]; then
        local exit_code_warn=" %{$FG[246]%}exit:%{$fg_bold[red]%}${exit_code}%{$reset_color%}"
        _rc_previous_align_right "$exit_code_warn"
    fi
}

# Define variables used in the prompt
# local RC_PROMPT_UP_CORNER='╭─'
local RC_PROMPT_UP_CORNER='┌─'
# local RC_PROMPT_DOWN_CORNER='╰─'
local RC_PROMPT_DOWN_CORNER='└─'
local -A RC_PROMPT_FORMATS=(
    host '$(_rc_get_host_name)%{$FG[102]%} as'
    user ' $(_rc_get_user_name)%{$FG[102]%} in'
    path ' $(_rc_current_dir)'
    # dev_env '$(_rc_dev_env_segment)'
    # git_info ' $(_rc_git_prompt_info)'
    current_time '$(_rc_align_right " `_rc_get_date_time`")'
)

local RC_PROMPT_PRIORITY=(
    # path
    # git_info
    user
    host
    # dev_env
    # current_time
)

### Main prompt function
_rc_prompt() {
    RC_LAST_EXIT_CODE=$?
    local -i total_length=${#RC_PROMPT_UP_CORNER}
    local -A prompts=(
        host ''
        user ''
        path ''
        # dev_env ''
        # git_info ''
        current_time ''
    )
    # datetime length is fixed number of `${RC_PROMPT_FORMATS[current_time]}`
    local -i len_datetime=20
    
    # always display current path
    prompts[path]=$(print -P "${RC_PROMPT_FORMATS[path]}")
    #total_length+=$(_RC_unstyle_len "${prompts[path]}")

    for key in ${RC_PROMPT_PRIORITY[@]}; do
        local item=$(print -P "${RC_PROMPT_FORMATS[${key}]}")
        #local -i item_length=$(_rc_unstyle_len "${item}")

        if (( total_length + item_length > COLUMNS )); then
            break
        fi

        total_length+=${item_length}
        prompts[${key}]="${item}"
    done

    if (( total_length + len_datetime <= COLUMNS )); then
        prompts[current_time]=$(print -P "${RC_PROMPT_FORMATS[current_time]}")
    fi

    echo "$(_rc_get_pin_exit_code)"
    echo "${RC_PROMPT_UP_CORNER}${prompts[host]}${prompts[user]}${prompts[path]}${prompts[current_time]}"
    echo "${RC_PROMPT_DOWN_CORNER}$(_rc_type_tip_pointer) "
}

PROMPT='$(_rc_prompt)'