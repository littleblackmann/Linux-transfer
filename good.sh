#!/bin/bash

# 設定來源路徑
SOURCE_PATH=/home/test1/

# 設定臨時解壓縮路徑
TEMP_PATH=/tmp/recovery

# 建立暫存解壓縮目錄
mkdir -p $TEMP_PATH

# 導入資料庫
echo "導入MariaDB資料庫..."
mysql -u root -p < $SOURCE_PATH/all_databases.sql

# 解壓縮用戶家目錄到暫存目錄
echo "解壓縮用戶家目錄..."
tar -xzvf $SOURCE_PATH/user1_home.tar.gz -C $TEMP_PATH

# 解壓縮Apache配置到暫存目錄
echo "解壓縮Apache配置..."
tar -xzvf $SOURCE_PATH/apache_configs.tar.gz -C $TEMP_PATH

# 解壓縮網站資料到暫存目錄
echo "解壓縮網站資料..."
tar -xzvf $SOURCE_PATH/apache_www.tar.gz -C $TEMP_PATH

# 使用rsync同步用戶家目錄
echo "同步使用者家目錄..."
rsync -av $TEMP_PATH/home/black/ /home/test1/

# 同步Apache配置
echo "同步Apache設定..."
rsync -av $TEMP_PATH/etc/apache2/ /etc/apache2/

# 同步網站數據
echo "同步網站資料..."
rsync -av $TEMP_PATH/var/www/html/ /var/www/html/

# 清理暫存目錄
echo "清理暫存目錄..."
rm -rf $TEMP_PATH

echo "恢復完成。"
