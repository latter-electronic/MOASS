package com.moass.api;

import com.moass.api.global.config.BlockHoundCustomConfiguration;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import reactor.blockhound. BlockHound;

@SpringBootApplication
public class MoassApiServerApplication {

    public static void main(String[] args) {
        BlockHound.install(new BlockHoundCustomConfiguration());
        SpringApplication.run(MoassApiServerApplication.class, args);
    }


}
