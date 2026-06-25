[private]
_default:
    @just --list

# Run pre-commit on all files
lint:
    pre-commit run --all --show-diff-on-failure --color always

# Generate draft GitHub release
release:
    gh release create --generate-notes --draft
