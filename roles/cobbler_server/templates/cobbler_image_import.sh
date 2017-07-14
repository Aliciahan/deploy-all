#!/bin/bash
#:***********************************************
#:Program: cobbler_image_import
#:
#:Author: liyajin
#:
#:History: 2017-05-16
#:
#:Version: 1.0
#:***********************************************
import_iso_image () {
    if [ $5 -eq 1 ]
    then
        exit 0
    else
        if [ ! -f /tmp/$1 ]
        then
            cd /tmp/
            wget $6 &>/dev/null
        fi

        if [ -f /tmp/$1 ]
        then
            mkdir /mnt/$4 -p
            mount /tmp/$1 /mnt/$4
            cobbler import --path=/mnt/$4 --name=$2 --arch=x86_64
            umount /mnt/$4
        fi
    fi

    if [ ! -f /var/lib/cobbler/kickstarts/$3 ]
    then
        cp /tmp/$3 /var/lib/cobbler/kickstarts/$3
        cobbler profile edit --name=$2 --kickstart=/var/lib/cobbler/kickstarts/$3
        cobbler sync
        rm -f /tmp/$3
    fi
}

centos6_5 () {
    cobbler_iso_name=$(echo '{{ cobbler_image_ip_centos6_5 }}' | awk -F '/' '{print $NF}')
    cobbler_profile_name="centos-6.5-x86_64"
    cobbler_ksfile_name="centos-6.5-x86_64.cfg"
    cobbler_mount_name="centos_6.5"
    cobbler_count=$(cobbler distro list|grep "$cobbler_profile_name"|wc -l)
    cobbler_download_address="{{ cobbler_image_ip_centos6_5 }}"
    import_iso_image $cobbler_iso_name $cobbler_profile_name $cobbler_ksfile_name $cobbler_mount_name $cobbler_count $cobbler_download_address    
}

centos7_2 () {
    cobbler_iso_name=$(echo '{{ cobbler_image_ip_centos7_2 }}' | awk -F '/' '{print $NF}')
    cobbler_profile_name="centos-7.2-x86_64"
    cobbler_ksfile_name="centos-7.2-x86_64.cfg"
    cobbler_mount_name="centos_7.2"
    cobbler_count=$(cobbler distro list|grep "$cobbler_profile_name"|wc -l)
    cobbler_download_address="{{ cobbler_image_ip_centos7_2 }}"
    import_iso_image $cobbler_iso_name $cobbler_profile_name $cobbler_ksfile_name $cobbler_mount_name $cobbler_count $cobbler_download_address
}

centos7_3 () {
    cobbler_iso_name=$(echo '{{ cobbler_image_ip_centos7_3 }}' | awk -F '/' '{print $NF}')
    cobbler_profile_name="centos-7.3-x86_64"
    cobbler_ksfile_name="centos-7.3-x86_64.cfg"
    cobbler_mount_name="centos_7.3"
    cobbler_count=$(cobbler distro list|grep "$cobbler_profile_name"|wc -l)
    cobbler_download_address="{{ cobbler_image_ip_centos7_3 }}"
    import_iso_image $cobbler_iso_name $cobbler_profile_name $cobbler_ksfile_name $cobbler_mount_name $cobbler_count $cobbler_download_address
}

case $1 in
    centos6_5)
        centos6_5
    ;;
    centos7_2)
        centos7_2
    ;;
    centos7_3)
        centos7_3
    ;;
esac
