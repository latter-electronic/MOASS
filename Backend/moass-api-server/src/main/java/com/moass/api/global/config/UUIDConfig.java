package com.moass.api.global.config;

import java.util.concurrent.ThreadLocalRandom;

public class UUIDConfig {
    public static String generateUUID() {
        long mostSigBits = ThreadLocalRandom.current().nextLong();
        long leastSigBits = ThreadLocalRandom.current().nextLong();
        return new java.util.UUID(mostSigBits, leastSigBits).toString();
    }
}
