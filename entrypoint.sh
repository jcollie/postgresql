#!/bin/bash

PGDATA=/var/lib/pgsql/13/data
export PGDATA

if [ ! -s "$PGDATA/PG_VERSION" ]
then
    echo "Database does not exist!"
    /usr/pgsql-13/bin/initdb --username=postgres --pwfile=<(echo "$POSTGRES_PASSWORD") --data-checksums --locale=en_US.utf8
    echo "host all all all scram-sha-256" >> "$PGDATA/pg_hba.conf"
    /usr/pgsql-13/bin/pg_ctl -o "-c listen_addresses='' -p 5432" -w start
    /usr/bin/sed -i -e "s@^#* *archive_command *=.*\$@archive_command = '/usr/bin/pgbackrest archive-push %p'@" "$PGDATA/postgresql.conf"
    /usr/bin/sed -i -e "s@^#* *archive_mode *=.*\$@archive_mode = on@" "$PGDATA/postgresql.conf"
    /usr/bin/pgbackrest stanza-create
    /usr/pgsql-13/bin/pg_ctl -m fast -w stop
fi

if [ -z "$@" ]
then
    exec /usr/pgsql-13/bin/postgres
fi

exec "$@"
