FROM alpine:latest

RUN apk update \
    && apk upgrade

WORKDIR /build

RUN wget https://dlcdn.apache.org/kafka/3.0.0/kafka_2.13-3.0.0.tgz

RUN apk add --no-cache tar \
            build-base

RUN apk add bash \
            openjdk11

RUN tar -xvf kafka_2.13-3.0.0.tgz && rm kafka_2.13-3.0.0.tgz && mv kafka_2.13-3.0.0 kafka

ENV KAFKA_CONFIG_DIR=/build/kafka/config

ENV PATH=/build/kafka/bin:${PATH}

SHELL ["/bin/bash", "-c"]

COPY zookeeper_jaas.conf ${KAFKA_CONFIG_DIR}/.
COPY kafka_server_jaas.conf ${KAFKA_CONFIG_DIR}/.
COPY server.properties ${KAFKA_CONFIG_DIR}/.
COPY zookeeper.properties ${KAFKA_CONFIG_DIR}/.
COPY entrypoint.sh .
ENV SERVER_RUNNING_LOG=/var/log/kafka
RUN mkdir ${SERVER_RUNNING_LOG}

VOLUME [ "/kafka", "/zookeeper" ]

ENTRYPOINT [ "./entrypoint.sh" ]

EXPOSE 9092 2181

CMD [ "8004" ]