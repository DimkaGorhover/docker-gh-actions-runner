#!/bin/bash
set -e

echo "Removing Github Action Runner Configuration ..."
./config.sh remove \
    --token ${GH_RUNNER_TOKEN}

echo "Configuring Github Action Runner ..."
./config.sh \
    --name ${GH_RUNNER_NAME} \
    --url ${GH_RUNNER_URL} \
    --token ${GH_RUNNER_TOKEN} \
    --work /github/build-dir \
    --labels ${GH_RUNNER_LABELS} \
    ${GH_RUNNER_CONFIG_ARGS}

echo "Starting Github Action Runner ..."
./run.sh ${GH_RUNNER_RUN_ARGS}
