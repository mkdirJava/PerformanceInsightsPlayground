/*
 * This source file was generated by the Gradle 'init' task
 */
package org.example;

import io.undertow.Handlers;
import io.undertow.Undertow;


public class App {
    
    public static void main(String[] args) {
        var server = Undertow.builder()
        .addHttpListener(8090, "0.0.0.0")
        .setHandler(Handlers.path()
        .addExactPath("test", (exchange)->{
            exchange.getResponseSender().send("test");
        }))
        .build();

        server.start();
    }
}
