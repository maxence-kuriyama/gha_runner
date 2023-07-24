FROM ubuntu:22.04
ARG GHA_RUNNER_SECRET

RUN apt-get update; \
    apt-get install -y curl expect;

RUN mkdir actions-runner; \
    cd actions-runner; \
    curl -o actions-runner-linux-arm64-2.303.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.303.0/actions-runner-linux-arm64-2.303.0.tar.gz; \
    echo "${GHA_RUNNER_SECRET}  actions-runner-linux-arm64-2.303.0.tar.gz" | sha256sum -c; \
    tar xzf ./actions-runner-linux-arm64-2.303.0.tar.gz; \
    rm -f actions-runner-linux-arm64-2.303.0.tar.gz; \
    ./bin/installdependencies.sh; \
    apt-get install -y git;

# Rust install
ENV RUST_HOME="/usr/local/lib/rust" \
    RUSTUP_HOME="${RUST_HOME}/rustup" \
    CARGO_HOME="${RUST_HOME}/cargo"
RUN apt-get install -y gcc; \
    mkdir /usr/local/lib/rust; \
    chmod 0755 ${RUST_HOME}; \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > ${RUST_HOME}/rustup.sh; \
    chmod +x ${RUST_HOME}/rustup.sh; \
    ${RUST_HOME}/rustup.sh -y --default-toolchain nightly --no-modify-path;
ENV PATH="$PATH:$CARGO_HOME/bin"

# Node.js install
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1655A0AB68576280; \
    apt-get update; \
    apt-get install -y nodejs; \
    apt autoremove;

WORKDIR /actions-runner
