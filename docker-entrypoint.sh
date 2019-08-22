#!/bin/bash
set -x
echo "${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY}" > /etc/passwd-s3fs  
chmod 0400 /etc/passwd-s3fs
s3fs $S3_BUCKET $MNT_POINT -f -o url=${S3_ENDPOINT},allow_other,use_cache=/tmp,max_stat_cache_size=1000,stat_cache_expire=900,retries=5,connect_timeout=10${S3_EXTRAVARS} &
sleep 5
ls -al /mnt

DATA="Hello Hello_again and_again_Hello And_hello_now_agian Sometimesisno ttonotbutcheck howwhatandso"
for D in $DATA
do
    DATE=$(date +%y-%m-%d)
    TIME=$(date +%H:%M:%S)
    echo "$TIME and some data to backet. $D" > "/mnt/$DATE-$TIME.txt"
    sleep 1
done
sleep 5
#find ${MNT_POINT} -type f -mtime ${ROTATION_DAY_PERIOD} -exec rm -f {} \;
find ${MNT_POINT} -type f -mmin ${ROTATION_MIN_PERIOD} -exec rm -f {} \;
ls -al /mnt
umount /mnt
