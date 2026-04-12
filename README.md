# Linter

A container image that you can use to run multiple linters.

All linters are enabled by default. You can disable linters by setting environment variables of the form `ENABLE_<LINTER NAME>`. If you want to supply custom configuration files, set an environment variable of the form `<LINTER NAME>_CONFIG` and supply the path to the configuration as the value.

| Linter | Task | `LINTER NAME` |
| :----- | :--- | :------------ |
| [actionlint](https://github.com/rhysd/actionlint) | static analysis for GitHub Action workflows with a focus on correctness | `ACTIONLINT` |
| [editorconfig-checker](https://github.com/editorconfig-checker/editorconfig-checker) | check [EditorConfig](https://editorconfig.org/) conformance | `EDITORCONFIG_CHECKER` |
| [hadolint](https://github.com/hadolint/hadolint) | Lint `Dockerfile`s | `HADOLINT` |
| [shellcheck](https://github.com/koalaman/shellcheck) | lint shell scripts | `SHELLCHECK` |
| [yamllint](https://github.com/adrienverge/yamllint) | lint YAML files | `YAMLLINT` |
| [zizmor](https://github.com/zizmorcore/zizmor) | static analysis for GitHub Action workflows with a focus on security | `ZIZMOR` |

The default linter configurations can be found in [`configuration/`](./configuration/).
