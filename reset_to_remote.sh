#!/bin/bash
set -e

# 1. 确保在分支上
CURRENT_BRANCH=$(git branch --show-current)
if [ -z "$CURRENT_BRANCH" ]; then
    DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
    git checkout -B "$DEFAULT_BRANCH" "origin/$DEFAULT_BRANCH" 2>/dev/null || git checkout "$DEFAULT_BRANCH"
    CURRENT_BRANCH="$DEFAULT_BRANCH"
fi

# 2. 中止未完成的 rebase/merge
if [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ] || [ -f .git/MERGE_HEAD ]; then
    git rebase --abort 2>/dev/null || git merge --abort 2>/dev/null || true
fi

# 3. 拉取并变基（冲突时采用本地版本）
git pull --rebase --autostash -X ours origin "$CURRENT_BRANCH" || {
    echo "变基失败，强制重置到远程并重新应用本地更改..."
    git rebase --abort 2>/dev/null || true
    git fetch origin
    git reset --hard "origin/$CURRENT_BRANCH"
    git stash pop 2>/dev/null || true
}

# 4. 提交
git add --all
if ! git diff --cached --quiet; then
    git commit -m "Auto commit: $(date)"
fi

# 5. 推送
git push --force-with-lease origin "$CURRENT_BRANCH"
echo "✅ 推送成功！"
