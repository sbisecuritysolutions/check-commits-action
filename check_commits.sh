#!/bin/bash

usage() {
  echo "Usage:"
  echo "  $(basename "$0") BASE_COMMIT HEAD_COMMIT REGEX_FILTER"
}


# shellcheck disable=SC2001
log_info() {
  echo "$@" | sed 's/^/INFO:\t/'
}

# shellcheck disable=SC2001
log_err() {
  echo "$@" | sed 's/^/ERROR:\t/' >&2
}

check_commits() {
  local base_commit=$1
  local head_commit=$2
  local regex_filter=$3

  commits=$(git log -i -P --grep "$regex_filter" --format="%h %s" "$base_commit..$head_commit" --)

  if [[ -n $commits ]]; then
    log_err "The following commits match pattern \"$regex_filter\":"
    log_err "$commits"
    return 1
  fi

  log_info "No commits matching pattern \"$regex_filter\" found"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  set -euo pipefail

  [[ $# -ne 3 ]] && { usage >&2; exit 1; }

  [[ ${RUNNER_DEBUG:-} == "1" ]] && set -x

  check_commits "$@"
fi
