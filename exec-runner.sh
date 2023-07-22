#!/bin/bash

if [ -z "${GITHUB_DOMAIN}" ]; then
  echo "GITHUB_DOMAIN must be set" 1>&2
  exit 1
fi

if [ -z "${GITHUB_REPOSITORY_NAME}" ]; then
  echo "GITHUB_REPOSITORY_NAME must be set" 1>&2
  exit 1
fi

if [ -z "${GITHUB_REPOSITORY_OWNER}" ]; then
  echo "GITHUB_REPOSITORY_OWNER must be set" 1>&2
  exit 1
fi

if [ -z "${GITHUB_RUNNER_REGISTRATION_TOKEN}" ]; then
  echo "GITHUB_RUNNER_REGISTRATION_TOKEN must be set" 1>&2
  exit 1
fi

export RUNNER_ALLOW_RUNASROOT=1

# config.shを実行する
expect -c "
set timeout 10
log_user 0
spawn ./config.sh --url https://${GITHUB_DOMAIN}/${GITHUB_REPOSITORY_OWNER}/${GITHUB_REPOSITORY_NAME} --token ${GITHUB_RUNNER_REGISTRATION_TOKEN}
log_user 1
expect  -re \"Enter the name of the runner group to add this runner to:.*\"
send \"\n\"
expect  -re \"Enter the name of runner:.*\"
send \"${GITHUB_RUNNER_NAME}\n\"
expect  -re \"Enter any additional labels.*\"
send \"\n\"
expect  -re \"Enter name of work folder:.*\"
send \"\n\"
expect \"#\"
exit 0
"

./run.sh