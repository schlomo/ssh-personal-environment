#!/bin/bash
set -e -E -u
#
# given a remote user@host with ssh-personal-environment installed, determine the maximum amount of random
# data that can be transferred via the environment variables.

TARGET="$1" ; shift

data_file=$(mktemp)
data_filename=${data_file##*/}
data_dirname=${data_file%/*}
trap "rm -f $data_file" 0

unset SSH_PERS_ENV_DEBUG

lastsize=0
for size in $(eval echo {${MIN:=10}..${MAX:=150}..${STEP:=10}}) ; do
	dd if=/dev/urandom bs=1k count="$size" of="$data_file" status=none
	checksum=( $(md5sum "$data_file") )
	
	echo "TESTING $size KB"
	remote_checksum=( $(
		export SSH_PERS_ENV_DATA=$(tar -C "$data_dirname" -cz "$data_filename" | base64)
	       	ssh "$TARGET" md5sum "$data_filename" \; rm -f "$data_filename" 2>/dev/null || echo FAILED
		) ) 
	if [[ $checksum != $remote_checksum ]] ; then
		echo "FAILED to transfer $size KB, safe size is $lastsize KB"
		exit 0
	fi
	let lastsize=size
done
