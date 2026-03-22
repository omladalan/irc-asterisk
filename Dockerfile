FROM debian:trixie-slim

WORKDIR /irc-asterisk

RUN apt update
RUN apt upgrade -y
RUN apt install build-essential wget pkg-config libedit-dev uuid-dev libjansson-dev libssl-dev libxml2-dev libsqlite3-dev systemd subversion python3 python3-pip python3-venv vim iftop htop -y
RUN apt install unixodbc unixodbc-dev libtool libltdl-dev odbc-postgresql -y
RUN apt install gettext -y

RUN cd /usr/src && \
    wget https://downloads.asterisk.org/pub/telephony/certified-asterisk/asterisk-certified-22.8-cert1.tar.gz && \
    tar -xvzf asterisk-certified-22.8-cert1.tar.gz && \
    cd asterisk-certified-22.8-cert1 && \
    ./contrib/scripts/get_mp3_source.sh && \
    ./contrib/scripts/install_prereq install && \
    ./configure --libdir=/usr/lib64 --with-jansson-bundled
COPY ./menuselect.makeopts /usr/src/asterisk-certified-22.8-cert1/menuselect.makeopts

RUN sleep 5 && \
    cd /usr/src/asterisk-certified-22.8-cert1 && \
    make && \
    make install && \
    make samples && \
    make config  && \
    make clean && \
    cd .. && \
    rm -fr asterisk-certified-22.8-cert1.tar.gz

COPY ./scripts/ /irc-asterisk/scripts/

RUN cd /irc-asterisk/scripts/

WORKDIR /irc-asterisk/scripts/

RUN python3 -m venv .venv

ENV TZ=America/Sao_Paulo

ENV PATH="/irc-asterisk/scripts/.venv/bin:$PATH"

RUN /irc-asterisk/scripts/.venv/bin/pip install --no-cache-dir -r requirements.txt

COPY ./entrypoint-asterisk.sh /usr/local/bin/entrypoint-asterisk.sh

RUN chmod +x /usr/local/bin/entrypoint-asterisk.sh

COPY ./irc-asterisk/templates/ /irc-asterisk/templates/

COPY ./irc-asterisk/config/ /etc/asterisk/

COPY ./irc-asterisk/odbcinst.ini /etc/odbcinst.ini

ENTRYPOINT ["/usr/local/bin/entrypoint-asterisk.sh"]