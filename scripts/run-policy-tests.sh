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

# copy rules into the default cache location that test-rules reads from
mkdir -p .mendix-cache/rules
cp -R ./rules/. .mendix-cache/rules/
trap 'rm -rf .mendix-cache/' EXIT

# Rules resolve documents through the app.yaml the exporter writes at the model
# root; generate the same index over the fixtures so it cannot drift from them.
for CATEGORY in .mendix-cache/rules/*/; do
    [ -d "$CATEGORY" ] || continue

    # A fixture directory is a module, as a top-level directory of the export is.
    MODULES=""
    for MODULE in "$CATEGORY"*/; do
        [ -d "$MODULE" ] || continue
        MODULE=${MODULE%/}
        MODULES="$MODULES ${MODULE##*/}"
    done
    [ -n "$MODULES" ] || continue

    {
        echo "content:"
        for MODULE in $MODULES; do
            # Sorted find lists a directory before its contents, which is the
            # order the nesting needs; depth is the slash count.
            (cd "$CATEGORY" && find "$MODULE" -name '.*' -prune -o -print) | LC_ALL=C sort | while read -r REL; do
                DEPTH=0
                REST=$REL
                while [ "$REST" != "${REST#*/}" ]; do
                    REST=${REST#*/}
                    DEPTH=$((DEPTH + 1))
                done

                PAD=""
                WIDTH=0
                while [ "$WIDTH" -lt $((4 + DEPTH * 4)) ]; do
                    PAD="$PAD "
                    WIDTH=$((WIDTH + 1))
                done

                if [ -d "$CATEGORY$REL" ]; then
                    printf '%s- name: %s\n%s  type: directory\n%s  path: %s\n%s  content:\n' \
                        "$PAD" "${REL##*/}" "$PAD" "$PAD" "$REL" "$PAD"
                else
                    printf '%s- name: %s\n%s  type: file\n%s  path: %s\n' \
                        "$PAD" "${REL##*/}" "$PAD" "$PAD" "$REL"
                fi
            done
        done
    } > "${CATEGORY%/}/app.yaml"

    echo "Indexed fixture modules in ${CATEGORY%/}:$MODULES"
done

# capture all output to a file with tee
$MXLINT test-rules 2>&1 | tee /tmp/mxlint-test-rules.log

# grep for FAIL in the log file
if grep -q "FAIL" /tmp/mxlint-test-rules.log; then
    echo "Tests failed"
    exit 1
else
    echo "Tests passed"
    exit 0
fi
