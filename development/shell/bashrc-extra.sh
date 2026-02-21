export NIX_SHELL_PRESERVE_PROMPT=1
export PROMPT_COMMAND='set_prompt'
source ~/.nix-profile/share/git/contrib/completion/git-prompt.sh

function set_prompt {
    LAST_EXIT_STATUS="$?"

    TEXT_BOLD="\[\e[1m\]"
    FORMAT_NONE="\[\e[0m\]"

    COLOR_GREEN="\[\e[32m\]"
    COLOR_BLUE="\[\e[96m\]"
    COLOR_RED="\[\e[31m\]"
    COLOR_WHITE="\[\e[37m\]"
    COLOR_GREY="\[\e[90m\]"

    REGULAR_CAT="${COLOR_GREY}~(^._.)"
    ERROR_CAT="${COLOR_RED}~(^>.<)"
    ERROR_MOUSE="${COLOR_WHITE}__(${COLOR_RED}$(printf %-3s $LAST_EXIT_STATUS)${COLOR_WHITE}\">"

    GIT_PROMPT="$(__git_ps1 ' (%s)')"
    if [[ $LAST_EXIT_STATUS == 0 ]]; then
        PRE_PROMPT="${REGULAR_CAT}${FORMAT_NONE}"
    else
        PRE_PROMPT="${ERROR_CAT}  ${ERROR_MOUSE}${FORMAT_NONE}"
    fi
    PROMPT="${TEXT_BOLD}${COLOR_GREEN}[\u@\h:\w]${COLOR_BLUE}${GIT_PROMPT}${COLOR_GREEN} \$${FORMAT_NONE} "

    if [[ -n "$IN_NIX_SHELL" ]]; then
        export PS1="${PRE_PROMPT} ${COLOR_GREY}(nix shell) \n${PROMPT}"
    else
        export PS1="${PRE_PROMPT}\n${PROMPT}"
    fi
}

# move the auth sock to .ssh for persistence across sessions
if [[ -S "$SSH_AUTH_SOCK" && ! -L "$SSH_AUTH_SOCK" ]]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
