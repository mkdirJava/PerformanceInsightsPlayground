#!/bin/bash
# set -eu
export set DEMO_SCRIPT_HOME=$(pwd)

function buildImages () {
    buildHttpGo
    buildGinGo
    buildEchoGo
    buildQuarkus
    buildJavaSe
    buildSpringJvm
    buildSpringNative
}


function buildHttpGo () {
    echo "Building Go Http"
    docker build -f "$DEMO_SCRIPT_HOME/go_http/dockerfile" -t go_http "$DEMO_SCRIPT_HOME/go_http"
}

function buildGinGo () {
    echo "Building Go Gin"
    docker build -f "$DEMO_SCRIPT_HOME/go_gin/dockerfile" -t go_gin "$DEMO_SCRIPT_HOME/go_gin"
}

function buildEchoGo () {
    echo "Building Go Echo"
    docker build -f "$DEMO_SCRIPT_HOME/go_echo/dockerfile" -t go_echo "$DEMO_SCRIPT_HOME/go_echo"
}

function buildQuarkus () {
    echo "Building Quarkus Image"
    docker build -f "$DEMO_SCRIPT_HOME/quarkus/dockerfile" -t quarkus_native "$DEMO_SCRIPT_HOME/quarkus"
}

function buildJavaSe () {
    echo "Building java se Image"
    docker build -f "$DEMO_SCRIPT_HOME/java_se/dockerfile" -t java_se_native "$DEMO_SCRIPT_HOME/java_se"
}

function buildSpringJvm () {
    echo "Building Springboot JVM"
    $DEMO_SCRIPT_HOME/springboot/gradlew bootBuildImage -p "$DEMO_SCRIPT_HOME/springboot" 
}

function buildSpringNative () {
    echo "Building Springboot Native"
    docker build -f "$DEMO_SCRIPT_HOME/springboot/dockerfile" -t spring_boot_native "$DEMO_SCRIPT_HOME/springboot"
}

function loadTest () {
    echo "Running test for 10 seconds"
    go-wrk -c 100 "http://localhost:$1/test" | tee  >> $DEMO_SCRIPT_HOME/results/$1_result.txt
    echo "done"
}