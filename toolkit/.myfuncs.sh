# ~/.myfuncs.sh

# ===== yjg 写文章 =====
yjg() {
  cd ~/gitdemo || {
    echo "❌ 找不到 ~/gitdemo 目录"
    return 1
  }

  DATE=$(date '+%Y-%m-%d')
  FILE="_posts/${DATE}-$1.md"

  cat > "$FILE" <<'EOL'
---
layout: post
title: "TITLE_PLACEHOLDER"
date: DATE_PLACEHOLDER
categories: 拾光 随笔 时光存档
tags: 风正扬
---

CURSOR_HERE
EOL

  sed -i "s|TITLE_PLACEHOLDER|$1|g" "$FILE"
  sed -i "s|DATE_PLACEHOLDER|$(date '+%Y-%m-%d %H:%M:%S %:z')|g" "$FILE"
  sed -i '/^CURSOR_HERE$/d' "$FILE"

  ${EDITOR:-nano} "$FILE"
  bc "$1"
}

# ===== bc 提交 =====
bc() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ 当前目录不是 Git 仓库"
    return 1
  fi

  local BRANCH
  BRANCH=$(git branch --show-current)

  git add -A

  if git diff --cached --quiet; then
    echo "ℹ️  [$BRANCH] 没有新变动，尝试仅推送..."
    if git push origin "$BRANCH" >/dev/null 2>&1; then
      echo "✅ [$BRANCH] 推送成功（无新提交）"
    else
      echo "✅ [$BRANCH] 已是最新，无需推送"
    fi
    return 0
  fi

  echo "📝 [$BRANCH] 检测到变更，准备提交..."
  git commit -m "add ${1:-update} $(date '+%Y-%m-%d %H:%M')" || {
    echo "❌ [$BRANCH] 提交失败"
    return 1
  }

  if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
    git push || echo "❌ [$BRANCH] 推送失败"
  else
    git push --set-upstream origin "$BRANCH" || echo "❌ [$BRANCH] 首次推送失败"
  fi

  echo "🎉 [$BRANCH] 完成（仍在 $(pwd)）"
}

# ===== rst 一键恢复环境 =====
rst() {
  echo "🚀 一键恢复环境"

  if [ ! -d "$HOME/gitdemo" ]; then
    echo "❌ ~/gitdemo 不存在，请先执行："
    echo "   git clone git@github.com:sxgpyjg/sxgpyjg.github.io.git gitdemo"
    return 1
  fi

  cd ~/gitdemo || return 1
  ./config/termux/restore.sh
}

