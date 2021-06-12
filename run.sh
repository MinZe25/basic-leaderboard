#!/bin/sh
export DEV_USER=${DEV_USER:-dev}
export DEV_PASSWORD=${DEV_PASSWORD:-dev}
export ROOT_PASSWORD=${ROOT_PASSWORD:-root}
export POSTGRES_USER=${POSTGRES_USER:-postgres}
export POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-postgres}

echo "Hello World from run general"
echo "root:${ROOT_PASSWORD}" | chpasswd > /dev/null 2>&1
echo -e "${DEV_PASSWORD}\n${DEV_PASSWORD}" | adduser ${DEV_USER} > /dev/null 2>&1
/usr/sbin/sshd -o PermitRootLogin=yes -o UseDNS=no
echo "Starting server"
cd /code
exec npm run start &
echo "Giving permissions"
chown -R $DEV_USER:$DEV_USER /code /var/log /var/lib/postgresql /run/postgresql /tmp /etc/s6.d
echo "Executing"
exec su-exec $DEV_USER:$DEV_USER /bin/s6-svscan /etc/s6.d
