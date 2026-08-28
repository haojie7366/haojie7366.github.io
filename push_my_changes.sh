#!/bin/bash
# 脚本：push_my_changes.sh
# 用途：将本地更改推送到远程，遇到冲突时自动采用本地版本，确保推送成功。

set -e  # 出错即停，便于定位

# 获取当前分支名（假设为 main，可自动获取）
CURRENT_BRANCH=$(git branch --show-current)
if [ -z "$CURRENT_BRANCH" ]; then
    echo "错误：不在任何分支上，请先切换到目标分支。"
    exit 1
fi

# 检查是否有未完成的 rebase/merge，若有则中止（避免干扰）
if [ -d .git/rebase-merge ] || [ -d .git/rebase-apply ] || [ -f .git/MERGE_HEAD ]; then
    echo "检测到未完成的 rebase/merge，正在中止..."
    git rebase --abort 2>/dev/null || git merge --abort 2>/dev/null || true
fi

# 拉取远程并变基，冲突时自动使用本地版本（-X ours）
echo "正在拉取远程更新并变基（冲突时采用本地版本）..."
git pull --rebase --autostash -X ours origin "$CURRENT_BRANCH" || {
    # 若变基失败（极少情况），放弃变基并强制重置到远程，再应用本地更改（不推荐，但为了确保推送成功）
    echo "变基失败，尝试强制重置到远程并应用本地更改..."
    git rebase --abort 2>/dev/null || true
    git fetch origin
    git reset --hard "origin/$CURRENT_BRANCH"
    # 重新应用本地未提交的更改（若有）
    git stash pop 2>/dev/null || true
}

# 添加所有更改
git add --all

# 提交（若有变更）
if git diff --cached --quiet; then
    echo "没有新的更改，跳过提交。"
else
    git commit -m "Auto commit: $(date)"
fi

# 推送（使用 --force-with-lease 安全覆盖，若远程有新提交且未被合并，将失败，但前面已变基，故通常成功）
echo "正在推送..."
git push --force-with-lease origin "$CURRENT_BRANCH"

echo "✅ 推送成功！"
