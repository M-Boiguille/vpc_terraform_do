#!/bin/bash

action="plan"
vars_array=()

if [ "$action" == "init"]; then
  action='init'
elif [ "$action" == "apply"]; then
  action='apply'
fi

while IFS= read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue

  key=$(echo "$line" | cut -d '=' -f1)
  value=$(echo "$line" | cut -d '=' -f2-)

  vars_array+=("-var" "$key=$value")
done < conf/.env

terraform "$action" "${vars_array[@]}"
