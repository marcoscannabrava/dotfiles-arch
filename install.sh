#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"

if [[ ! -f /usr/bin/ansible ]]
then
    echo "Please install ansible"
    exit 1
fi

if [[ -z ${1+x} ]]
then
    echo "Please choose a tag to install as param:"
    ansible-playbook -i "localhost," -c local install.yml --list-tags
    exit 1
fi

echo "### DRYRUN #################################################################"

ansible-playbook -i "localhost," -c local install.yml --ask-become-pass -CD -t $1

echo "Do you want to install ? (Y/n)"
read ok
ok=${ok:-Y}

if [[ "$ok" == "Y" ]]
then
    echo "### RUN ####################################################################"
    ansible-playbook -i "localhost," -c local install.yml --ask-become-pass -t $1
fi
