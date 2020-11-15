#!/usr/bin/fish

# base : https://github.com/fish-shell/fish-shell/issues/939#issuecomment-22058614

# upload image      : up file.png
# upload piped data : cat file.txt | up
# upload clipboard  : up
# validation        : if clipboard then open vim to valid or edit
#   wq = ok, q = abort
# catch url         : middle clic to paste url


function uptest --description 'Upload datas'

  # Set commands
  set clipboard_copy wl-copy
  set clipboard_paste wl-paste

  # If filename as argument
  if isatty stdin
    echo "Upload $argv"
    # Upload img to x0.at because ix.io fails to set filetype
    curl -F "file=@$argv" https://x0.at/ | read -l url
  # Else pipe data
  else
    echo "Upload pipe"
    # Upload text to ix
    cat - | curl -F 'f:1=<-' 'http://ix.io' | read -l url
  end

  echo $url
  # Auto copy
  #if which $clipboard_copy &> /dev/null
  #  echo $url | $clipboard_copy
  #end
end
