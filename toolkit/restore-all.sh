#!/bin/bash

echo "📂 可用备份列表："
echo "━━━━━━━━━━━━━━━━━━━━"
ls -lh /sdcard/图文笔记_*.zip /sdcard/图文相册_*.zip /sdcard/主博客主页_*.zip 2>/dev/null | sed 's|/sdcard/||'
echo "━━━━━━━━━━━━━━━━━━━━"
echo ""

read -p "📝 请输入要恢复的备份时间标识（如 20260629_0909）：" RESTORE_TAG

if [ -z "$RESTORE_TAG" ]; then
    echo "❌ 未输入时间标识，已取消。"
    exit 1
fi

NOTE_ZIP="/sdcard/图文笔记_${RESTORE_TAG}.zip"
BLOG_ZIP="/sdcard/图文相册_${RESTORE_TAG}.zip"
HOME_ZIP="/sdcard/主博客主页_${RESTORE_TAG}.zip"

if [ ! -f "$NOTE_ZIP" ] && [ ! -f "$BLOG_ZIP" ] && [ ! -f "$HOME_ZIP" ]; then
    echo "❌ 未找到任何与时间 [$RESTORE_TAG] 匹配的备份文件，已取消。"
    exit 1
fi

echo ""
echo "⚠️ 恢复操作将覆盖当前数据！"
read -p "是否先备份当前数据？(Y/n): " CONFIRM

if [[ "$CONFIRM" != "n" && "$CONFIRM" != "N" ]]; then
    echo "📦 正在备份当前数据..."
    bash ~/backup-all.sh
fi

echo ""
echo "🔄 开始恢复 [$RESTORE_TAG]..."

if [ -f "$NOTE_ZIP" ]; then
    rm -rf ~/storage/shared/notes/*
    unzip -o "$NOTE_ZIP" -d ~/storage/shared/
    echo "✅ 图文笔记恢复完成"
else
    echo "⚠️ 跳过图文笔记（未找到对应备份）"
fi

if [ -f "$BLOG_ZIP" ]; then
    rm -rf ~/gitdemo/blog/*
    unzip -o "$BLOG_ZIP" -d ~/gitdemo/
    echo "✅ 图文相册恢复完成"
else
    echo "⚠️ 跳过图文相册（未找到对应备份）"
fi

if [ -f "$HOME_ZIP" ]; then
    find ~/gitdemo -maxdepth 1 -type f -delete
    unzip -o "$HOME_ZIP" -d ~/
    echo "✅ 主博客主页恢复完成"
else
    echo "⚠️ 跳过主博客主页（未找到对应备份）"
fi

echo ""
echo "🎉 恢复完成！"
echo "⏰ 时间：$(date '+%Y-%m-%d %H:%M')"
echo "━━━━━━━━━━━━━━━━━━━━"
