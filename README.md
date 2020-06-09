# Simple LDAP Proxy for greenlight

## Installation

```
cd greenlight
git clone https://github.com/beckerr-rzht/greenlight-ldap-proxy.git ldap-proxy
```

## Configure

### Configure docker-compose

Add this service to your `docker-compose.yml`
```
  ldap:
    restart: always
    build: ldap-proxy
    environment:
      - LDAP_BACKEND_URI=${LDAP_BACKEND_URI}
      - LDAP_BASE=${LDAP_BASE}
      - LDAP_FILTER=${LDAP_BACKEND_FILTER}
      - LDAP_BIND_DN=${LDAP_BIND_DN}
      - LDAP_PASSWORD=${LDAP_PASSWORD}
      - LDAP_DEBUG=${LDAP_DEBUG}
    volumes:
      - ./ldap-proxy/slapd.conf.t:/etc/openldap/slapd.conf.t:ro
```

### Configure greenlight

Change `.env` to use the ldap proxy instead your ldap server.
Your ldap server will be the backend server.
```
# Use "ldap", "398" and "plain" for the local ldap proxy
LDAP_SERVER=ldap
LDAP_PORT=389
LDAP_METHOD=plain
LDAP_UID=uid
LDAP_BASE=dc=example,dc=com
LDAP_BIND_DN=cn=admin,dc=example,dc=com
LDAP_PASSWORD=password
#LDAP_ROLE_FIELD=ou

# LDAP Backend Server and optional LDAP Backend Filter
LDAP_BACKEND_URI=ldaps://ldap.example.com:636/dc=example,dc=com
LDAP_BACKEND_FILTER=(\&(objectClass=posixAccount)(employeeType=staff))
LDAP_DEBUG=256
```

### Configure LDAP Attribute Mapping

Edit `ldap-proxy/slapd.conf.t` and adjust the `map attribute` statements to your needs.


## Redeploy greenlight

```
docker-compose stop
docker-compose rm
docker-compose up -d
```

## Monitor LDAP Proxy

```
docker-compose logs -f --tail=100 ldap
```

