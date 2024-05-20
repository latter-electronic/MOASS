package com.moass.api.global.handler;

import io.r2dbc.pool.ConnectionPool;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class PoolStatusHandler {
    private static final Logger logger = LoggerFactory.getLogger(PoolStatusHandler.class);

    @Autowired
    private ConnectionPool connectionPool;

    //@Scheduled(fixedRate = 10000) // 5000ms = 5 seconds
    public void logPoolStatus() {
        if (connectionPool.getMetrics().isPresent()) {
            var metrics = connectionPool.getMetrics().get();
            logger.info("Active connections (acquire size): {}", metrics.acquiredSize());
            logger.info("Total allocated connections (allocated size): {}", metrics.allocatedSize());
            logger.info("Max allocated size: {}", metrics.getMaxAllocatedSize());
            logger.info("Idle connections (idle size): {}", metrics.idleSize());
            logger.info("Max pending acquire size: {}", metrics.getMaxPendingAcquireSize());
        } else {
            logger.info("Connection pool metrics not available.");
        }
    }
}