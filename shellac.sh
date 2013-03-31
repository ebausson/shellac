#! /bin/zsh
# /etc/init.d/shellac

### BEGIN INIT INFO
# Provides:          shellac
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

action="start"
if [ $# -gt 0 ]; then
	action=$1
fi

case $action in
	start)
		local tmpdir=$(pwd)
		cd ~/dev/shellac/svc/shellac/
		mkdir $HOME/.shellac 1>/dev/null 2>/dev/null
		historyfile=$HOME/.shellac/history.log
		errorfile=$HOME/.shellac/error.log
		touch $historyfile 2>/dev/null
		touch $errorfile 2>/dev/null
		./run 1>>$historyfile 2>>$errorfile &
		cd $tmpdir
		;;
	stop)
		processline=$(ps aux | grep bin/webapp.py | grep python)
		linecount=$(echo $processline | wc -l)
		if [ $linecount -gt 0 ]; then
			processline=(${(ps: :)${processline}})
			if [ ${#processline[@]} -ge 1 ]; then
				shellacPID=$processline[2]
				kill $shellacPID
			else
				echo "Not running."
			fi
		else
			echo "Not running."
		fi
		unset processline
		unset linelength
		unset shellacPID
		;;
	*)
		echo "Usage: /etc/init.d.shellac {start|stop}"
		exit 1
		;;
esac

exit 0