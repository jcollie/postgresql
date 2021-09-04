ARG ROCKYLINUX

FROM docker.io/rockylinux/rockylinux:${ROCKYLINUX}

ARG POSTGRESQL
ARG PGBACKREST

RUN dnf -y module disable postgresql
RUN dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
RUN dnf -y install postgresql13-server-${POSTGRESQL} pgbackrest-${PGBACKREST} curl jq langpacks-en
RUN sed -i -e "s@^#* *listen_addresses *=.*\$@listen_addresses = '*'@" /usr/pgsql-13/share/postgresql.conf.sample
RUN sed -i -e "s@^#* *port *=.*\$@port = 5432@" /usr/pgsql-13/share/postgresql.conf.sample
RUN sed -i -e "s@^#* *logging_collector *=.*\$@logging_collector = off@" /usr/pgsql-13/share/postgresql.conf.sample
RUN sed -i -e "s@^#* *log_line_prefix *=.*\$@log_line_prefix = '%m [%p] :%h:%d:%u:%c: '@" /usr/pgsql-13/share/postgresql.conf.sample
RUN sed -i -e "s@^#* *wal_level *=.*\$@wal_level=replica@" /usr/pgsql-13/share/postgresql.conf.sample
RUN sed -i -e "s@^#* *max_wal_senders *=.*\$@max_wal_senders=3@" /usr/pgsql-13/share/postgresql.conf.sample
COPY entrypoint.sh /entrypoint.sh
USER 26:26
ENTRYPOINT [ "/entrypoint.sh" ]
