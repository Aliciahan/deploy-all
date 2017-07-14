#!/bin/bash
#:***********************************************
#:Program: check_vars_config
#:
#:Author: liyajin
#:
#:History: 2017-06-01
#:
#:Version: 1.0
#:***********************************************
declare -A HOSTVAR
ANSIBLE_PATH='.'

check_fun () {
    key=($1)
    val=($2)
    for ((i=0; i<=$3; i++))
    do
        key_var=${key[$i]}
        val_var=${val[$i]}
        cat $4 | grep -v "#" | grep $val_var &> /dev/null
        if [ $? -eq 0 ];then
            cat $5 | grep -v "#" | grep $key_var: &> /dev/null
            if [ $? -ne 0 ];then
                echo -e "\033[31mError: You need to define variable '$key_var' in file $4 !\033[0m"
            fi
        fi
    done
}

role_system_init () {
    HOSTVAR=([yum_repo_host]='copy_base_repo.yml' \
    [manager_ssh_pubkey]='add_ssh_pubkey.yml' \
    [ntp_server_host]='chrony_install_and_config.yml' \
    [ntp_server_host]='ntp_install_and_config.yml' \
    [dns_server_host]='dns_config.yml')
    TACK_PATH="$ANSIBLE_PATH/roles/system_init/tasks/main.yml"
    VARS_PATH="$ANSIBLE_PATH/group_vars/all"
    check_fun "${!HOSTVAR[*]}" "${HOSTVAR[*]}" "${#HOSTVAR[@]}" $TACK_PATH $VARS_PATH
}

role_zabbix_server () {
    HOSTVAR=([ListenPort]='zabbix_server_config.yml' \
    [iptables_accept_port]='zabbix_server_iptables.yml' \
    [LogFile]='zabbix_server_config.yml' \
    [LogFileSize]='zabbix_server_config.yml' \
    [DBHost]='zabbix_server_db.yml' \
    [DBName]='zabbix_server_db.yml' \
    [DBUser]='zabbix_server_db.yml' \
    [DBPassword]='zabbix_server_db.yml' \
    [AlertScriptsPath]='zabbix_server_config.yml' \
    [CacheSize]='zabbix_server_config.yml')
    TACK_PATH="$ANSIBLE_PATH/roles/zabbix_server/tasks/main.yml"
    VARS_PATH="$ANSIBLE_PATH/roles/zabbix_server/vars/main.yml"
    check_fun "${!HOSTVAR[*]}" "${HOSTVAR[*]}" "${#HOSTVAR[@]}" $TACK_PATH $VARS_PATH
}

role_zabbix_agent () {
    HOSTVAR=([zabbix_server_ip]='zabbix_agent_config.yml' \
    [LogFile]='zabbix_agent_config.yml' \
    [ListenPort]='zabbix_agent_config.yml' \
    [iptables_accept_port]='zabbix_agent_iptables.yml')
    TACK_PATH="$ANSIBLE_PATH/roles/zabbix_agent/tasks/main.yml"
    VARS_PATH="$ANSIBLE_PATH/roles/zabbix_agent/vars/main.yml"
    check_fun "${!HOSTVAR[*]}" "${HOSTVAR[*]}" "${#HOSTVAR[@]}" $TACK_PATH $VARS_PATH
}

role_cobbler_server () {
    HOSTVAR=([cobbler_iptables_accept_tcp_port]='install_config_cobbler_server.yml' \
    [cobbler_iptables_accept_udp_port]='install_config_cobbler_server.yml' \
    [cobber_server_host]='install_config_cobbler_server.yml' \
    [dhcp_network]='install_config_cobbler_server.yml' \
    [dhcp_netmask]='install_config_cobbler_server.yml' \
    [dhcp_gateway]='install_config_cobbler_server.yml' \
    [dhcp_start_ip]='install_config_cobbler_server.yml' \
    [dhcp_stop_ip]='install_config_cobbler_server.yml' \
    [dns_server_host]='install_config_cobbler_server.yml' \
    [cobbler_image_ip_centos6_5]='system_images_import_centos6_5.yml' \
    [cobbler_image_ip_centos7_2]='system_images_import_centos7_2.yml' \
    [cobbler_image_ip_centos7_3]='system_images_import_centos7_3.yml')
    TACK_PATH="$ANSIBLE_PATH/roles/cobbler_server/tasks/main.yml"
    VARS_PATH="$ANSIBLE_PATH/roles/cobbler_server/vars/main.yml"
    check_fun "${!HOSTVAR[*]}" "${HOSTVAR[*]}" "${#HOSTVAR[@]}" $TACK_PATH $VARS_PATH
}

#role_system_init
#role_zabbix_server
#role_zabbix_agent
#role_cobbler_server

echo "The check is over!"
