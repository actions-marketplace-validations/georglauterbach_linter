#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

# shellcheck source=libbash
source /etc/linters/libbash log utils
export SCRIPT=linter
export LOG_LEVEL=${LOG_LEVEL:-trace}

readonly CONFIGURATION_DIR=/etc/linters/configuration

SUCCESS=true

libbash::log::log info 'Starting linter'

if ${ENABLE_ACTIONLINT:-}; then
  # shellcheck disable=SC2154
  libbash::log::log info "Running actionlint ${ACTIONLINT_VERSION}"
  if actionlint \
    -color      \
    -shellcheck "$(command -v shellcheck)" \
    -config-file "${ACTIONLINT_CONFIG:-${CONFIGURATION_DIR}/actionlint.yaml}"
  then
    libbash::log::log info 'Linting with actionlint succeeded'
  else
    libbash::log::log warn 'Linting with actionlint failed'
    SUCCESS=false
  fi
fi

if ${ENABLE_EDITORCONFIG_CHECKER:-}; then
  # shellcheck disable=SC2154
  libbash::log::log info "Running editorconfig-checker ${EDITORCONFIG_CHECKER_VERSION}"
  if ec    \
    -color \
    -config "${EDITORCONFIG_CHECKER_CONFIG:-${CONFIGURATION_DIR}/editorconfig_checker.json}"
  then
    libbash::log::log info 'Linting with editorconfig-checker succeeded'
  else
    libbash::log::log warn 'Linting with editorconfig-checker failed'
    SUCCESS=false
  fi
fi

if ${ENABLE_HADOLINT:-}; then
  # shellcheck disable=SC2154
  libbash::log::log info "Running hadolint ${HADOLINT_VERSION}"
  HADOLINT_SUCCESS=true
  while read -r FILE; do
    if ! hadolint \
      --config "${HADOLINT_CONFIG:-${CONFIGURATION_DIR}/hadolint.yaml}" \
      "${FILE}"
    then
      HADOLINT_SUCCESS=false
    fi
  done < <(find . -name Dockerfile)

  if "${HADOLINT_SUCCESS}"; then
    libbash::log::log info 'Linting with hadolint succeeded'
  else
    libbash::log::log warn 'Linting with hadolint failed'
    SUCCESS=false
  fi
fi

if ${ENABLE_SHELLCHECK:-}; then
  # shellcheck disable=SC2154
  libbash::log::log info "Running shellcheck ${SHELLCHECK_VERSION}"
  SHELLCHECK_SUCCESS=true
  while read -r FILE; do
    if ! shellcheck \
      --rcfile="${SHELLCHECK_CONFIG:-${CONFIGURATION_DIR}/shellcheck.conf}" \
      "${FILE}"
    then
      SHELLCHECK_SUCCESS=false
    fi
  done < <(find . -name '*.sh')

  if "${SHELLCHECK_SUCCESS:-}"; then
    libbash::log::log info 'Linting with shellcheck succeeded'
  else
    libbash::log::log warn 'Linting with shellcheck failed'
    SUCCESS=false
  fi
fi

if ${ENABLE_YAMLLINT:-}; then
  # shellcheck disable=SC2154
  libbash::log::log info "Running yamllint ${YAMLLINT_VERSION%-*}"
  if yamllint       \
    --strict        \
    --format github \
    --config-file "${YAMLLINT_CONFIG:-${CONFIGURATION_DIR}/yamllint.yaml}" \
    .
  then
    libbash::log::log info 'Linting with yamllint succeeded'
  else
    libbash::log::log warn 'Linting with yamllint failed'
    SUCCESS=false
  fi
fi

if ${ENABLE_ZIZMOR:-}; then
  # shellcheck disable=SC2154
  libbash::log::log info "Running zizmor ${ZIZMOR_VERSION}"
  if zizmor             \
    --quiet             \
    --persona=pedantic  \
    --no-online-audits  \
    --no-progress       \
    --format github     \
    --strict-collection \
    --config "${ZIZMOR_CONFIG:-${CONFIGURATION_DIR}/zizmor.yaml}" \
    .
  then
    libbash::log::log info 'Linting with zizmor succeeded'
  else
    libbash::log::log warn 'Linting with zizmor failed'
    SUCCESS=false
  fi
fi

if ${SUCCESS}; then
  libbash::log::log info 'Linting succeeded'
  libbash::utils::exit_success
else
  libbash::utils::exit_failure 1 'Linting failed'
fi
