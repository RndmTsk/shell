#!/bin/bash
OLD_IFS=${IFS}
IFS=$'\n'
RESPONSE=${1}
WORKSPACES=$(find . -name "*.xcworkspace" | grep -v 'project.xcworkspace')
PROJECT_FILES=$(find . -name "*.xcodeproj")

POSSIBLE_FILES=(${WORKSPACES} ${PROJECT_FILES})
for INDEX in "${!POSSIBLE_FILES[@]}"; do 
  echo "[$((INDEX+1))] ${POSSIBLE_FILES[${INDEX}]}"
done

NUM_FILES=${#POSSIBLE_FILES[@]}
if [ ${NUM_FILES} -eq 1 ]; then
  IFS=${OLD_IFS}
  open ${POSSIBLE_FILES[0]}
  exit 0
fi

if [ -z "${RESPONSE}" ]; then
  echo -n "open #"
  read -n ${#NUM_FILES} RESPONSE
  echo ""
fi
if [ "${RESPONSE}" -le "${NUM_FILES}" ]; then
        open ${POSSIBLE_FILES[$((RESPONSE-1))]}
else
        echo "No such file."
fi

IFS=${OLD_IFS}
