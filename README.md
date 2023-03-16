# check-commits
GitHub Action which looks for a pattern in commit messages between two commits. This could be useful to prevent
temporary commits from being merged.

## Inputs

| Option       | Required | Default                       | Description                                 | Notes                         |
|--------------|----------|-------------------------------|---------------------------------------------|-------------------------------|
| base_commit  | false    | origin/${{ github.base_ref }} | Base commit id or ref                       |                               |
| head_commit  | false    | origin/${{ github.head_ref }} | Head commit id or ref                       |                               |
| regex_filter | true     |                               | Regex filter to look for in commit messages | Perl syntax, case-insensitive |

## Usage example

    on:
      pull_request:
        branches:
          - develop

    permissions: {}

    jobs:
      checks:
        runs-on: ubuntu-latest
        timeout-minutes: 5
        steps:
          - name: Checkout Code
            uses: actions/checkout@v3
            with:
              fetch-depth: 0

          - name: Check Commits
            uses: giner/check-commits@v1.0.0
            with:
              regex_filter: '\[(squash|wip|tmp)\]'  # Stop on commits marked with [squash], [wip] or [tmp]

## Example output

Example 1

    INFO:	No commits matching pattern "\[(squash|wip|tmp)\]" found

Example 2

    ERROR:	The following commits match pattern "^wip\b":
    ERROR:	45daf40 WIP
    ERROR:	a133b8a WIP
