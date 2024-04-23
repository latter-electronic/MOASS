package com.moass.api.global.config;

import reactor.blockhound.BlockHound;
import reactor.blockhound.integration.BlockHoundIntegration;

public class BlockHoundCustomConfiguration implements BlockHoundIntegration {

    @Override
    public void applyTo(BlockHound.Builder builder) {
        builder.allowBlockingCallsInside("io.netty.util.concurrent.FastThreadLocalRunnable", "run");
    }
}
