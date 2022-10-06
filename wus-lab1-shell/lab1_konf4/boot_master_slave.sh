#!/bin/sh

### BEGIN INIT INFO
# Provides:       scriptname
# Required-Start: $remote_fs $syslog
# Required-Stop:  $remote_fs $syslog
# Default-Start:  2 3 4 5
# Default-Stop:   0 1 6
# Short-Description: Start daemon at boot time
# Description:    Enable service provided by daemon.
### END INIT INFO
 
bindir=/usr/bin
 
if test -x $bindir/mysqld_multi
then
    mysqld_multi="$bindir/mysqld_multi";
else
    echo "Can't execute $bindir/mysqld_multi";
    exit;
fi
 
case "$1" in
    'start' )
     "$mysqld_multi" start $2
     ;;
    'stop' )
     "$mysqld_multi" stop $2
     ;;
    'report' )
     "$mysqld_multi" report $2
     ;;
    'restart' )
     "$mysqld_multi" stop $2
     "$mysqld_multi" start $2
     ;;
    *)
     echo "Usage: $0 {start|stop|report|restart}" >&2
     ;;
esac