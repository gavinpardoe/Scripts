# Proxy Configuration Script
# Created 21-04-15
#!/bin/sh

# Detects all network hardware & creates services for all installed network hardware with default settings.
/usr/sbin/networksetup -detectnewhardware

# Set BASH Internal Field Separator = new line.
IFS=$'\n'

# Loops through the list of network services.
for i in $(networksetup -listallnetworkservices | tail +2 );
do

# Get a list of all services beginning 'Ether' 'Air' or 'Wi-Fi' and output status (Yes/No or On/Off) add remove services as required.
if [[ "$i" =~ 'Ether' ]] || [[ "$i" =~ 'Air' ]] || [[ "$i" =~ 'Wi-Fi' ]] ; then
autoProxyDiscStatus=`networksetup -getproxyautodiscovery $i | awk '{ print $4 }'`
getWebProxy=`networksetup -getwebproxy $i | awk 'NR==1{ print $2 }'`
getSecureWebProxy=`networksetup -getsecurewebproxy $i | awk 'NR==1{ print $2 }'`

# Echo's the name of any matching services & the proxyURL's set.
echo "$i Auto Proxy is $autoProxyDiscStatus"
echo "$i Web Proxy Enabled $getWebProxy"
echo "$i Secure Web Proxy Enabled $getSecureWebProxy"

# If the value returned of $ProxyURLLocal does not match the value of $ProxyURL for the interface $i, change it.
if [[ $autoProxyDiscStatus != On ]]; then
networksetup -setproxyautodiscovery $i On
echo "Set  Auto Proxy for $i to On"
fi
# Add proxy server address & port number after $i (e.g networksetup -setwebproxy $i proxy.com 8080).
if [[ $getWebProxy != Yes ]]; then
networksetup -setwebproxy $i
echo "Set Web Proxy for $i to Enabled"
fi
# Add proxy server address & port number after $i (e.g networksetup -setsecurewebproxy $i proxy.com 8080).
if [[ $getSecureWebProxy != Yes ]]; then
networksetup -setsecurewebproxy $i
echo "Set Secure Web Proxy for $i to Enabled"
fi
# Adding Proxy Bypass Adresses, add proxy bypass address (white space separated).
if [[ $getWebProxy != na ]]; then
networksetup -setproxybypassdomains $i *.local 169.254/16
echo "Adding Proxy Bypasses to Network Services"
fi
fi
done
echo "All Proxies & Proxy Bypasses Configured..."
unset IFS

exit 0
