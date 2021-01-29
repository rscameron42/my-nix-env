## RC zshrc file

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

export RC_ZSHRC_VERSION="1.0.0"
export CLICOLOR=1
os="`uname | tr '[:upper:]' '[:lower:]'`"
neofetch

echo "$os"
###############################################################################
### Aliases ###################################################################
###############################################################################
# Pull in my OS-specific, shell agnostic aliases
if [ -f ~/.aliases."$os" ]; then
    . ~/.aliases."$os"
fi
# Pull in my aliases from a shell agnostic aliases file
if [ -f ~/.aliases ]; then . ~/.aliases; fi
# Define ZSH specific aliases here
# alias alias='command and arguments'

###############################################################################
### Prompt ####################################################################
###############################################################################
# Prompt variables

# Prompt functions
_rc_prompt_connect_text() {
    if [ -n "${SSH_CLIENT}" ]
    then 
        ssh_array=( ${=SSH_CLIENT} )
        ssh_source_ip="$ssh_array[1]"
        echo "%F{9}-[%BSSH%b%F{8}-$ssh_source_ip%F{9}]"
    fi
}

#manually define the prompt
RPROMPT='%D{%a %b %f}, %*'
PROMPT='%B%F{9}┌─[%f%b%n%F{11}%B@%F{14}%m%b%F{9}]-[%B%F{3}%~%b%F{9}]'$(_rc_prompt_connect_text)'
%B%F{1}└──▶%(?.%F{2} √.%F{9} Error:%?)%f%b %# '