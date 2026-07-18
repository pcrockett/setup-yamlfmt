[private]
_default:
    @just --list

# Run pre-commit on all files
lint:
    pre-commit run --all --show-diff-on-failure --color always

# Generate draft GitHub release
release:
    gh release create --generate-notes --draft

# Update default version and checksum to latest GitHub release
update:
    #!/usr/bin/env bash
    set -euo pipefail
    repo=google/yamlfmt
    echo "getting latest release..."
    latest_tag="$(
        gh release list --exclude-drafts --exclude-pre-releases \
            --repo "${repo}" \
            --json tagName,isLatest \
            --jq '.[] | select(.isLatest).tagName'
    )"
    version="$(echo "${latest_tag}" | cut --characters 2-)"
    checksum="$(
        gh release view \
            "${latest_tag}" \
            --repo "${repo}" \
            --json assets \
            --jq ".assets.[] | select(.name == \"yamlfmt_${version}_Linux_x86_64.tar.gz\").digest"
    )"
    checksum="$(echo "${checksum}" | awk -F: '$1 == "sha256" { printf($2) }')"

    if [ "${checksum}" == "" ]; then
        echo "unable to determine checksum for ${artifact_name} at ${latest_tag}"
        exit 1
    fi

    temp_dir="$(mktemp --directory)"
    cleanup() {
        rm -rf "${temp_dir}"
    }
    trap 'cleanup' EXIT ERR

    awk -f update.awk \
        VERSION="${version}" \
        CHECKSUM="${checksum}" \
        <action.yml \
        >"${temp_dir}/action.yml"
    mv "${temp_dir}/action.yml" .

    git diff action.yml

# Update this repo from its copier template
update-template:
    copier update --skip-answered
