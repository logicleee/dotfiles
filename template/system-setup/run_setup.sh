#!/bin/bash

THISDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd "$THISDIR"

if [ -e "$HOME/.system-setup" ]
then
    cat <<EOF
==================================================================
WARNING! The ~/.system-setup symlink exists! 
This means setup has run once.

Please remove this link and re-run if desired:
$(ls -l $HOME/.system-setup)

Hostname: $HOSTNAME
==================================================================
EOF
    exit 1
fi

menu_opts=$(ls -d config-*)

printf "===============================================\n"
printf "SELECT A CONFIGURATION PROFILE FOR THIS DEVICE:\n"
printf "===============================================\n\n"

select DIR in ${menu_opts[@]} CANCEL
do
    case $DIR in
        CANCEL)
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

if [ ! -d "$DIR" ] ; then
    echo "Path does not exist: $DIR - EXITING"
    exit 1
fi
ln -s "$THISDIR/$DIR" "$HOME/.system-setup"
cd "$THISDIR/$DIR"
open ../devtools/log_stream_logger.command &
./setup.sh
echo "If run_setup.sh finished prematurely, run this device-specific setup again: ./setup.sh"
