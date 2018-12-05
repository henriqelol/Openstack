apt -qy install memcached python-memcache 2>> memcached-error.log

sed -i 's/127.0.0.1/10.0.0.11/' /etc/memcached.conf
service memcached restart

