
# Performance Insights Playground

This repo aims to show the performance difference between languages and more interestingly to native builds. 

This repo is benching

* Quarkus Native
* Spring boot JVM
* Spring boot native
* Java Se ( with undertow ), native graalvm
* Go ( with Gin )

Each of these technologies have a web server, with one endpoint "/test" and all respond with "test in the body

Requirements

* Docker compose, this used Docker Desktop for developement
* Java 21 ( used for building Spring boot JVM image)  
* Only Spring boot JVM is built using gradle ( wrapper used in this repo ), others are built in multi stage docker images, 
Reasoning, is there is a gradle task that builds an OCI image, thought it would be better to compare standard build approaces 
* go v1.21 
    * install run 

            go install github.com/tsliwowicz/go-wrk@latest

---
# Findings

Performance Ranking

1. Java Se Native
2. Quarkus Native
3. Golang Http
4. GO Echo
5. Go Gin
6. Spring Native
7. Spring Jvm

``` mermaid
xychart-beta
    title "Average Served Requests, 100 clients for 10 seconds"
    x-axis [Java_SE_NATIVE,Quarkus,GO_HTTP, GO_ECHO,GO_GIN,SPRING_NATIVE,SPRING_JVM]
    y-axis "Requests (per 1000)" 0 --> 1000
    bar [367.5906,224.0414,209.247,171.8278,167.2636,120.5436,86.585]
```

``` mermaid

xychart-beta
    title "Rough Response time, 100 clients for 10 seconds"
    x-axis [ SPRING_JVM, SPRING_NATIVE,Quarkus,Java_SE_NATIVE,GO_HTTP, GO_GIN,GO_ECHO]
    y-axis "Requests (micro second)" 0 --> 1
    bar [1,1,1,0.6,0.5,0.5,0.5]
```

---

## Getting started

1. Source the build tools run the command

    source [repo root]/tools.sh

2. Build the images used, this takes a while, run the command

    buildImages

3. Run up the project

    cd [project root] && docker-compose up

4. Execute load tests
    
        loadTest [port]

5. Observe on prometheus and cAdvisor

    aAdvisor
    localhost:8080

    Prometheus

    localhost:9010 
---

go to 
    localhost:9010
    enter prometheus query
    
        for CPU
        rate(container_cpu_system_seconds_total{container_label_com_docker_compose_service=~"quarkus_native|java_se_native|go|spring_boot_jvm|spring_boot_native"}[1m])

        for memory
        rate(container_memory_usage_bytes{container_label_com_docker_compose_service=~"quarkus_native|java_se_native|go|spring_boot_jvm|spring_boot_native"}[1m])

        network out
        rate(container_network_transmit_bytes_total{container_label_com_docker_compose_service=~"quarkus_native|java_se_native|go|spring_boot_jvm|spring_boot_native"}[1m])

        network in 
        rate(container_network_receive_bytes_total{container_label_com_docker_compose_service=~"quarkus_native|java_se_native|go|spring_boot_jvm|spring_boot_native"}[1m])
