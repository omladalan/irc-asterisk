#!/bin/sh
set -e

envsubst < /irc-asterisk/templates/odbc.ini.template > /etc/odbc.ini

envsubst < /irc-asterisk/templates/cdr_pgsql.conf.template > /etc/asterisk/cdr_pgsql.conf
envsubst < /irc-asterisk/templates/http.conf.template > /etc/asterisk/http.conf
envsubst < /irc-asterisk/templates/logger.conf.template > /etc/asterisk/logger.conf
envsubst < /irc-asterisk/templates/manager.conf.template > /etc/asterisk/manager.conf
envsubst < /irc-asterisk/templates/res_odbc.conf.template > /etc/asterisk/res_odbc.conf
envsubst < /irc-asterisk/templates/res_pgsql.conf.template > /etc/asterisk/res_pgsql.conf
envsubst < /irc-asterisk/templates/rtp.conf.template > /etc/asterisk/rtp.conf

exec /usr/sbin/asterisk -f