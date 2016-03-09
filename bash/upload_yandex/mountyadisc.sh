#!/bin/sh

# apt-get install davfs2
# echo "/mnt/yandex.disk username \"password\"" > /etc/davfs2/secrets
# chmod 0600 /etc/davfs2/secrets
# echo "y" > /etc/davfs2/dav.inp
# chmod 0700 /etc/init.d/yadisc

start() {
    mount.davfs https://webdav.yandex.ru /mnt/yandex.disk -o rw < /etc/davfs2/dav.inp    
}
    
stop() {
    umount.davfs /mnt/yandex.disk
}
    
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
		sleep 1
        start
    ;;
    *)
    echo "Usage: $0 {start|stop|restart}"
    ;;
esac

exit 0