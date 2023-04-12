FROM ubuntu:20.04
COPY life.py /opt

ARG DATABASE_HOST
ARG DATABASE_USER
ARG DATABASE_PASSWORD

ENV DATABASE_HOST=$DATABASE_HOST
ENV DATABASE_USER=$DATABASE_USER
ENV DATABASE_PASSWORD=$DATABASE_PASSWORD

RUN apt update && apt -y install \
    python3-psycopg2 \
    python3-pip

RUN pip3 install pythonping

ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/python3 /opt/life.py"]
