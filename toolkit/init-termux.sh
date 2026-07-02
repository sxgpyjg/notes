#!/bin/bash
echo "🚀 开始初始化 Termux 环境..."

pkg update -y
pkg install -y git zip unzip curl

cp toolkit/backup-all.sh ~/
cp toolkit/restore-all.sh ~/
cp toolkit/help-all.sh ~/
cp toolkit/git-toolkit.sh ~/
cp toolkit/.zshrc ~/
cp toolkit/.myfuncs.sh ~/ 2>/dev/null

chmod +x ~/backup-all.sh
chmod +x ~/restore-all.sh
chmod +x ~/help-all.sh
chmod +x ~/git-toolkit.sh

source ~/.zshrc

echo "✅ 环境初始化完成！"
echo ""
echo "📖 可用命令："
echo "   备份"
echo "   恢复"
echo "   帮助"
