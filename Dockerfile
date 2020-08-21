FROM ubuntu:focal

# Aptitude
ARG APTSOURCE_POSTGRES_KEY="https://www.postgresql.org/media/keys/ACCC4CF8.asc"
ARG APTSOURCE_POSTGRES="https://apt.postgresql.org/pub/repos/apt/"
RUN apt-get update                                 && \
    apt-get install -y --no-install-recommends        \
        ca-certificates                               \
        curl                                          \
        gnupg2                                        \
        wget                                       && \
    curl -s ${APTSOURCE_POSTGRES_KEY} 2>/dev/null     \
        | apt-key add -                            && \
    echo "deb ${APTSOURCE_POSTGRES} buster-pgdg main" \
        > /etc/apt/sources.list.d/pgdg.list        && \
    apt-get clean -y                               && \
    apt-get autoclean -y                           && \
    rm -rf /var/lib/apt/lists/*

# Install libs and common packages
RUN export DEBIAN_FRONTEND=noninteractive          && \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update                                 && \
    apt-get install -y --no-install-recommends        \
        bash                                          \
        bash-completion                               \
        dnsutils                                      \
        git                                           \
        htop                                          \
        ldap-utils                                    \
        less                                          \
        logrotate                                     \
        mc                                            \
        nano                                          \
        postgresql-client-12                          \
        procps                                        \
        sysstat                                       \
        unzip                                      && \
    apt-get clean -y                               && \
    apt-get autoclean -y                           && \
    rm -rf /var/lib/apt/lists/*

ARG JOBBER_DEB_PACKAGE="https://github.com/dshearer/jobber/releases/download/v1.4.4/jobber_1.4.4-1_amd64.deb"
ENV JOBBER_VERSION="1.4.4"

RUN curl -L ${JOBBER_DEB_PACKAGE}                     \
        -o /root/jobber.deb                        && \
    dpkg -i /root/jobber.deb                       && \
    rm /root/jobber.deb                            && \
    mkdir -p /var/lib/jobber /etc/jobber           && \
    useradd jobber                                    \
            -d /var/lib/jobber -M                     \
            -s /usr/sbin/nologin                      \
            -u 999 -U                              && \
    chown jobber:jobber /var/lib/jobber

USER jobber

ENTRYPOINT [ "/usr/lib/x86_64-linux-gnu/jobberrunner", "/etc/jobber/jobber.yml" ]
