#!/usr/bin/env bash

## Notes ##

# ASCII text courtesy of https://patorjk.com/software/taag/#p=display&f=Calvin%20S
# Font: Calvin S
# Character Width/Height: Default

## Variables ##

CHECKING="❓"
MISSING="❗️"
SUCCESS="✅"
FAILURE="❌"


## Functions ##

# Checks for a given .app, opening ${REMOTE_LOCATION} if missing
# Parameters:
#   1. Name
#   2. Local location (e.g. "/Applications/MyApp.app")
#   3. Remote location (e.g. "https://apps.apple.com/us/app/xcode/id497799835")
function check_for_app() {
  NAME="${1}"
  LOCAL_LOCATION="${2}"
  REMOTE_LOCATION="${3}"

  echo -ne "\r    ${CHECKING} ${NAME}"
  if [ -d "${LOCAL_LOCATION}" ]; then
    echo -ne "\r    ${SUCCESS} ${NAME}"
  else
    open -Wn "${REMOTE_LOCATION}"
    if [ -d "${LOCAL_LOCATION}" ]; then
      echo -ne "\r    ${SUCCESS} ${NAME}"
    else
      echo -ne "\r    ${FAILURE} ${NAME}"
    fi
  fi
  echo ''
}

# Checks for a local copy of a given git repository
# cloning ${REMOTE_LOCATION} to ${LOCAL_LOCATION} if missing
# Parameters:
#   1. Name
#   2. Local location (e.g. "/path/to/directory")
#   3. Remote location (e.g. "git@github.com:RndmTsk/shell.git")
function check_for_git_repos() {
  NAME="${1}"
  LOCAL_LOCATION="${2}"
  REMOTE_LOCATION="${3}"

  echo -ne "\r    ${CHECKING} ${NAME}"
  if [ -d "${LOCAL_LOCATION}" ]; then
    echo -ne "\r    ${SUCCESS} ${NAME}"
  else
    RESULT=$(git clone "${REMOTE_LOCATION}" "${LOCAL_LOCATION}" 2>&1)
    if [ -d "${LOCAL_LOCATION}" ]; then
      echo -ne "\r    ${SUCCESS} ${NAME}"
    else
      echo -ne "\r    ${FAILURE} ${NAME}"
      echo ''
      echo ''
      echo "Details: ${RESULT}"
    fi
  fi
  echo ''
}

# Checks for a local installation with a BASH command (${LOCAL_CHECK_COMMAND}),
# if missing run ${INSTALL_COMMAND} to install - re-checking afterward
# Parameters:
#   1. Name
#   2. Local command to check if it exists (e.g. "ls /path/to/file.txt")
#   3. Install command if missing (e.g. "brew install rbenv")
function check_local_install() {
  NAME="${1}"
  LOCAL_CHECK_COMMAND="${2}"
  INSTALL_COMMAND="${3}"

  echo -ne "\r    ${CHECKING} ${NAME}"
  ${LOCAL_CHECK_COMMAND} > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -ne "\r    ${SUCCESS} ${NAME}"
  else
    RESULT=$(${INSTALL_COMMAND} 2>&1)
    ${LOCAL_CHECK_COMMAND} > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      echo -ne "\r    ${SUCCESS} ${NAME}"
    else
      echo -ne "\r    ${FAILURE} ${NAME}"
      echo ''
      echo ''
      echo "Details: ${RESULT}"
    fi
  fi
  echo ''
}

# Checks for a local installation of a font, cloning, and adding to FontBook if missing
# Parameters:
#   1. Name of the font (used for display purposes)
#   2. Local location of the font (e.g. "/path/to/font/directory")
#   3. Remote location of the font (e.g. "https://github.com/tonsky/FiraCode.git")
function check_for_git_font() {
  FONT_NAME="${1}"
  LOCAL_LOCATION="${2}"
  REMOTE_LOCATION="${3}"
  check_for_git_repos "${FONT_NAME}" "${LOCAL_LOCATION}" "${REMOTE_LOCATION}"
  if [ -d "${LOCAL_LOCATION}" ]; then
      FONTS=()
      while IFS=  read -r -d $'\0'; do
        FONTS+=("${REPLY}")
      done < <(find "${LOCAL_LOCATION}" -name "*.ttf" -print0)
      for FONT in ${FONTS[@]}; do
        FONT_BASE_NAME=$(basename ${FONT} .ttf)
        check_local_install "${FONT_NAME} - FontBook [${FONT_BASE_NAME}]" "ls ${HOME}/Library/Fonts/${FONT_BASE_NAME}.ttf" "open -Wn ${FONT}"
      done
      
  fi
}

