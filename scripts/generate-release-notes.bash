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

# ex. version_range="v0.343.0...v0.344.0"
version_range="${1:?Please provide the start and end versions you want to generate release notes for './generate-release-notes.bash start_ref...end_ref' }"
local_start_ref=$(get_start_ref_from_range "${version_range}")
local_end_ref=$(get_end_ref_from_range "${version_range}")

display_non_bot_commits "${local_start_ref}" "${local_end_ref}"

WINDOWS_START_REF_HYDRATOR=$(git rev-parse "${local_start_ref}:src/code.cloudfoundry.org/hydrator")
WINDOWS_END_REF_HYDRATOR=$(git rev-parse "${local_end_ref}:src/code.cloudfoundry.org/hydrator")
pushd src/code.cloudfoundry.org/hydrator > /dev/null
  display_non_bot_commits "${WINDOWS_START_REF_HYDRATOR}" "${WINDOWS_END_REF_HYDRATOR}" "hydrator"
  display_go_mod_diff "${WINDOWS_START_REF_HYDRATOR}" "${WINDOWS_END_REF_HYDRATOR}" go.mod "hydrator"
popd > /dev/null
