#!/bin/sh
# syncs local directory to remote.

USAGE="$(cat <<EOF
$(basename "$0") -r <remote> -d <sync_dir> [-p <port>] [-l <bw_limit (kBps)>] [-c <rc_file>]

remote:             user@host:~user/path
sync_dir:           Do NOT add tailing slash '/' (means the content of  the dir), or I will remove it.
port:               default to 22
bw_limit (kBps):    number of kB/s. default to 5MB/s
rc_file:            shell script to source for settings


$( <"$0" grep -E '^ *: ' )
EOF
)"
while getopts 'hr:d:p:l:c:' opt; do case "$opt" in
    r)    remote="$OPTARG" ;;
    p)    port="$OPTARG" ;;
    d)    sync_dir="$OPTARG" ;;
    l)    bw_limit="$OPTARG" ;;
    c)    rc="$OPTARG" ;;
    h|*)  echo "$USAGE" >&2; exit 1 ;;
esac done
shift $((OPTIND-1))


: ${rc:=$(pwd)/.rsync.sh.rc}
if [ -e "$rc" ]; then
    2>&1 echo "Sourcing $rc"
    . "$rc"
fi
: ${sync_dir:?'directory to backup'}
: ${remote:?'user@host:~user/path'}
: ${port:=22}
: ${bw_limit:=$((5*1024))}

# trailing slash in rsync means 'the content of', so remove it.
sync_dir="${sync_dir%/}"

(
set -x
done_root="$(dirname "$sync_dir")/DONE"
done_dir="${done_root}/$(basename "$sync_dir")"
mkdir -p "$done_root"
rsync -avz --bwlimit="$bw_limit" -e "ssh -p ${port}" --progress "$sync_dir" "$remote" "$@" &&
mv "$sync_dir" "$done_dir" &&
ln -sf "$done_dir" "$sync_dir"
)
