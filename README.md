# A Composite Linter

A container image & GitHub Action that you can use to run multiple linters.

1. All linters are enabled by default. You can disable linters by setting environment variables of the form `ENABLE_<LINTER NAME>`.
2. If you want to supply custom configuration files, set an environment variable of the form `<LINTER NAME>_CONFIG` and supply the path to the configuration as the value. The default linter configurations can be found in [`configuration/`](./configuration/).
3. If you want to supply custom arguments to a linter, set `<LINTER_NAME>_CUSTOM_ARGUMENTS`. Take a look at [`entrypoint.sh`](./entrypoint.sh) to see which custom arguments are set for each linter.

| Linter | Task | `LINTER NAME` |
| :----- | :--- | :------------ |
| [actionlint](https://github.com/rhysd/actionlint) | analysis of GitHub CI/CD workflows with a focus on correctness | `ACTIONLINT` |
| [editorconfig-checker](https://github.com/editorconfig-checker/editorconfig-checker) | check [EditorConfig](https://editorconfig.org/) conformance | `EDITORCONFIG_CHECKER` |
| [hadolint](https://github.com/hadolint/hadolint) | analysis of `Containerfile`s | `HADOLINT` |
| [shellcheck](https://github.com/koalaman/shellcheck) | analysis of shell scripts | `SHELLCHECK` |
| [yamllint](https://github.com/adrienverge/yamllint) | analysis of YAML files | `YAMLLINT` |
| [zizmor](https://github.com/zizmorcore/zizmor) | analysis of GitHub CI/CD workflows with a focus on security | `ZIZMOR` |
