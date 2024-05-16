# Linux資料轉移
> * 創作起始日：2024/04/01
> * 最後更新日：2024/04/01
> * 使用系統：Ubuntu22.04.4_Desktop
> * 創作者：小黑
---

#### [Linux 檔案與目錄管理參考網站](https://linux.vbird.org/linux_basic/centos7/0220filemanager.php)

#### [檔案與檔案系統的壓縮參考網站](http://old.linux.vbird.org/linux_basic/0240tarcompress.php)

#### [Linux Shell Scripts參考網站](https://linux.vbird.org/linux_basic/centos7/0340bashshell-scripts.php)

---

### A Linux 跟 B Linux 都先安裝
`sudo apt update`
`sudo apt install mariadb-server apache2`

### 啟動apache2
`sudo systemctl start apache2`
`sudo systemctl enable apache2`

### B主機安裝
`sudo apt update`
#安裝server
`sudo apt install openssh-server` 
#啟動ssh
`sudo systemctl start ssh`        
#確認有沒有開啟
`sudo ss -tuln | grep :22`        


---

# A Linux東西打包指令
### nano test1.sh
### chmod +x test1.sh
```
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
```
![black](https://hackmd.io/_uploads/HJdzZiDk0.png)

---
# B Linux解壓打包傳輸過來指令，解壓檔案到家目錄
### nano good.sh
### chmod +x good.sh

```
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
```
![test2](https://hackmd.io/_uploads/SkNGjoDJR.png)

















