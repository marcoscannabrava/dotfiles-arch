#!/bin/bash

pacman_check() {
    pac=$(checkupdates 2>/dev/null)
    if test -n "$pac"; then pac_count=$(wc -l <<< "$pac"); fi
    aur=$(trizen -Qua 2>/dev/null)
    if test -n "$aur"; then aur_count=$(wc -l <<< "$aur"); fi
    
    if test -z "$pac_count" && test -z "$aur_count"; then exit; fi

    text="$pac_count <span foreground='#929292'></span> $aur_count"
    tooltip_pac="pacman:\n\t$(awk -v ORS=' ' '$0=$1' <<< "$pac")"
    tooltip_aur="aur:\n\t$(awk -v ORS=' ' '$0=$1' <<< "$aur")"
    tooltip+=$(if test -n "$pac"; then echo "$tooltip_pac"; fi)
    tooltip+=$(if test -n "$pac" && test -n "$aur"; then echo "\n"; fi)
    tooltip+=$(if test -n "$aur"; then echo "$tooltip_aur"; fi)
}

xbps_check(){
    xbps=$(xbps-install -SMnu 2>/dev/null)
    if test -n "$xbps"; then xbps_count=$(wc -l <<< "$xbps"); fi
    flatpak=$(flatpak remote-ls --updates --columns=name)
    if test -n "$flatpak"; then flatpak_count=$(wc -l <<< "$flatpak"); fi

    if test -z "$xbps_count" && test -z "$flatpak_count"; then exit; fi

    text="$xbps_count <span foreground='#929292'></span> $flatpak_count"
    tooltip_xbps="xbps:\n\t$(awk -v ORS=' ' '$0=$1' <<< "$xbps")"
    tooltip_flat="flatpak:\n\t$(awk -v ORS=' ' '$0=$1' <<< "$flatpak")"
    tooltip+=$(if test -n "$xbps"; then echo "$tooltip_xbps"; fi)
    tooltip+=$(if test -n "$xbps" && test -n "$flatpak"; then echo "\n"; fi)
    tooltip+=$(if test -n "$flatpak"; then echo "$tooltip_flat"; fi)
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
