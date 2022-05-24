#!/bin/bash
set -eu
echo ##BEGIN LIST OF NVME
nvme list
echo ##END LIST OF NVME

vgscan | grep VGInstance
status=$?
[ $status -eq 1 ] && echo "VG exists" || echo "VG does not exist"
[ $status -eq 1 ] exit 0
declare -r disks=($(nvme list | grep Instance | cut -f 1 -d ' '))
if (( ${#disks[@]} )); then
    for i in "${disks[@]}"
    do
        echo "Creating PV $i"
        pvcreate -ff -y $i
    done


    echo "Creating VG=VGInstance $disks"
    vgcreate VGInstance $disks
fi