#!/bin/bash

# 列出所有分支
git branch -a

# 創建一個臨時文件來存儲要刪除的分支名稱
temp_file=$(mktemp)

echo "請輸入要刪除的分支名稱，每行一個。完成後輸入 'done' 並按 Enter："

# 讀取用戶輸入
while true; do
    read branch
    if [ "$branch" = "done" ]; then
        break
    fi
    echo "$branch" >> "$temp_file"
done

echo "您選擇刪除以下分支："
cat "$temp_file"
echo "確定要刪除這些分支嗎？(y/n)"
read confirm

if [ "$confirm" = "y" ]; then
    # 刪除本地分支
    while IFS= read -r branch; do
        if [[ $branch != refs/remotes/* ]]; then
            git branch -D "$branch" || echo "無法刪除本地分支: $branch"
        fi
    done < "$temp_file"
else
    echo "操作已取消。"
fi

# 刪除臨時文件
rm "$temp_file"

echo "操作完成。"

