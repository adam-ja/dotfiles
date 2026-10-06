#!/usr/bin/env bash
# Claude Code WorktreeRemove hook: removes a clean, registered git worktree, then its
# branch if fully merged. Dirty worktrees and unmerged branches are left in place.
set -euo pipefail

input=$(cat)
path=$(jq -r '.worktree_path // empty' <<<"$input")
cwd=$(jq -r '.cwd // empty' <<<"$input")

if [[ -z "$path" ]]; then
  echo "worktree-remove: no worktree_path in hook input" >&2
  exit 1
fi

if [[ ! -d "$path" ]]; then
  exit 0
fi

path=$(realpath "$path")
repo_root=$(dirname "$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir)")

if [[ "$path" == "$repo_root" ]]; then
  echo "worktree-remove: refusing to remove the main checkout $repo_root" >&2
  exit 1
fi

worktrees=$(git -C "$repo_root" worktree list --porcelain)
if ! grep -qxF "worktree $path" <<<"$worktrees"; then
  echo "worktree-remove: $path is not a worktree of $repo_root, leaving it in place" >&2
  exit 1
fi

branch=$(git -C "$path" symbolic-ref --quiet --short HEAD || true)

# No --force: git refuses when the worktree has modified or untracked files.
git -C "$repo_root" worktree remove "$path" >&2

if [[ -n "$branch" ]]; then
  git -C "$repo_root" branch -d "$branch" >&2 || echo "worktree-remove: kept unmerged branch $branch" >&2
fi
