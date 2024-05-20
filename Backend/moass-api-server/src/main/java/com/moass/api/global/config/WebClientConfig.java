package com.moass.api.global.config;

import io.netty.channel.ChannelOption;
import io.netty.handler.logging.LogLevel;
import io.netty.handler.timeout.ReadTimeoutHandler;
import io.netty.handler.timeout.WriteTimeoutHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.reactive.ReactorClientHttpConnector;
import org.springframework.web.reactive.function.client.ExchangeStrategies;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.netty.http.client.HttpClient;
import reactor.netty.resources.ConnectionPoolMetrics;
import reactor.netty.resources.ConnectionProvider;
import reactor.netty.resources.PooledConnectionProvider;
import reactor.netty.transport.TransportConfig;
import reactor.netty.transport.logging.AdvancedByteBufFormat;

import java.time.Duration;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@Slf4j
@Configuration
public class WebClientConfig {

    @Bean
    public WebClient mmApiWebClient() {
        HttpClient httpClient = createHttpClient("mmApiConnectionPool");

        ExchangeStrategies strategies = ExchangeStrategies.builder()
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(16 * 1024 * 1024)) // 16MB 설정
                .build();

        return WebClient.builder()
                .baseUrl("https://meeting.ssafy.com")
                .exchangeStrategies(strategies)
                .clientConnector(new ReactorClientHttpConnector(httpClient))
                .build();
    }

    @Bean
    public WebClient gitlabAuthWebClient() {
        HttpClient httpClient = createHttpClient("gitlabAuthConnectionPool");

        ExchangeStrategies strategies = ExchangeStrategies.builder()
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(16 * 1024 * 1024)) // 16MB 설정
                .build();

        return WebClient.builder()
                .baseUrl("https://lab.ssafy.com")
                .exchangeStrategies(strategies)
                .clientConnector(new ReactorClientHttpConnector(httpClient))
                .build();
    }

    @Bean
    public WebClient gitlabApiWebClient() {
        HttpClient httpClient = createHttpClient("gitlabApiConnectionPool");

        ExchangeStrategies strategies = ExchangeStrategies.builder()
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(16 * 1024 * 1024)) // 16MB 설정
                .build();

        return WebClient.builder()
                .baseUrl("https://lab.ssafy.com")
                .exchangeStrategies(strategies)
                .clientConnector(new ReactorClientHttpConnector(httpClient))
                .build();
    }

    @Bean
    public WebClient jiraAuthWebClient() {
        HttpClient httpClient = createHttpClient("jiraAuthConnectionPool");
        return WebClient.builder()
                .baseUrl("https://auth.atlassian.com")
                .clientConnector(new ReactorClientHttpConnector(httpClient))
                .build();
    }

    @Bean
    public WebClient jiraApiWebClient() {
        HttpClient httpClient = createHttpClient("jiraApiConnectionPool");

        ExchangeStrategies strategies = ExchangeStrategies.builder()
                .codecs(configurer -> configurer.defaultCodecs().maxInMemorySize(16 * 1024 * 1024)) // 16MB 설정
                .build();

        return WebClient.builder()
                .baseUrl("https://api.atlassian.com")
                .exchangeStrategies(strategies)
                .clientConnector(new ReactorClientHttpConnector(httpClient))
                .build();
    }

    private HttpClient createHttpClient(String poolName) {
        ConnectionProvider connectionProvider = ConnectionProvider.builder(poolName)
                .maxConnections(50)
                .pendingAcquireTimeout(Duration.ofSeconds(60))
                .evictInBackground(Duration.ofMinutes(5)) // 주기적으로 오래된 커넥션을 제거
                .build();

        
        HttpClient httpClient = HttpClient.create(connectionProvider)
                .responseTimeout(Duration.ofSeconds(10))
                .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 10000)
                .doOnConnected(conn ->
                        conn.addHandlerLast(new ReadTimeoutHandler(10000, TimeUnit.MILLISECONDS))
                                .addHandlerLast(new WriteTimeoutHandler(10000, TimeUnit.MILLISECONDS)))
                .wiretap("reactor.netty.http.client.HttpClient", LogLevel.INFO, AdvancedByteBufFormat.TEXTUAL);
        return httpClient;
    }

}
