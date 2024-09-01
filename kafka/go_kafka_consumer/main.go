package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/confluentinc/confluent-kafka-go/kafka"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	messageConsumedCounter := getNewPromCounter()

	http.Handle("/metrics", promhttp.Handler())
	go func() {
		http.ListenAndServe(":8080", nil)
	}()

	consumer := getConnection()
	consumer.Subscribe(getEnv("TOPIC"), nil)
	for {
		event := consumer.Poll(1000)
		switch event.(type) {
		case *kafka.Message:
			messageConsumedCounter.Inc()
		}
	}
}

func getNewPromCounter() prometheus.Counter {
	return promauto.NewCounter(prometheus.CounterOpts{
		Name: "message_consumed_counter_go",
		Help: "The total number of consumed messages",
	})
}

func getConnection() *kafka.Consumer {
	if consumer, connectionErr := kafka.NewConsumer(&kafka.ConfigMap{
		"bootstrap.servers": getEnv("BROKER"),
		"group.id":          getEnv("GROUP_ID"),
		"auto.offset.reset": "largest"}); connectionErr != nil {
		panic(connectionErr)
	} else {
		return consumer
	}
}

func getEnv(envVar string) string {
	foundVar := os.Getenv(envVar)
	if len(foundVar) == 0 {
		panic(fmt.Errorf("environment variable %s is needed", envVar))
	} else {
		return foundVar
	}
}
