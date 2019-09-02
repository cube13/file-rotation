#!/bin/bash
#set -x
echo "${AWS_ACCESS_KEY_ID}:${AWS_SECRET_ACCESS_KEY}" > /etc/passwd-s3fs  
chmod 0400 /etc/passwd-s3fs
s3fs $S3_BUCKET $MNT_POINT -f -o url=${S3_ENDPOINT},allow_other,use_cache=/tmp,max_stat_cache_size=1000,stat_cache_expire=900,retries=5,connect_timeout=10${S3_EXTRAVARS} &
sleep 5
COUNT_BEFORE=$(find ${MNT_POINT} -type f)
SIZE_BEFORE=$(du ${MNT_POINT} -hs)
echo "$COUNT_BEFORE files with sum size $SIZE_BEFORE before rotatation"
START=$(date +%s) 
find ${MNT_POINT} -type f -mtime ${ROTATION_DAY_PERIOD} -exec rm -f {} \;
END=$(date +%s)
ROTATION_TIME=$(($end - $start))

COUNT_AFTER=$(find ${MNT_POINT} -type f)
SIZE_AFTER=$(du ${MNT_POINT} -hs)
echo "Execution time: $ROTATION_TIME sec"
echo "$COUNT_AFTER files with sum size $SIZE_AFTER after rotatation" 

umount ${MNT_POINT}
