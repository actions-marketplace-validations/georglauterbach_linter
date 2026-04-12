# syntax=docker.io/docker/dockerfile:1

FROM docker.io/ubuntu@sha256:cc925e589b7543b910fea57a240468940003fbfc0515245a495dd0ad8fe7cef1

ARG VCS_VERSION=edge
ARG VSC_REVISION=unknown

# https://snyk.io/de/blog/how-and-when-to-use-docker-labels-oci-container-annotations/
LABEL org.opencontainers.image.title="linter"
LABEL org.opencontainers.image.description="A linter image composed of common linters"
LABEL org.opencontainers.image.source="https://github.com/georglauterbach/linter"
LABEL org.opencontainers.image.revision="${VSC_REVISION}"
LABEL org.opencontainers.image.base.digest="cc925e589b7543b910fea57a240468940003fbfc0515245a495dd0ad8fe7cef1"
LABEL org.opencontainers.image.base.name="docker.io/alpine"
LABEL org.opencontainers.image.version="${VCS_VERSION}"

ENV ACTIONLINT_VERSION=1.7.12
ENV EDITORCONFIG_CHECKER_VERSION=3.6.1
ENV HADOLINT_VERSION=2.14.0
ENV SHELLCHECK_VERSION=0.11.0
ENV YAMLLINT_VERSION=1.37.1-1
ENV ZIZMOR_VERSION=1.23.1

WORKDIR /tmp

RUN apt-get -qq update \
    && apt-get -qq -o=Dpkg::Use-Pty=0 install --no-install-recommends \
        ca-certificates=20250419build1 \
        wget=1.25.0-2ubuntu4 \
    \
    && wget --quiet -O actionlint.tar.gz \
        "https://github.com/rhysd/actionlint/releases/download/v${ACTIONLINT_VERSION}/actionlint_${ACTIONLINT_VERSION}_linux_amd64.tar.gz" \
    && tar xf actionlint.tar.gz actionlint \
    && mv actionlint /usr/local/bin/actionlint \
    \
    && wget --quiet -O editorconfig-checker.tar.gz \
        "https://github.com/editorconfig-checker/editorconfig-checker/releases/download/v${EDITORCONFIG_CHECKER_VERSION}/ec-linux-amd64.tar.gz" \
    && tar xf editorconfig-checker.tar.gz bin/ec-linux-amd64 \
    && mv bin/ec-linux-amd64 /usr/local/bin/ec \
    && rmdir bin \
    \
    && wget --quiet -O /usr/local/bin/hadolint \
        "https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-linux-x86_64" \
    \
    && wget --quiet -O shellcheck.tar.gz \
        "https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.$(uname -m).tar.gz" \
    && tar xf shellcheck.tar.gz "shellcheck-v${SHELLCHECK_VERSION}/shellcheck" \
    && mv "shellcheck-v${SHELLCHECK_VERSION}/shellcheck" /usr/local/bin/shellcheck \
    && rmdir "shellcheck-v${SHELLCHECK_VERSION}" \
    \
    && apt-get --yes install --no-install-recommends yamllint=${YAMLLINT_VERSION} \
    \
    && wget --quiet -O zizmor.tar.gz \
        "https://github.com/zizmorcore/zizmor/releases/download/v${ZIZMOR_VERSION}/zizmor-x86_64-unknown-linux-gnu.tar.gz" \
    && tar xf zizmor.tar.gz ./zizmor \
    && mv zizmor /usr/local/bin/zizmor \
    \
    && chmod +x /usr/local/bin/* \
    && apt-get -qq remove wget \
    && apt-get -qq autoremove \
    && apt-get -qq clean \
    && rm -rf ./* /var/lib/apt/lists

COPY libbash       /etc/linters/libbash
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY configuration /etc/linters/configuration

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
