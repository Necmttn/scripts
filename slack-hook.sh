#!/bin/bash

#
#
PROCESS=$
LOGFILE=$2
SLACK_HOOK=$
NAME_OF_THE_PROJECT=$4


slack_hook() {
  $PROCESS > $LOGFILE 2>&1
  [[ $? -eq 0 ]] \
  && slack_message_success \
  || slack_message_fail

}


slack_message_success() {
  curl -H "Content-Type: application/json" -X POST -d '{"text":"on success"}' $SLACK_HOOK
}

slack_message_fail() {
  curl -H "Content-Type: application/json" \
  -X POST -d '{"attachments": [{"title":"'"$NAME_OF_THE_PROJECT"'","text":"on failure ```'"$(tail -20 $LOGFILE | sed -e 's/"//g' )"'```","mrkdwn": true}]}' $SLACK_HOOK
}

slack_hook

