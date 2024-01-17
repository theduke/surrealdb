###
# STAGE: builder
# This stage is used to build the SurrealDB linux binary
###

FROM docker.io/rockylinux:8 as builder

RUN yum install -y gcc-toolset-13 git cmake patch zlib-devel python3.11

# Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rustup.sh
RUN sh /tmp/rustup.sh -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup target add x86_64-unknown-linux-gnu
RUN rustup target add aarch64-unknown-linux-gnu

WORKDIR /surrealdb

COPY docker/builder-entrypoint.sh /builder-entrypoint.sh
RUN chmod +x /builder-entrypoint.sh

ENTRYPOINT ["/builder-entrypoint.sh"]

###
# Final Images
###

#
# Production image (built on the CI environment)
#
FROM --platform=$TARGETPLATFORM cgr.dev/chainguard/glibc-dynamic:latest as prod-ci

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG ARTIFACT_PREFIX

COPY ${ARTIFACT_PREFIX}.${TARGETOS}-${TARGETARCH}/surreal /surreal

ENTRYPOINT ["/surreal"]

#
# Development image (built on the CI environment)
#
FROM --platform=$TARGETPLATFORM cgr.dev/chainguard/glibc-dynamic:latest-dev as dev-ci

ARG TARGETPLATFORM

USER root

COPY --from=prod-ci /surreal /surreal

ENTRYPOINT ["/surreal"]

#
# Production image (built locally)
#
FROM cgr.dev/chainguard/glibc-dynamic:latest as prod

ARG SURREALDB_BINARY=target/release/surreal

COPY ${SURREALDB_BINARY} /surreal

ENTRYPOINT ["/surreal"]

#
# Development image (built locally)
#
FROM cgr.dev/chainguard/glibc-dynamic:latest-dev as dev

USER root

COPY --from=prod /surreal /surreal

ENTRYPOINT ["/surreal"]
