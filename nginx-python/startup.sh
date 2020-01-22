#!/bin/bash

# Replace variables $ENV{<environment varname>}
function ReplaceEnvironmentVariable() {
    grep -rl "\$ENV{\"$1\"}" $3|xargs -r \
        sed -i "s|\\\$ENV{\"$1\"}|$2|g"
}

if [ -n "$DEBUG" ]; then
    echo "Environment variables:"
    env
    echo "..."
fi

# Replace all variables
for _curVar in `env | awk -F = '{print $1}'`;do
    ReplaceEnvironmentVariable ${_curVar} ${!_curVar} /etc/nginx/conf.d/*
done

while ! nc -z -v $PYTHON_HOST 8080; do   
  sleep 10
  echo "."
done

echo "python is online"

nginx -g 'daemon off;'