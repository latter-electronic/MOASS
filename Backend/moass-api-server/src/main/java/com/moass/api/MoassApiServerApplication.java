package com.moass.api;

import com.moass.api.global.config.BlockHoundCustomConfiguration;
import jakarta.annotation.PostConstruct;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
import reactor.blockhound. BlockHound;
import reactor.core.publisher.Hooks;

import java.util.TimeZone;

@EnableScheduling
@SpringBootApplication
public class MoassApiServerApplication {

    @PostConstruct
    public void started(){
        TimeZone.setDefault(TimeZone.getTimeZone("UTC"));
    }

    public static void main(String[] args) {
        Hooks.onOperatorDebug();
        //BlockHound.install(new BlockHoundCustomConfiguration());
        SpringApplication.run(MoassApiServerApplication.class, args);
    }


}
