#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: ssh-idempotent-copy [[user@]host1:]dir1 ... [[user@]host2:]dir2 progress_db"
    exit 2
fi

IFS=':' read -r -a array_1 <<< "$1"
IFS=':' read -r -a array_2 <<< "$2"

host1="${array_1[0]}"
dir1="${array_1[1]}"
if [ -z "$dir1" ]; then
	dir1=$host1
	host1=
fi

host2="${array_2[0]}"
dir2="${array_2[1]}"
if [ -z "$dir2" ]; then
	dir2=$host2
	host2=
fi

IN=$dir1                                         # input directory
OUT=$dir2                                       # output directory

IN_LS="ls $IN"                                    # input directory ls command
IP="../idempotent.py progress.db"                 # [optional] idempotent filter

if [ -n "$host1" ]; then
	IN_RSH="ssh $host1"
fi
if [ -n "$host2" ]; then
	OUT_RSH="ssh $host2"
fi

IN_RSH=${IN_RSH:-eval}
OUT_RSH=${OUT_RSH:-eval}

COUNT=$($IN_RSH "$IN_LS" | $IP | wc -l)         # [optional] count number of files to copy to show progress with pv
$IN_RSH "$IN_LS" \
| $IP \
| pv --line-mode --size $COUNT \
| $IN_RSH "tar -zc -C $IN -T - 2>/dev/null" \
| ($OUT_RSH "tar -C $OUT -xzvf - 2>&1" \
  | sed "s/^x //" \
  | $IP --save true 1>/dev/null
  )
