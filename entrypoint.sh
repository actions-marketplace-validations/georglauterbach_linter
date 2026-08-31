#! /usr/bin/env bash

set -eE -u -o pipefail
shopt -s inherit_errexit

SCRIPT=linter
LOG_LEVEL=${LOG_LEVEL:-debug}
SUCCESS=true

# shellcheck source=libbash
source /etc/linters/libbash log utils

IFS=" " read -r -a ACTIONLINT_CUSTOM_ARGUMENTS \
  <<< "${ACTIONLINT_CUSTOM_ARGUMENTS:--color -shellcheck $(command -v shellcheck)}"
IFS=" " read -r -a EDITORCONFIG_CHECKER_CUSTOM_ARGUMENTS \
  <<< "${EDITORCONFIG_CHECKER_CUSTOM_ARGUMENTS:--color}"
IFS=" " read -r -a HADOLINT_CUSTOM_ARGUMENTS \
  <<< "${HADOLINT_CUSTOM_ARGUMENTS:-}"
IFS=" " read -r -a SHELLCHECK_CUSTOM_ARGUMENTS \
  <<< "${SHELLCHECK_CUSTOM_ARGUMENTS:-}"
IFS=" " read -r -a YAMLLINT_CUSTOM_ARGUMENTS \
  <<< "${YAMLLINT_CUSTOM_ARGUMENTS:---strict --format github}"
IFS=" " read -r -a ZIZMOR_CUSTOM_ARGUMENTS \
  <<< "${ZIZMOR_CUSTOM_ARGUMENTS:---quiet --persona=pedantic --no-online-audits --no-progress --format github --strict-collection}"

readonly CONFIGURATION_DIR=/etc/linters/configuration
readonly ACTIONLINT_CUSTOM_ARGUMENTS           ACTIONLINT_VERSION
readonly EDITORCONFIG_CHECKER_CUSTOM_ARGUMENTS EDITORCONFIG_CHECKER_VERSION
readonly HADOLINT_CUSTOM_ARGUMENTS             HADOLINT_VERSION
readonly SHELLCHECK_CUSTOM_ARGUMENTS           SHELLCHECK_VERSION
readonly YAMLLINT_CUSTOM_ARGUMENTS             YAMLLINT_VERSION
readonly ZIZMOR_CUSTOM_ARGUMENTS               ZIZMOR_VERSION

libbash::log::log debug 'Starting linter'

if ${ENABLE_ACTIONLINT:-}; then
  libbash::log::log info "Running actionlint ${ACTIONLINT_VERSION}"
  if actionlint "${ACTIONLINT_CUSTOM_ARGUMENTS[@]}" \
    -config-file "${ACTIONLINT_CONFIG:-${CONFIGURATION_DIR}/actionlint.yaml}"
  then
    libbash::log::log info 'Linting with actionlint succeeded'
  else
    libbash::log::log warn 'Linting with actionlint failed'
    SUCCESS=false
  fi
fi

if ${ENABLE_EDITORCONFIG_CHECKER:-}; then
  libbash::log::log info "Running editorconfig-checker ${EDITORCONFIG_CHECKER_VERSION}"
  if ec "${EDITORCONFIG_CHECKER_CUSTOM_ARGUMENTS[@]}" \
    -config "${EDITORCONFIG_CHECKER_CONFIG:-${CONFIGURATION_DIR}/editorconfig_checker.json}"
  then
    libbash::log::log info 'Linting with editorconfig-checker succeeded'
  else
    libbash::log::log warn 'Linting with editorconfig-checker failed'
    SUCCESS=false
  fi
fi

if ${ENABLE_HADOLINT:-}; then
  libbash::log::log info "Running hadolint ${HADOLINT_VERSION}"
  HADOLINT_SUCCESS=true
  while read -r FILE; do
    if ! hadolint "${HADOLINT_CUSTOM_ARGUMENTS[@]}" \
      --config "${HADOLINT_CONFIG:-${CONFIGURATION_DIR}/hadolint.yaml}" \
      "${FILE}"
    then
      HADOLINT_SUCCESS=false
    fi
  done < <(find . \( -name Dockerfile -or -name Containerfile \) )

  if "${HADOLINT_SUCCESS}"; then
    libbash::log::log info 'Linting with hadolint succeeded'
  else
    libbash::log::log warn 'Linting with hadolint failed'
    SUCCESS=false
  fi
fi

if ${ENABLE_SHELLCHECK:-}; then
  libbash::log::log info "Running shellcheck ${SHELLCHECK_VERSION}"
  SHELLCHECK_SUCCESS=true
  while read -r FILE; do
    if ! shellcheck "${SHELLCHECK_CUSTOM_ARGUMENTS[@]}" \
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
  libbash::log::log info "Running yamllint ${YAMLLINT_VERSION%-*}"
  if yamllint "${YAMLLINT_CUSTOM_ARGUMENTS[@]}" \
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
  libbash::log::log info "Running zizmor ${ZIZMOR_VERSION}"
  if zizmor "${ZIZMOR_CUSTOM_ARGUMENTS[@]}" \
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
