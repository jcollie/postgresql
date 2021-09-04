ARG POSTGRESQL
ARG ALPINE

FROM docker.io/library/postgres:${POSTGRESQL}-alpine${ALPINE}

ARG PGBACKREST

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache curl jq musl-locales pgbackrest
RUN apk add --no-cache pgbackrest=${PGBACKREST}-r0
RUN sed -i -e "s@^#* *log_line_prefix *=.*\$@log_line_prefix = '%m [%p] :%h:%d:%u:%c: '@" /usr/local/share/postgresql/postgresql.conf.sample
RUN sed -i -e "s@^#* *wal_level *=.*\$@wal_level=replica@" /usr/local/share/postgresql/postgresql.conf.sample
RUN sed -i -e "s@^#* *max_wal_senders *=.*\$@max_wal_senders=3@" /usr/local/share/postgresql/postgresql.conf.sample
