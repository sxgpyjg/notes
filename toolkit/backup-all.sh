#!/bin/bash
TIME_TAG=$(date '+%Y%m%d_%H%M')
echo "📦 开始备份..."
echo "⏰ 开始时间：$(date '+%Y-%m-%d %H:%M')"
echo ""

# ① 图文笔记库
zip -r /sdcard/图文笔记_${TIME_TAG}.zip ~/storage/shared/notes -x "*/.git/*" -x "*.swp"
echo "✅ ① 图文笔记备份完成"

# ② 图文相册库
zip -r /sdcard/图文相册_${TIME_TAG}.zip ~/gitdemo/blog -x "*/.git/*" -x "*.swp"
echo "✅ ② 图文相册备份完成"

# ③ 主博客主页库
zip -r /sdcard/主博客主页_${TIME_TAG}.zip ~/gitdemo -x "*/blog/*" -x "*/.git/*" -x "*.swp"
echo "✅ ③ 主博客主页备份完成"

echo ""
echo "🧹 清理 7 天前的旧备份..."
find /sdcard/ -maxdepth 1 -name "图文笔记_*.zip" -mtime +7 -delete 2>/dev/null
find /sdcard/ -maxdepth 1 -name "图文相册_*.zip" -mtime +7 -delete 2>/dev/null
find /sdcard/ -maxdepth 1 -name "主博客主页_*.zip" -mtime +7 -delete 2>/dev/null
echo "✅ 清理完成"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━"
echo "🎉 全部备份完成！"
echo "⏰ 完成时间：$(date '+%Y-%m-%d %H:%M')"
echo "📍 备份位置：手机内部存储 /sdcard/"
echo ""
echo "📦 本次备份文件："
ls -lh /sdcard/*_${TIME_TAG}.zip 2>/dev/null
echo "━━━━━━━━━━━━━━━━━━━━"