# Performs a script command (${SCRIPT}), checking for success, on failure
# The stdout and stderr details are printed
# Parameters:
#   1. Name
function run_script() {
    SCRIPT="${1}"

  echo -ne "\r    ${CHECKING} ${SCRIPT}"
  RESULT=$(${SCRIPT} 2>&1)
  if [ $? -eq 0 ]; then
    echo -ne "\r    ${SUCCESS} ${SCRIPT}"
  else
    echo -ne "\r    ${FAILURE} ${SCRIPT}"
    echo ''
    echo ''
    echo "Details: ${RESULT}"
  fi
  echo ''
}

# Checks for the existence of a local directory via the 'ls' command
# if missing run 'mkdir' for the specified directory name
# Parameters:
#   1. Full directory path
function check_local_dir() {
  check_local_install "${1}" "ls ${1}" "mkdir ${1}"
}

# Checks for the existence of a VS Code plugin using the plugin name
# Parameters:
#   1. The plugin name as per VS Code command line extension management
#  https://code.visualstudio.com/docs/editor/extension-marketplace#_command-line-extension-management
function check_for_vs_code_plugin() {
  check_local_install "${1} plugin" "code --list-extensions | grep ${1}" "code --install-extension ${1}"
}


### MAIN ###


clear

echo ' __ _  ____  _  _    _  _   __    ___  ____   __    __  __ _     ____  _  _ '
echo '(  ( \(  __)/ )( \  ( \/ ) / _\  / __)(  _ \ /  \  /  \(  / )   / ___)/ )( \'
echo '/    / ) _) \ /\ /  / \/ \/    \( (__  ) _ ((  O )(  O ))  (  _ \___ \) __ ('
echo '\_)__)(____)(_/\_)  \_)(_/\_/\_/ \___)(____/ \__/  \__/(__\_)(_)(____/\_)(_/'
echo ''
echo 'Automated(-ish) setup for all your development tools'
echo '   "Just sit back and relax" -- your new MacBook'
echo ''
echo ''

echo 'Checking for required developer tools ...'
echo ''
echo 'NOTE: If a browser tab is opened, you are being prompted to install'
echo '      that tool, close THE ENTIRE BROWSER (sorry) to continue the'
echo '      setup process.'
echo ''

#

echo '╔═╗┌─┐┌┬┐┌─┐  ╔╦╗┬┬─┐┌─┐┌─┐┌┬┐┌─┐┬─┐┬┌─┐┌─┐'
echo '║  │ │ ││├┤    ║║│├┬┘├┤ │   │ │ │├┬┘│├┤ └─┐'
echo '╚═╝└─┘─┴┘└─┘  ═╩╝┴┴└─└─┘└─┘ ┴ └─┘┴└─┴└─┘└─┘'
echo ''

check_local_dir "${HOME}/bin"
check_local_dir "${HOME}/Code"
check_local_dir "${HOME}/Code/Apple Platforms"
check_local_dir "${HOME}/Code/Apple Platforms/macOS"
check_local_dir "${HOME}/Code/Apple Platforms/macOS/Experiments"
check_local_dir "${HOME}/Code/Apple Platforms/macOS/Articles"
check_local_dir "${HOME}/Code/Apple Platforms/iOS"
check_local_dir "${HOME}/Code/Apple Platforms/iOS/Experiments"
check_local_dir "${HOME}/Code/Apple Platforms/iOS/Articles"
check_local_dir "${HOME}/Code/go"
check_local_dir "${HOME}/Code/go/src"
check_local_dir "${HOME}/Code/Web"
check_local_dir "${HOME}/Code/Docker"

echo ''
echo ''

#

echo '╔═╗┌─┐┌─┐  ╔═╗┌┬┐┌─┐┬─┐┌─┐'
echo '╠═╣├─┘├─┘  ╚═╗ │ │ │├┬┘├┤ '
echo '╩ ╩┴  ┴    ╚═╝ ┴ └─┘┴└─└─┘'
echo ''

check_for_app 'Xcode' '/Applications/Xcode.app' 'https://apps.apple.com/us/app/xcode/id497799835'
check_for_app 'Slack' '/Applications/Slack.app' 'https://apps.apple.com/us/app/slack-for-desktop/id803453959'
check_for_app 'Dynamo' '/Applications/Dynamo.app' 'https://apps.apple.com/us/app/dynamo/id1445910651'
check_for_app 'Flow' '/Applications/Flow.app' 'https://apps.apple.com/us/app/flow-focus-pomodoro-timer/id1423210932'
# Purchased on my personal account
# check_for_app 'Magnet' '/Applications/Magnet.app' 'https://apps.apple.com/us/app/magnet/id441258766'
check_for_app 'Meeting Bar' '/Applications/MeetingBar.app' 'https://apps.apple.com/us/app/meetingbar/id1532419400?mt=12'
echo ''
echo ''

