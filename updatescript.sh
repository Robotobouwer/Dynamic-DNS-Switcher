#!/bin/bash

FILEPATH="/etc/bind/named.conf.options"

sed -i 's@// forwarders {@  forwarders {@g' $FILEPATH
sed -i 's@// 	0.0.0.0;@        1.2.3.4;@g' $FILEPATH
sed -i 's@// };@   };@g' $FILEPATH