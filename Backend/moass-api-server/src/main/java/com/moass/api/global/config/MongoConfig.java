package com.moass.api.global.config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.core.ReactiveMongoTemplate;

@Configuration
public class MongoConfig {

    private final ReactiveMongoTemplate reactiveMongoTemplate;
    public MongoConfig(ReactiveMongoTemplate reactiveMongoTemplate) {
        this.reactiveMongoTemplate = reactiveMongoTemplate;
    }

    @Bean
    CommandLineRunner commandLineRunner(ReactiveMongoTemplate reactiveMongoTemplate) {
        return args -> {
            //resetData();
        };
    }

    private void resetData() {
        reactiveMongoTemplate.getCollectionNames()
                .flatMap(collectionName -> reactiveMongoTemplate.dropCollection(collectionName))
                .subscribe(
                        result -> System.out.println("Collection dropped."),
                        error -> System.err.println("Error dropping collection: " + error),
                        () -> System.out.println("All collections dropped successfully.")
                );
    }
}