#

echo '╔╦╗┌─┐┬ ┬┌┐┌┬  ┌─┐┌─┐┌┬┐┌─┐'
echo ' ║║│ ││││││││  │ │├─┤ ││└─┐'
echo '═╩╝└─┘└┴┘┘└┘┴─┘└─┘┴ ┴─┴┘└─┘'
echo ''

check_for_app 'VS Code' '/Applications/Visual Studio Code.app' 'https://code.visualstudio.com'
check_for_app 'Sublime Text' '/Applications/Sublime Text.app' 'https://www.sublimetext.com'
check_for_app 'Sublime Merge' '/Applications/Sublime Merge.app' 'https://www.sublimemerge.com'
check_for_app 'Charles Proxy' '/Applications/Charles.app' 'https://www.charlesproxy.com/download'
check_for_app 'Discord' '/Applications/Discord.app' 'https://discord.com/api/download?platform=osx'
check_for_app 'SF Symbols' '/Applications/SF Symbols.app' 'https://developer.apple.com/sf-symbols'
check_for_app 'Postman' '/Applications/Postman.app' 'https://www.postman.com/downloads/'
echo ''
echo ''

#

echo '╦  ╦╔═╗  ╔═╗┌─┐┌┬┐┌─┐  ╔═╗─┐ ┬┌┬┐┌─┐┌┐┌┌─┐┬┌─┐┌┐┌┌─┐'
echo '╚╗╔╝╚═╗  ║  │ │ ││├┤   ║╣ ┌┴┬┘ │ ├┤ │││└─┐││ ││││└─┐'
echo ' ╚╝ ╚═╝  ╚═╝└─┘─┴┘└─┘  ╚═╝┴ └─ ┴ └─┘┘└┘└─┘┴└─┘┘└┘└─┘'
echo ''

which code > /dev/null 2>&1
if [ $? -eq 0 ]; then
  check_for_vs_code_plugin 'golang.go'
  check_for_vs_code_plugin 'jebbs.plantuml'
  check_for_vs_code_plugin 'ms-vscode.cpptools'
  check_for_vs_code_plugin 'ms-vsliveshare.vsliveshare'
  check_for_vs_code_plugin 'wingrunr21.vscode-ruby'
  check_for_vs_code_plugin 'Yog.yog-plantuml-highlight'
  check_for_vs_code_plugin 'yzhang.markdown-all-in-one'
  check_for_vs_code_plugin 'zhouronghui.propertylist'
else
  echo "    ${MISSING} VS Code unavailable, skipping"
fi
echo ''
echo ''

#

echo '╔═╗┬ ┬┌─┐┬  ┬    ╔╦╗┌─┐┌─┐┬  ┌─┐'
echo '╚═╗├─┤├┤ │  │     ║ │ ││ ││  └─┐'
echo '╚═╝┴ ┴└─┘┴─┘┴─┘   ╩ └─┘└─┘┴─┘└─┘'
echo ''

# M1 macOS installs brew to /opt
export PATH="/opt/homebrew/bin:${PATH}"

# Go won't be added to the path of _this_ shell (BASH) even if we have a valid .zshrc
export PATH="${PATH}:/usr/local/go/bin"

check_local_install 'ZSH Config' "ls ${HOME}/.zshrc" "curl -o ${HOME}/.zshrc -k https://raw.githubusercontent.com/RndmTsk/shell/master/zshrc"
check_local_install 'Homebrew' 'which brew' 'open -Wn https://brew.sh'
check_local_install 'Go' 'go version' 'open -Wn https://golang.org/dl'
check_local_install 'LLDB Init' "ls ${HOME}/.lldbinit" "curl -o ${HOME}/.lldbinit -k https://raw.githubusercontent.com/RndmTsk/shell/master/lldbinit"
check_local_install 'NSError Decoder' "ls ${HOME}/bin/nserror-decoder.swift" "curl -o ${HOME}/bin/nserror-decoder.swift -k https://raw.githubusercontent.com/RndmTsk/shell/master/nserror-decoder.swift"
check_local_install 'xc' "ls ${HOME}/bin/xc" "curl -o ${HOME}/bin/xc -k https://raw.githubusercontent.com/RndmTsk/shell/master/xc"
# Getting file not found for ${HOME}/bin/subl and ${HOME}/bin/smerge (but that's the point?)
# check_local_install 'Sublime Text - subl command' 'which subl' "ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl ${HOME}/bin/subl"
# check_local_install 'Sublime Merge - smerge command' 'which smerge' "ln -s /Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/smerge ${HOME}/bin/smerge"
echo ''
echo ''

