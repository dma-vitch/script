#!/bin/bash
### BEGIN INIT INFO
# Provides:
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

work_dir=""
cmd=""
user=""

name=$(basename "$0")
pid_file="/var/run/$name.pid"
stdout_log="/var/log/$name.log"
stderr_log="/var/log/$name.err"

get_pid() {
    cat "$pid_file"
}

is_running() {
    [ -f "$pid_file" ] && ps $(get_pid) > /dev/null 2>&1
}

del_pidfile() {
	[ -f "$pid_file" ] && rm -f ${pid_file} > /dev/null 2>&1
}

mk_dir() {
for dir in $(dirname ${pid_file}) $(dirname ${stdout_log}) $(dirname ${stderr_log})
        do
            mkdir -p $dir
            chown -R "$user" $dir
        done
}

check_privilege() {
  if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or with sudo"
	exit 1
  fi
}

# For SELinux we need to use 'runuser' not 'su' or sudo
#if [ -x "/sbin/runuser" ]; then
#    SU="/sbin/runuser"
#else
#    SU="/bin/su"
#fi

status(){
        printf "%-50s\n" "Checking $name..."
        #if is_running; then
		if [ -f "$pid_file" ]; then
            printf "%s\n" "Checking running $name with pid = $(get_pid)"
			if [ -z "`ps axf | grep ${name} | grep -v grep`" ]; then
                printf "%s\n" "Process dead but pidfile exists"
            else
                echo "Running"
            fi
        else
            printf "%s\n" "Service not running"
        fi
}

# Check that the user exists (if we set a user)
# Does the user exist?
if [ -n "$user" ] ; then
    if getent passwd | grep -q "^$user:"; then
        # Obtain the uid and gid
        DAEMONUID=$(getent passwd |grep "^$user:" | awk -F : '{print $3}')
        DAEMONGID=$(getent passwd |grep "^$user:" | awk -F : '{print $4}')
    else
        echo "The user $user, required to run $name does not exist."
        exit 1
    fi
fi

# Script needs to be run as root
check_privilege

case "$1" in
    start)
    if is_running; then
        echo "Already started"
    else
        echo "Starting $name"
        #create not existing directory
        mk_dir
		cd "$work_dir"
        #remove pidfile if not stoped correctly
        del_pidfile
        if [ -z "$user" ]; then
            sudo $cmd >> "$stdout_log" 2>> "$stderr_log" &
        else
            sudo -u "$user" $cmd >> "$stdout_log" 2>> "$stderr_log" &
        fi
        echo $! > "$pid_file"
        if ! is_running; then
            echo "Unable to start, see $stdout_log and $stderr_log"
            exit 1
        fi
    fi
    ;;
    stop)
    if is_running; then
        echo -n "Stopping $name.."
        kill $(get_pid)
        for i in {1..10}
        do
            if ! is_running; then
                break
            fi

            echo -n "."
            sleep 1
        done
        echo

        if is_running; then
            echo "Not stopped; may still be shutting down or shutdown may have failed"
            exit 1
        else
            echo "Stopped"
            if [ -f "$pid_file" ]; then
                rm "$pid_file"
            fi
        fi
    else
        echo "Not running"
    fi
    ;;
    restart)
    $0 stop
    if is_running; then
        echo "Unable to stop, will not attempt to start"
        exit 1
    fi
    $0 start
    ;;
    status)
       status
    fi
    ;;
    *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac

exit 0