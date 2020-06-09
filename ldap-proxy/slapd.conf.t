#
# See slapd.conf(5) for details on configuration options.
# This file should NOT be world readable.
#

# Log
#
loglevel -1

include     /etc/openldap/schema/core.schema
include     /etc/openldap/schema/cosine.schema
include     /etc/openldap/schema/inetorgperson.schema
include     /etc/openldap/schema/nis.schema
include     /etc/openldap/schema/misc.schema

pidfile     /var/run/openldap/slapd.pid
argsfile    /var/run/openldap/slapd.args

modulepath  /usr/lib/openldap
moduleload  back_ldap.so
moduleload  back_meta.so
moduleload  rwm.so

# Access
# 
access to dn.base=""
        by * read

access to dn.base="cn=Subschema"
        by * read

access to attrs=userPassword
        by * auth

access to attrs=entry
    by anonymous read
    by self read
	by dn=${LDAP_BIND_DN} read
    by * none

access to *
    by self read
	by dn=${LDAP_BIND_DN} read
    by * none

# Database definitions
#
database      meta
suffix        "${LDAP_BASE}"
uri           "${LDAP_BACKEND_URI}"

idassert-bind bindmethod=simple
              binddn="${LDAP_BIND_DN}"
              credentials="${LDAP_PASSWORD}"
idassert-authzFrom
              "dn.regex:.*"

# Rewrite Filter to exclude non valid accounts
#
overlay            rwm
rwm-rewriteEngine  on

rwm-rewriteContext searchFilter

# Add filter
rwm-rewriteRule    "^(.*)" "(&${LDAP_FILTER}$1)" ":@"

# Options
#
chase-referrals no
nretries        100
bind-timeout    1000000
sizelimit       1

# Explizit mappings
#
map objectclass top *
map objectclass person *
map objectclass organizationalPerson *
map objectclass inetOrgPerson *
map objectclass *

map attribute uid *
map attribute mail *
map attribute rfc822MailAlias *
map attribute cn displayName
map attribute cn;lang-de displayName;lang-de
map attribute givenname *
map attribute givenname;lang-de *
map attribute sn *
map attribute sn;lang-de *
map attribute title *
map attribute employeeType *
map attribute telephoneNumber *
map attribute preferredLanguage *
map attribute applicationRestriction *
map attribute *