#

echo '╔╗ ┬─┐┌─┐┬ ┬  ╔╦╗┌─┐┌─┐┬  ┌─┐'
echo '╠╩╗├┬┘├┤ │││   ║ │ ││ ││  └─┐'
echo '╚═╝┴└─└─┘└┴┘   ╩ └─┘└─┘┴─┘└─┘'
echo ''

which brew > /dev/null 2>&1
if [ $? -eq 0 ]; then
  check_local_install 'OpenSSL' 'which openssl' 'brew install openssl'
  check_local_install 'Git' 'which git' 'brew install git'
  check_local_install 'Python 3' 'which python3' 'brew install python3'
  check_local_install 'rlwrap' 'which rlwrap' 'brew install rlwrap'
  check_local_install 'Powerlevel 10k' 'which p10k' 'brew install romkatv/powerlevel10k/powerlevel10k'
  # TODO: Add "source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme" to `.zshrc`
else
  echo "    ${MISSING} Homebrew unavailable, skipping"
fi
echo ''
echo ''



#

echo '╔═╗╔═╗╦ ╦   ┬   ╔═╗┬┌┬┐'
echo '╚═╗╚═╗╠═╣  ┌┼─  ║ ╦│ │ '
echo '╚═╝╚═╝╩ ╩  └┘   ╚═╝┴ ┴ '
echo ''

echo -ne "\r    ${CHECKING} SSH agent"
ssh-add -l > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo -ne "\r    ${SUCCESS} SSH agent"
else
  echo -ne "\r    ${MISSING} SSH agent"
  echo ''
  echo ''
  echo 'SSH agent setup'
  ssh-add
  echo ''
  echo -ne "\r    ${CHECKING} SSH agent - retry"
  ssh-add -l > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -ne "\r    ${SUCCESS} SSH agent - retry"
  else
    echo -ne "\r    ${FAILURE} SSH agent - retry"
    exit 2
  fi
fi
echo ''

echo -ne "\r    ${CHECKING} Git"
which git > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo -ne "\r    ${SUCCESS} Git"
  echo ''
  echo -ne "\r    ${CHECKING} Git - User config"
  git config --global user.name "Terry Latanville"
  echo -ne "\r    ${SUCCESS} Git - User config"
  echo ''
  echo -ne "\r    ${CHECKING} Git - smerge command"
  git config --global mergetool.smerge.cmd 'smerge mergetool "${BASE}" "${LOCAL}" "${REMOTE}" -o "${MERGED}"'
  echo -ne "\r    ${SUCCESS} Git - smerge command"
  echo ''
  echo -ne "\r    ${CHECKING} Git - smerge exit code"
  git config --global mergetool.smerge.trustExitCode true
  echo -ne "\r    ${SUCCESS} Git - smerge exit code"
  echo ''
  echo -ne "\r    ${CHECKING} Git - disable merge backups"
  git config --global mergetool.keepBackup false
  echo -ne "\r    ${SUCCESS} Git - disable merge backups"
  echo ''
  echo -ne "\r    ${CHECKING} Git - merge tool"
  git config --global merge.tool smerge
  echo -ne "\r    ${SUCCESS} Git - merge tool"
else
  echo -ne "\r    ${FAILURE} Git"
  echo ''
  exit 1
fi
echo ''
echo ''
echo ''

#

echo '╔═╗─┐ ┬┌┬┐┬─┐┌─┐┌─┐'
echo '║╣ ┌┴┬┘ │ ├┬┘├─┤└─┐'
echo '╚═╝┴ └─ ┴ ┴└─┴ ┴└─┘'
echo ''

which git > /dev/null 2>&1
if [ $? -eq 0 ]; then
    check_for_git_font 'Fira Code' "${HOME}/Code/FiraCode" 'https://github.com/tonsky/FiraCode.git'
else
    echo "    ${MISSING} Git unavailable, skipping 'FiraCode'"
fi

echo ''
echo ''

if [ -f "./company-specific-setup.sh" ]; then
  chmod a+x ./company-specific-setup.sh > /dev/null 2>&1
  ./company-specific-setup.sh
fi

# Unaccounted for:
#   xcode-select --install ??
#
#   Auto-add favourites to Finder
#   rlwrap /usr/libexec/PlistBuddy -c "Print" Library/Preferences/com.apple.finder.plist

echo '  All done, enjoy!'
echo ''
