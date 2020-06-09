#!/bin/sh

test -d /var/run/openldap || mkdir /var/run/openldap
chown ldap:ldap /var/run/openldap
chmod 755 /var/run/openldap

sed "
	s#\${LDAP_BIND_DN}#$LDAP_BIND_DN#g;
	s#\${LDAP_PASSWORD}#$LDAP_PASSWORD#g;
	s#\${LDAP_BASE}#$LDAP_BASE#g;
	s#\${LDAP_BACKEND_URI}#$LDAP_BACKEND_URI#g;
	s#\${LDAP_FILTER}#$LDAP_FILTER#g;
" /etc/openldap/slapd.conf.t >/etc/openldap/slapd.conf

echo "Starting LDAP-Proxy-Server..."
exec /usr/sbin/slapd -h ldap:/// -u ldap -g ldap -f /etc/openldap/slapd.conf -d ${LDAP_DEBUG:-0}
