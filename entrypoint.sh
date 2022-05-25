#!/bin/bash
echo BEGIN LIST OF NVME
nvme list
echo END LIST OF NVME

OUTPUT=$(vgscan 2> /dev/null | grep instancestore)
if [ -z "$OUTPUT" ]
then
    echo "VG does not exist"
    declare -r disks=($(nvme list | grep Instance | cut -f 1 -d ' '))
    if (( ${#disks[@]} )); then
        for i in "${disks[@]}"
        do
            echo "Creating PV $i"
            pvcreate -ff -y $i
        done


        echo "Creating VG=instancestore $disks"
        vgcreate instancestore $disks
    fi
else
    echo "VG exists"
fi

sleep infinity