public-addr="$1" public-port="$2" ip4p="$3" private-port"$4"; protocol="$5"; private-addr="$6" server-addr="$7"; server-port="$8"


```sh
natmap -s turn.cloudflare.com -h g.cn -t 192.168.1.200 -p 80 -b 8000 -e /etc/natmap/upnp.sh
```
```sh
#!/bin/sh
b="$4"; protocol="$5"; private_ip="192.168.1.200"; private_port="80"
curl -s -X POST "http://192.168.1.1:52869/upnp/control/WANIPConn1" \
     -H "Content-Type: text/xml; charset=utf-8" \
     -H "SOAPAction: \"urn:schemas-upnp-org:service:WANIPConnection:1#DeletePortMapping\"" \
     -d "<?xml version=\"1.0\"?>
<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">
  <s:Body>
    <u:DeletePortMapping xmlns:u=\"urn:schemas-upnp-org:service:WANIPConnection:1\">
      <NewRemoteHost></NewRemoteHost>
      <NewExternalPort>${private-port}</NewExternalPort>
      <NewProtocol>$(echo "$protocol" | tr 'a-z' 'A-Z')</NewProtocol>
    </u:DeletePortMapping>
  </s:Body>
</s:Envelope>"
curl -s -X POST "http://192.168.1.1:52869/upnp/control/WANIPConn1" \
     -H "Content-Type: text/xml; charset=utf-8" \
     -H "SOAPAction: \"urn:schemas-upnp-org:service:WANIPConnection:1#AddPortMapping\"" \
     -d "<?xml version=\"1.0\"?>
<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">
  <s:Body>
    <u:AddPortMapping xmlns:u=\"urn:schemas-upnp-org:service:WANIPConnection:1\">
      <NewRemoteHost></NewRemoteHost>
      <NewInternalClient>${server-addr}</NewInternalClient>
      <NewInternalPort>${server-port}</NewInternalPort>
      <NewExternalPort>${private-port}</NewExternalPort>
      <NewProtocol>$(echo "$protocol" | tr 'a-z' 'A-Z')</NewProtocol>
      <NewEnabled>1</NewEnabled>
      <NewPortMappingDescription>Natter-UPnP</NewPortMappingDescription>
      <NewLeaseDuration>0</NewLeaseDuration>
    </u:AddPortMapping>
  </s:Body>
</s:Envelope>"

```
