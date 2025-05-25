#!/bin/sh

set -e

MXLINT="./bin/mxlint"


UNAME="$(uname -s)"
echo "OS: $UNAME"

if [ "$UNAME" = "Linux" ]; then
    DL_SUFFIX="linux-amd64"
elif [ "$UNAME" = "Darwin" ]; then
    DL_SUFFIX="darwin-amd64"
elif [ "$UNAME" = "Windows" ]; then
    DL_SUFFIX="windows-amd64.exe"
else
    echo "Unsupported OS"
    exit 1
fi

if [ ! -f "$MXLINT" ]; then
    echo "Program not found, downloading..."
    mkdir -p bin
    LATEST_VERSION=$(curl -s https://api.github.com/repos/mxlint/mxlint-cli/releases/latest | grep "tag_name" | cut -d '"' -f 4)
    curl -L -q https://github.com/mxlint/mxlint-cli/releases/download/${LATEST_VERSION}/mxlint-${LATEST_VERSION}-${DL_SUFFIX} -o $MXLINT
    chmod +x $MXLINT

fi

# capture all output to a file with tee
$MXLINT test-rules --rules ./rules 2>&1 | tee /tmp/mxlint-test-rules.log

# grep for FAIL in the log file
if grep -q "FAIL" /tmp/mxlint-test-rules.log; then
    echo "Tests failed"
    exit 1
else
    echo "Tests passed"
    exit 0
fi
