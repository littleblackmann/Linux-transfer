#!/bin/bash

# 設定test1的使用者名稱和IP位址
DEST_USER=test1            # 輸入B主機名稱
DEST_IP=10.167.223.29      # 輸入B主機的IP
DEST_PATH=/home/test1/     # 輸入B主機要傳送的位置

# 導出所有資料庫
echo "導出所有MariaDB資料庫..."
mysqldump -u black -p[密碼] --all-databases > all_databases.sql    # 輸入A主機的名稱跟密碼

# 打包用戶家目錄
echo "打包用戶家目錄..."
tar -czvf user1_home.tar.gz /home/black    # 更改A主機的名子
# tar -czvf user2_home.tar.gz /home/black2

# 打包Apache配置
echo "打包Apache設定..."
tar -czvf apache_configs.tar.gz /etc/apache2

# 打包網站數據
echo "打包網站資料..."
tar -czvf apache_www.tar.gz /var/www/html

# 使用rsync傳輸
echo "傳輸資料到test1..."

echo "傳輸完成。"
