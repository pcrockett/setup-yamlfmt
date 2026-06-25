# setup-yamlfmt action

easy way to install [yamlfmt](https://github.com/google/yamlfmt) in your GitHub Actions
workflows.

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0  # v7.0.0
      - uses: pcrockett/setup-yamlfmt@4f68eace6cc92df3cc768a8c3a63a230cc29a3c2 # v0.1.0
```

if you don't want to use the default version of yamlfmt that comes with this action, you
can specify your own version and checksum:

```yaml
- uses: pcrockett/setup-yamlfmt@4f68eace6cc92df3cc768a8c3a63a230cc29a3c2 # v0.1.0
  with:
    version: '0.21.0'
    checksum: '1f300d9257b232bb3b541d7fb1b0e6b3c121bcbab381c86cd38cb8722be8a566'
```

**recommended:** run [pinact](https://github.com/suzuki-shunsuke/pinact) to pin your
actions to a specific release. don't worry, if you're using Dependabot, Renovate, etc.,
they will update your pins correctly for you.

```bash
pinact run --update
```
