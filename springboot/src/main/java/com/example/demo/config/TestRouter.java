package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.RouterFunctions;
import org.springframework.web.reactive.function.server.ServerResponse;

@Configuration
public class TestRouter {
    @Bean
    public RouterFunction<ServerResponse> getRouter(){
        return RouterFunctions.route()
        .GET("/test",(request)->{
            return ServerResponse.ok().bodyValue("ok");
        })
        .build();
    }
}
