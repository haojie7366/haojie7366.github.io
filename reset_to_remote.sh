#!/bin/bash
# 脚本：reset_to_remote.sh
# 用途：强制舍弃所有本地更改（包括未跟踪文件），将本地分支完全同步到远程最新版本。

set -e

# 1. 强制丢弃所有本地修改和未跟踪文件（注意：这会永久删除未提交的内容）
echo "正在清空本地所有更改（包括未跟踪文件）..."
git reset --hard HEAD
git clean -fd   # 删除所有未跟踪的文件和目录

# 2. 获取远程最新
git fetch origin

# 3. 确定目标分支：优先使用当前分支名，若不在分支上则使用远程默认分支
CURRENT_BRANCH=$(git branch --show-current)
if [ -z "$CURRENT_BRANCH" ]; then
    # 不在任何分支 -> 从远程默认分支检出
    DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
    if [ -z "$DEFAULT_BRANCH" ]; then
        echo "错误：无法获取远程默认分支。"
        exit 1
    fi
    echo "当前处于 detached HEAD，切换到远程默认分支 $DEFAULT_BRANCH"
    git checkout -B "$DEFAULT_BRANCH" "origin/$DEFAULT_BRANCH"
    CURRENT_BRANCH="$DEFAULT_BRANCH"
else
    # 已在一个分支上，直接重置到远程对应分支
    echo "当前分支：$CURRENT_BRANCH，重置到远程最新..."
    git reset --hard "origin/$CURRENT_BRANCH"
fi

# 4. 同步完成
echo "✅ 已同步到远程最新版本（分支：$CURRENT_BRANCH），所有本地更改已丢弃。"
