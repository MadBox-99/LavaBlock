#!/bin/bash
# Put the chain viewer on GitHub Pages.
#
# GitHub shows a repository's HTML as source, not as a page, so the only way
# to hand someone a link they can click is Pages. This pushes the
# self-contained viewer to an orphan `gh-pages` branch as index.html, through
# a temporary worktree, so `main` is never touched and the branch carries one
# file and no history of the mod.
#
#   python tools/chain/build.py <dump> --vanilla <vanilla-dump> --single
#   bash tools/chain/publish.sh
#
# The first run also has to be switched on in the repository: Settings ->
# Pages -> Source: "Deploy from a branch" -> Branch: gh-pages, folder / (root).
# Pages is free on public repositories; on a private one it needs a paid plan.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$HERE/../.." && pwd)"
PAGE="$HERE/chain.html"
BRANCH="gh-pages"
WORK="$(mktemp -d)"

if [ ! -f "$PAGE" ]; then
  echo "no $PAGE - run build.py with --single first" >&2
  exit 1
fi

cd "$REPO"
git fetch origin "$BRANCH" --quiet 2>/dev/null || true

if git show-ref --verify --quiet "refs/remotes/origin/$BRANCH"; then
  git worktree add --quiet "$WORK" -B "$BRANCH" "origin/$BRANCH"
else
  # Orphan, so the branch never carries the mod's own history - it holds one
  # generated file and nothing else.
  git worktree add --quiet --detach "$WORK"
  git -C "$WORK" checkout --quiet --orphan "$BRANCH"
  git -C "$WORK" rm -rqf . 2>/dev/null || true
fi

cp "$PAGE" "$WORK/index.html"
touch "$WORK/.nojekyll"          # serve the file as it is, no Jekyll pass

cd "$WORK"
git add -A
if git diff --cached --quiet; then
  echo "nothing changed - the published page is already current"
else
  git commit --quiet -m "Publish production chain viewer"
  git push --quiet -u origin "$BRANCH"
  echo "pushed to $BRANCH"
fi

cd "$REPO"
git worktree remove --force "$WORK"

URL="$(git remote get-url origin \
  | sed -E 's#(git@github\.com:|https://github\.com/)##; s#\.git$##')"
USER_NAME="${URL%%/*}"
REPO_NAME="${URL##*/}"
echo "https://$(echo "$USER_NAME" | tr 'A-Z' 'a-z').github.io/$REPO_NAME/"
