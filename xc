#!/bin/bash
OLD_IFS=${IFS}
IFS=$'\n'
RESPONSE=${1}
PACKAGE_FILES=$(find . -name "Package.swift" | grep -ve ".*/\.build/.*")
WORKSPACES=$(find . -name "*.xcworkspace" | grep -v 'project.xcworkspace' | grep -v 'package.xcworkspace' | grep -ve ".*/\.build/.*")
PROJECT_FILES=$(find . -name "*.xcodeproj" | grep -ve ".*/\.build/.*")

POSSIBLE_FILES=(${WORKSPACES} ${PACKAGE_FILES} ${PROJECT_FILES})
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
esac

IFS=${OLD_IFS}
