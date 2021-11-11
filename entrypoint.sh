#!/bin/bash
# listeners=SASL_PLAINTEXT://MYHOSTNAME:9092 change this line
export MYHOSTNAME=$(hostname -i)
sed -i 's/^listeners.*MYHOSTNAME.*/listeners=SASL_PLAINTEXT\:\/\/'$MYHOSTNAME'\:9092/' $KAFKA_CONFIG_DIR/server.properties

# advertised.listeners=SASL_PLAINTEXT://MYHOSTNAME:9092
sed -i 's/^advertised.listeners.*MYHOSTNAME.*/advertised.listeners=SASL_PLAINTEXT\:\/\/'$MYHOSTNAME'\:9092/' $KAFKA_CONFIG_DIR/server.properties

KAFKA_OPTS="-Djava.security.auth.login.config=$KAFKA_CONFIG_DIR/zookeeper_jaas.conf" zookeeper-server-start.sh $KAFKA_CONFIG_DIR/zookeeper.properties | tee -a $SERVER_RUNNING_LOG/zookeeper.log &
echo "Zookeeper server is started and you can tail the log in $SERVER_RUNNING_LOG/zookeeper.log"
sleep 20

KAFKA_OPTS="-Djava.security.auth.login.config=$KAFKA_CONFIG_DIR/kafka_server_jaas.conf" JMXPORT=$1 kafka-server-start.sh $KAFKA_CONFIG_DIR/server.properties | tee -a $SERVER_RUNNING_LOG/kafka.log
