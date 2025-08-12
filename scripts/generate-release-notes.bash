#!/bin/bash

set -eu
set -o pipefail

THIS_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CI="${THIS_FILE_DIR}/../../wg-app-platform-runtime-ci"
. "$CI/shared/helpers/release-note-helpers.bash"
. "$CI/shared/helpers/git-helpers.bash"
REPO_NAME=$(git_get_remote_name)
REPO_PATH="${THIS_FILE_DIR}/../"
unset THIS_FILE_DIR

WINDOWS_START_REF="${1}" # ex: "v0.0.7"
WINDOWS_END_REF="${2}" # ex: "v0.0.8"

get_non_bot_commits "${WINDOWS_START_REF}" "${WINDOWS_END_REF}"
echo ""

WINDOWS_START_REF_HYDRATOR=$(git rev-parse "${WINDOWS_START_REF}:src/code.cloudfoundry.org/hydrator")
WINDOWS_END_REF_HYDRATOR=$(git rev-parse "${WINDOWS_END_REF}:src/code.cloudfoundry.org/hydrator")
pushd src/code.cloudfoundry.org/hydrator > /dev/null
  get_non_bot_commits "${WINDOWS_START_REF_HYDRATOR}" "${WINDOWS_END_REF_HYDRATOR}" "hydrator"
  echo ""

  display_go_mod_diff "${WINDOWS_START_REF_HYDRATOR}" "${WINDOWS_END_REF_HYDRATOR}" go.mod "hydrator"
  echo ""
popd > /dev/null
