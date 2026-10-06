#!/usr/bin/env bash
# Claude Code WorktreeCreate hook: creates git worktrees at ~/worktrees/<repo>/<name>
# instead of <repo>/.claude/worktrees/<name>. Stdout must be only the worktree path.
set -euo pipefail

WORKTREE_ROOT="$HOME/worktrees"
BRANCH_PREFIX="claude/"

input=$(cat)
name=$(jq -r '.worktree_name // empty' <<<"$input")
base_ref=$(jq -r '.base_ref // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")

if [[ ! "$name" =~ ^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$ || "$name" == *..* ]]; then
  echo "worktree-create: invalid worktree name '$name'" >&2
  exit 1
fi

repo_root=$(dirname "$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir)")
path="$WORKTREE_ROOT/$(basename "$repo_root")/$name"
branch="$BRANCH_PREFIX$name"

if [[ -e "$path" ]]; then
  worktrees=$(git -C "$repo_root" worktree list --porcelain)
  if grep -qxF "worktree $path" <<<"$worktrees"; then
    echo "$path"
    exit 0
  fi
  echo "worktree-create: $path exists but is not a worktree of $repo_root" >&2
  exit 1
fi

mkdir -p "$(dirname "$path")"

if git -C "$repo_root" show-ref --verify --quiet "refs/heads/$branch"; then
  git -C "$repo_root" worktree add "$path" "$branch" >&2
else
  git -C "$repo_root" worktree add -b "$branch" "$path" "${base_ref:-HEAD}" >&2
fi

echo "$path"
