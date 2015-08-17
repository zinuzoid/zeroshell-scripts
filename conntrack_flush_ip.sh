#!/bin/sh
. /etc/kerbynet.conf

IP=$1

if [[ "$1" == "" ]]; then
	echo 'ip required'
	exit 1
fi

conntrack -p udp -s $IP -L | \
	while read proto _ _ src dst sport dport _; do
		PROTO=`echo "$proto" | cut -d "=" -f2` 
		SRC=`echo "$src" | cut -d "=" -f2` 
		DST=`echo "$dst" | cut -d "=" -f2` 
		SPORT=`echo "$sport" | cut -d "=" -f2` 
		DPORT=`echo "$dport" | cut -d "=" -f2` 

		conntrack -D \
			--proto $PROTO \
			--orig-src $SRC \
			--orig-dst $DST \
			--sport $SPORT \
			--dport $DPORT
	done


conntrack -p tcp -s $IP -L | \
	while read proto _ _ _ src dst sport dport _; do
		PROTO=`echo "$proto" | cut -d "=" -f2` 
		SRC=`echo "$src" | cut -d "=" -f2` 
		DST=`echo "$dst" | cut -d "=" -f2` 
		SPORT=`echo "$sport" | cut -d "=" -f2` 
		DPORT=`echo "$dport" | cut -d "=" -f2` 

		conntrack -D \
			--proto $PROTO \
			--orig-src $SRC \
			--orig-dst $DST \
			--sport $SPORT \
			--dport $DPORT
	done

echo "FLUSH $IP CONNTRACK"
echo "`date` FLUSH $IP CONNTRACK" >> /tmp/zlog
