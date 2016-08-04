#!/bin/bash

SSH_USER="test"
SSH_SERVER="example.com"
SSH_KEY="/home/test/id_rsa"

container_exists() {
	local container_name="$1"
	docker ps -a | awk '$NF=="'"${container_name}"'"{found=1} END{if(!found){exit 1}}'
}

set -e

xhost +local:

if ! container_exists storage ; then
	docker run --name storage devurandom/storage
fi

declare -a dri_devices
for d in `find /dev/dri -type c` ; do
	dri_devices+=(--device "${d}")
done

nohup docker run --rm --name="proxychains-firefox" --volumes-from storage --volume ${SSH_KEY}:/id_rsa --env SOCKS_SERVER="socks://172.17.0.1:5080" --env SOCKS_VERSION=5 --env DISPLAY="${DISPLAY}" --volume /tmp/.X11-unix:/tmp/.X11-unix --env PULSE_SERVER="unix:/tmp/pulse-unix" --volume /run/user/"${UID}"/pulse/native:/tmp/pulse-unix "${dri_devices[@]}" --volume /etc/localtime:/etc/localtime:ro --volume /etc/timezone:/etc/timezone:ro liftedkilt/proxychains-firefox:latest "$@" >/dev/null 2>&1 &
while [[ ! $(docker ps | grep proxychains-firefox) ]]; do
	sleep 1
done
docker exec -d proxychains-firefox nohup ssh -TND 12345 ${SSH_USER}@${SSH_SERVER} -i /id_rsa
