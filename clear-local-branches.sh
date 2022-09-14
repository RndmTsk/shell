#!/usr/bin/env bash

# Variables
#IFS=$'\n'

# Configuration
shopt -s extglob # enable globbing to work with pattern matching

# Functions
function verify_branch_delete() {
    # Ask for input to remove
    read -p "${1}" -n RESPONSE
    if [ ! -z "${RESPONSE}" ]; then
        echo ""
    fi
    if [[ "${RESPONSE:-n}" == "y" ]] || [[ "${RESPONSE:-n}" == "Y" ]]; then
        return 0 # User chose to delete (a.k.a. "Success")
    else
        return 1 # User chose NOT to delete (a.k.a. "Failure")
    fi
}

# Main
for BRANCH in $(git branch -l | grep -v '*'); do
    BRANCH_TRIMMED="${BRANCH##*( )}"
    # Does the branch exist on the remote?
    git branch -r | grep "${BRANCH_TRIMMED}" 2>&1 1>>/dev/null
    if [ $? -eq 0 ]; then
        continue
    fi

    # Verify OK to delete
    verify_branch_delete "'${BRANCH_TRIMMED}' missing on remote, delete? [y/N]: "
    if [ $? -ne 0 ]; then
        continue
    fi

    # Attempt to clean-delete the merged branch
    git branch -d "${BRANCH_TRIMMED}" 2>>/dev/null
    if [ $? -eq 0 ]; then
        continue
    fi

    # Verify OK to force delete
    verify_branch_delete "'${BRANCH_TRIMMED}' doesn't match remote, forcefully delete? [y/N]: "
    if [ $? -eq 0 ]; then
        git branch -D "${BRANCH_TRIMMED}"
    fi
done
