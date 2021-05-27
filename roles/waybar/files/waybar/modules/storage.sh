#!/usr/bin/env bash

# Functions
escape() { while read l; do printf '%s\\n' "$l"; done }

# Vars
warning=85
critical=95
target="$1"

# Detect slash FSType
fstype=$(findmnt -nT "$target" -o FSTYPE)

# Set query cmd
if [[ -z "$fstype" ]]
then
  exit
elif [[ "$fstype" == zfs ]]
then
  zfsroot=$(findmnt -nT "$target" -o SOURCE | sed 's:/.*::')
  pcent=$(zpool list -o cap -H "$zfsroot" | tr -d '%')
  tooltip=$(escape <<< "$(zfs list -o name,used,compressratio,logicalused,avail)")
else
  pcent=$(df "$target" --output="pcent" 2>/dev/null | sed 1d | tr -d ' ' | tr -d '%')
  tooltip="$pcent"
fi

json_fmt='{"text": "%s" , "class": "%s", "tooltip": "%s"}\n'

if [[ -z $pcent ]]
then
    echo -e "Usage: ./storage.sh [mountpoint]\nexemple : ./storage.sh /"
else
    if [[ $pcent -lt $warning ]]
    then
        printf "$json_fmt" "$pcent" "normal" "$tooltip"
    elif [[ $pcent -ge $warning ]] && [[ $pcent -lt $critical ]]
    then
        printf "$json_fmt" "$pcent" "warning" "$tooltip"
    elif [[ $pcent -ge $critical ]]
    then
        printf "$json_fmt" "$pcent" "critical" "$tooltip"
    fi
fi
