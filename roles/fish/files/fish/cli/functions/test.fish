#!/usr/bin/fish

# base : https://github.com/fish-shell/fish-shell/issues/939#issuecomment-22058614

# upload image      : up file.png
# upload piped data : cat file.txt | up
# upload clipboard  : up
# validation        : if filetype is txt then open vim to valid or edit
# catch url         : middle clic to paste url

# If filename as argument
if isatty stdin
    cat $argv
# Else piping data
else
    cat -
end
