#!/bin/bash
# set -eu
export set DEMO_SCRIPT_HOME=$(pwd)

function buildImages () {
    buildGoKafkaConsumer
    buildJavaSeNativeConsumer
    buildJavaSeNativeProducer
}


function buildJavaSeNativeConsumer () {
    echo "Building java_se_kafka_consumer"
    docker build -f "$DEMO_SCRIPT_HOME/java_se_kafka_consumer/dockerfile" -t java_se_kafka_consumer "$DEMO_SCRIPT_HOME/java_se_kafka_consumer"
}

function buildJavaSeNativeProducer () {
    echo "Building java_se_kafka_producer"
    docker build -f "$DEMO_SCRIPT_HOME/java_se_kafka_producer/dockerfile" -t java_se_kafka_producer "$DEMO_SCRIPT_HOME/java_se_kafka_producer"
}

function buildGoKafkaConsumer () {
    echo "Building go_kafka_consumer"
    docker build -f "$DEMO_SCRIPT_HOME/go_kafka_consumer/dockerfile" -t go_kafka_consumer "$DEMO_SCRIPT_HOME/go_kafka_consumer"
}

function loadTest () {
    echo "Running test for 10 seconds"
    go-wrk -c 100 "http://localhost:$1/test" | tee  >> $DEMO_SCRIPT_HOME/results/$1_result.txt
    echo "done"
}
