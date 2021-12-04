FROM debian:bullseye-slim

RUN apt update && \
    apt install -y debhelper build-essential dh-make git meson

WORKDIR /packages

ADD packages .

RUN find . -name "*.sh" -exec chmod +x {} \;
