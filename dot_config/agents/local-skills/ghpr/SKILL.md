---
name: ghpr
description: GitHub Pull Request creation workflow for OSS contributions. Creates well-structured PRs with issue references, conventional prefixes, and proper descriptions. Use when the user wants to create a PR, send changes upstream, or submit a contribution.
---

# GitHub Pull Request Workflow

Create a Pull Request for the current branch.

## Title

- Concise English title, one line
- Apply the same prefix convention as commit messages (e.g., feat:, fix:, docs:)

## Description

- Include a summary of changes, motivation or context, and how it was tested
- Reference related issues with `Fixes #N` or `Closes #N` when applicable
- If the repository has a PR template (`.github/PULL_REQUEST_TEMPLATE.md` or `.github/PULL_REQUEST_TEMPLATE/`), follow its structure
- If `CONTRIBUTING.md` or `DEVELOPMENT.md` exists, review them and ensure the PR follows the project's conventions

## Workflow

1. Check whether the branch has been pushed to the remote
   - If not, prompt the user to push — never push on your own
2. Check for a PR template and use it if present
3. Review `CONTRIBUTING.md` and `DEVELOPMENT.md` if they exist
4. Draft the title and description, then **show the proposal to the user for confirmation**
5. After approval, run `gh pr create --title $TITLE --body $BODY`
