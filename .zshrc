## RC zshrc file

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

export RC_ZSHRC_VERSION="1.0.0"
export CLICOLOR=1
os="`uname | tr '[:upper:]' '[:lower:]'`"
neofetch

###############################################################################
### Aliases ###################################################################
###############################################################################
# Pull in my OS-specific, shell agnostic aliases
if [ -f ~/.aliases."$os" ]; then . ~/.aliases."$os"; fi
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
        echo "%F{1}-[%B%F{9}SSH%b%F{7}-$ssh_source_ip%F{1}]"
    fi
}

#manually define the prompt
RPROMPT='%D{%a %b %f}, %*'
PROMPT='%F{1}┌─[%f%n%F{11}%B@%F{14}%m%b%F{1}]-[%B%F{3}%~%b%F{1}]'$(_rc_prompt_connect_text)'
%F{1}└──▶%(?.%B%F{2} √.%B%F{9} Error:%?)%f%b %# '