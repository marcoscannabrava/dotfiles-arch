#!/bin/bash
context=$(kubectx -c)
namespace=$(kubens -c)

if [[ $namespace == "default" ]]
then
  echo "$context"
else
  echo "$context - $namespace"
fi
