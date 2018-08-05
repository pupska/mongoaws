#!/usr/bin/env bash

DB_PATH="${DB_PATH:-/var/lib/mongo}"
REPL_SET="${REPL_SET:-rs0}"
BIND_IP="${BIND_IP:-0.0.0.0}"
LOG_PATH="${LOGPATH:-/var/log/mongodb/log}"

echo "Starting mongodb server as below:"
echo "/usr/bin/mongod --dbpath $DB_PATH --replSet $REPL_SET --logpath $LOG_PATH --bind_ip $BIND_IP"
exec /usr/bin/mongod --dbpath $DB_PATH --replSet $REPL_SET --logpath $LOG_PATH --bind_ip $BIND_IP