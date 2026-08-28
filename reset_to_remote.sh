#!/bin/bash
# 脚本：reset_to_remote.sh
# 用途：舍弃所有本地更改，将本地分支完全同步到远程最新版本。

set -e

CURRENT_BRANCH=$(git branch --show-current)
if [ -z "$CURRENT_BRANCH" ]; then
    echo "错误：不在任何分支上，请先切换到目标分支。"
    exit 1
fi

# 若有未完成的 rebase/merge，先中止
if [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ] || [ -f .git/MERGE_HEAD ]; then
    echo "检测到未完成的 rebase/merge，正在中止..."
    git rebase --abort 2>/dev/null || git merge --abort 2>/dev/null || true
fi

# 获取远程最新
git fetch origin

# 强制重置到远程分支，丢弃所有本地更改和未推送提交
git reset --hard "origin/$CURRENT_BRANCH"

# 清理未跟踪文件（可选，若想完全干净可取消下一行注释）
# git clean -fd

echo "✅ 已同步到远程最新版本，所有本地更改已丢弃。"
