#!/bin/sh
private-port="$4"; protocol="$5"; private-addr="$6"; server-addr="192.168.1.200"; server-port="80"
upnpc -a ${server-addr} ${server-port} ${private-port} ${protocol}
