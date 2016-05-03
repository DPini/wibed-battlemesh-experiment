#!/bin/sh

#set -x

#ACTIONS are: add prepare clean?
# example: $0 <action> <virtual_if> <actual_if> <IPv4/16> <IPv6/64>

# olsr.sh prepare
# olsr.sh add wlan wlan0
# olsr.sh add lan eth0.1

ACTION=$1
LOGICAL_INTERFACE=$2
REAL_INTERFACE=$3
IPV4=$4
IPV6=$5

store_neigh_stats()
{
# output should look like this
# and will be used to plot some .dot-files for visualization
#
# $myhostname $neighmac_or_ip    $iface  $quali $rx/tx-packets/bytes   $minstrel_filename
# wbm-8cd9    11:22:33:44:55:66  eth0.1  4321   123 435 723876 7632465 /tmp/minstrel.$uptimestamp

# fdba:15::/32
    echo
}

prepare() {
  uci revert olsrd2
  rm /etc/config/olsrd2
  touch /etc/config/olsrd2

  uci import olsrd2 << EOF

config global
        option 'pidfile'        '/var/run/olsrd2.pid'
        option 'lockfile'       '/var/lock/olsrd2'

config log
        option 'syslog'              'true'
        option 'stderr'              'true'

config interface
        list         'ifname'        'wbm1_olsr2'

config interface
        list         'ifname'        'lan_olsr2'
        option       'rx_bitrate'    '1000M'
EOF

}

add() {
    true
}

start () {
    /etc/init.d/olsrd2 start
}

stop () {
    /etc/init.d/olsrd2 stop
    killall -9 olsrd2 2>/dev/null
}

$ACTION
