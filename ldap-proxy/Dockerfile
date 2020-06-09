FROM alpine:3.7

MAINTAINER Ralf Becker <beckerr@hochschule-trier.de>

RUN apk add --no-cache openldap openldap-back-ldap openldap-back-meta openldap-overlay-rwm

EXPOSE 389

COPY ./start.sh /start.sh
CMD [ "/bin/sh", "/start.sh" ]
 
