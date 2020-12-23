#!/bin/bash

pacman_check() {
    pac=$(checkupdates 2>/dev/null)
    pac_count=$(wc -l <<< "$pac")
    aur=$(trizen -Qua 2>/dev/null)
    aur_count=$(wc -l <<< "$aur")
    
    if [[ $pac_count -eq "0" ]] && [[ $aur_count -eq "0" ]] || [[ ! $pac_count =~ [0-9]+ ]] || [[ ! $aur_count =~ [0-9]+ ]]
    then
        exit 0
    fi

    text="$pac <span foreground='#929292'></span> $aur"
    tooltip=$(awk -v ORS='\\n' '$0=$1' <<< "$pac$aur")
}

xbps_check(){
    pkg=$(xbps-install -nu 2>/dev/null)
    pkg_count=$(wc -l <<< "$pkg")

    if [[ $pkg_count -eq "0" ]] || [[ ! $pkg =~ [0-9]+ ]]
    then
        exit 0
    fi

    text="<span foreground='#929292'></span> $pkg_count"
    tooltip=$(awk -v ORS='\\n' '$0=$1' <<< "$pkg")
}

if grep -i "arch" /etc/os-release &>/dev/null
then
    pacman_check
elif grep -i "void" /etc/os-release &>/dev/null
then
    xbps_check
fi

# Print json
printf '{"text": "%s", "tooltip": "%s"}' "$text" "$tooltip"
