  GNU nano 4.8                      check_ngnix.sh                       Modified  ONLINE_LOG="/home/paulom/online.log"
OFFLINE_LOG="/home/paulom/offline.log"

if system is-active --quiet nginx; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Ngix está online" >> $ONLINE_LOG
else
        echo "$(date '+%Y-%m-%d %H:%M:$S') - Ngix está offline" >> $OFFLINE_LOG
fi

