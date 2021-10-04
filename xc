#!/bin/bash
OLD_IFS=${IFS}
IFS=$'\n'
RESPONSE=${1}
WORKSPACES=$(find . -name "*.xcworkspace" | grep -v 'project.xcworkspace' | grep -v 'package.xcworkspace')
PROJECT_FILES=$(find . -name "*.xcodeproj")

POSSIBLE_FILES=(${WORKSPACES} ${PROJECT_FILES})
NUM_FILES=${#POSSIBLE_FILES[@]}
if [ ${NUM_FILES} -eq 1 ]; then
  IFS=${OLD_IFS}
  echo ${POSSIBLE_FILES[0]}
  open ${POSSIBLE_FILES[0]}
  exit 0
fi

if [ -z "${RESPONSE}" ]; then
  for INDEX in "${!POSSIBLE_FILES[@]}"; do 
    echo "[$((INDEX+1))] ${POSSIBLE_FILES[${INDEX}]}"
  done

  echo -n "open #"
  read -n ${#NUM_FILES} RESPONSE
  echo ""
fi

case "${RESPONSE}" in
  ''|*[!0-9]*) echo "\"${RESPONSE}\" is invalid, select a value between 0-${NUM_FILES}."
  ;;

  *)
  if [ "${RESPONSE}" -le "${NUM_FILES}" ]; then
    RESPONSE_INDEX=$((RESPONSE-1))
    echo "Opening ${POSSIBLE_FILES[${RESPONSE_INDEX}]}"
    open ${POSSIBLE_FILES[${RESPONSE_INDEX}]}
  else
    echo "No such file."
  fi
  ;;

IFS=${OLD_IFS}
