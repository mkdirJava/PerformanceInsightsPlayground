/*
 * This source file was generated by the Gradle 'init' task
 */
package org.example;

import java.io.IOException;
import java.net.InetAddress;
import java.time.Duration;
import java.util.List;
import java.util.Properties;

import org.apache.kafka.clients.CommonClientConfigs;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;

import io.prometheus.metrics.core.metrics.Counter;

public class App {
    private static Counter consumerCounter = getNewPromCounter();
    public static void main(String[] args) throws IOException, InterruptedException {
        
        consumerCounter.inc();
        io.prometheus.metrics.exporter.httpserver.HTTPServer.builder()
                .port(8080)
                .buildAndStart();

        Properties config = new Properties();
        config.put(CommonClientConfigs.CLIENT_ID_CONFIG, InetAddress.getLocalHost().getHostName() + "JAVA_SE_CONSUMER");
        config.put(CommonClientConfigs.GROUP_ID_CONFIG, "JAVA_SE_CONSUMER");
        config.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, getEnv("BROKER"));
        config.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        config.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
        try(var consumer = new KafkaConsumer<String, String>(config)){
            consumer.subscribe(List.of(getEnv("TOPIC")));
            while(true){
                var records = consumer.poll(Duration.ofSeconds(1));
                consumerCounter.inc(records.count());
            }
        }
    }


    private static Counter getNewPromCounter(){
        return Counter.builder()
        .name("message_consumed_counter_java")
        .help("The amount of messages consumed by java native")
        .register();
    }
    private static String getEnv(String envName) {
        var envValue = System.getenv().get(envName);
        if(envValue == null){
            throw new IllegalStateException(envName+ " env var needs to be populated");
        }
        System.out.println("envName: "+ envName +" has value: "+ envValue);
        return envValue;
    }
}
