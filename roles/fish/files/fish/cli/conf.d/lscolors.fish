if not set -q LS_COLORS
    if type -f dircolors >/dev/null
        eval (dircolors -c ~/.dircolors | sed 's/>&\/dev\/null$//')
    end
end
