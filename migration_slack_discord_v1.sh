#!/bin/bash

readonly WEBHOOK_URL="https://discord.com/api/webhooks/<copy>"
readonly FILE_NAME="<sample_read_file>"
readonly USER_NAME="<discord_display_name>"

# WHILE_I=1 # Debug

# r option is important.
# To process the last line of the file.
while read -r line || [ -n "${line}" ];
do
  # echo "__WHILE_I $WHILE_I" # Debug

  echo "$line" | jq -c '.[]' | while read -r json_array;
  do
    TEXT=$(echo "$json_array" | jq -r '.text')

    # せっかくなので日付情報もメッセージに付加する。
    TS=$(echo "$json_array" | jq -r '.ts' | sed 's/\..*//g')
    DATE=$(date -r $TS +"%Y-%m-%d")
    
    CONTENT=$(echo "($DATE) $TEXT")
    
    curl \
    -X POST \
    -H "Content-Type: application/json" \
    -d "{\"username\": \"$USER_NAME\", \"content\": \"$CONTENT\"}" \
    "$WEBHOOK_URL"
  done

  # WHILE_I=$((WHILE_I + 1)) # Debug
  # echo; # Debug
done < $FILE_NAME

# echo "__END $WHILE_I" # Debug
