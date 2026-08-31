# Changelog

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/georglauterbach/linter/compare/v0.4.5...HEAD)

> [!NOTE]
>
> Changes and additions listed here have not been released yet.

## [v0.4.5](https://github.com/georglauterbach/linter/releases/tag/v0.4.5)

- **Changed**
  - updated Ubuntu base image ([#7](https://github.com/georglauterbach/linter/pull/7))
- **Added**
  - integrated [project template](https://github.com/georglauterbach/template)

## [v0.4.4](https://github.com/georglauterbach/linter/releases/tag/v0.4.4)

- **Added**
  - added `.copier-answers.yml` to the list of ignored files for YAMLlint

## [v0.4.3](https://github.com/georglauterbach/linter/releases/tag/v0.4.3)

- **Added**
  - zizmor rule `pinned-images` to the list of ignored rules

## [v0.4.2](https://github.com/georglauterbach/linter/releases/tag/v0.4.2)

- **Added**
  - added `pnpm-lock.yaml` to the list of ignored files for YAMLlint

## [v0.4.1](https://github.com/georglauterbach/linter/releases/tag/v0.4.1)

- **Fixed**
  - replaced wrong `SHELLCHECK_CUSTOM_ARGUMENTS` with `YAMLLINT_CUSTOM_ARGUMENTS`

## [v0.4.0](https://github.com/georglauterbach/linter/releases/tag/v0.4.0)

- **Added**
  - allow setting custom arguments for linters
- **Changed**
  - renamed `Dockerfile` -> `Containerfile`
  - updated `libbash`
  - updated ECC & Zizmor

## [v0.3.2](https://github.com/georglauterbach/linter/releases/tag/v0.3.2)

- **Changed**
  - added new files and directories to ignore list of EditorConfig-Checker linter

## [v0.3.1](https://github.com/georglauterbach/linter/releases/tag/v0.3.1)

- **Fixed**
  - updated version in [`action.yml`](./action.yml)

## [v0.3.0](https://github.com/georglauterbach/linter/releases/tag/v0.3.0)

- **Changed**
  - updated Zizmor from 1.23.1 to 1.24.1

## [v0.2.2](https://github.com/georglauterbach/linter/releases/tag/v0.2.2)

- **Changed**
  - updated `libbash` from 12.1.0 to 12.1.1
  - in [`Dockerfile`](./Dockerfile)
    - updated base image
    - updated label `org.opencontainers.image.description`
    - removed pinning of auxiliary packages
    - collapsed multiple cleanup commands into one
- **Added**
  - Dependabot configuration for the Docker ecosystem
  - funding option in GitHub

## [v0.2.1](https://github.com/georglauterbach/linter/releases/tag/v0.2.1)

- **Added**
  - zizmor rule `secrets-outside-env` is now disabled by default

## [v0.2.0](https://github.com/georglauterbach/linter/releases/tag/v0.2.0)

- **Changed**
  - updated [yamllint configuration](./configuration/yamllint.yaml)

## [v0.1.1](https://github.com/georglauterbach/linter/releases/tag/v0.1.1)

- **Changed**
  - silenced output from `apt` in [`Dockerfile`](./Dockerfile)

## [v0.1.0](https://github.com/georglauterbach/linter/releases/tag/v0.1.0)

- **Added**
  - Initial release
