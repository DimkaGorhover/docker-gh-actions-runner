FROM ubuntu:focal

# Create User
RUN apt update \
    && apt install -y bash curl \
    && apt clean \
    && rm -rf /var/cache/apt/archives/

WORKDIR /github/actions-runner
ARG USER=github
RUN groupadd --gid 1000 ${USER} \
    && useradd --uid 1000 --gid ${USER} --shell /bin/bash --create-home ${USER}

# Download Github Actions Runner
ARG VERSION='2.276.1'
RUN curl -sSL https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-linux-x64-${VERSION}.tar.gz -o runner.tar.gz \
    && tar xzf runner.tar.gz \
    && rm runner.tar.gz

# Install Dependencies
RUN ./bin/installdependencies.sh \
    && apt update \
    && apt install -y sudo python python3 git openssh-client build-essential rsync \
    && apt clean \
    && rm -rf /var/cache/apt/archives/

# Change Ownership
RUN chown -R ${USER}:${USER} /github

# Add Entrypoint
ADD ./entrypoint.sh ./entrypoint
RUN chmod +x ./entrypoint

ENV GH_RUNNER_TOKEN='' \
    GH_RUNNER_URL='' \
    GH_RUNNER_NAME='' \
    GH_RUNNER_LABELS='self-hosted,Linux,X64' \
    GH_RUNNER_CONFIG_ARGS='' \
    GH_RUNNER_RUN_ARGS=''

USER ${USER}

RUN mkdir -p /github/build-dir
VOLUME [ "/github/build-dir" ]

ENTRYPOINT [ "./entrypoint" ]
