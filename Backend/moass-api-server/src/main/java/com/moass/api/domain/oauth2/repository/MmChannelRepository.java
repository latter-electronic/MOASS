package com.moass.api.domain.oauth2.repository;

import com.moass.api.domain.oauth2.entity.MMChannel;
import com.moass.api.domain.oauth2.entity.MMChannelDetail;
import com.moass.api.domain.oauth2.entity.MMTeam;
import org.springframework.data.r2dbc.repository.Query;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import reactor.core.publisher.Mono;

public interface MmChannelRepository extends ReactiveCrudRepository<MMChannel, String> {

    @Query("INSERT INTO MMChannel (mm_channel_id, mm_team_id, mm_channel_name) " +
            "VALUES (:#{#mmChannel.mmChannelId}, :#{#mmChannel.mmTeamId}, :#{#mmChannel.mmChannelName})")
    Mono<MMChannel> saveForce(MMChannel mmChannel);

    @Query("SELECT mc.*, mt.mm_team_icon FROM MMChannel mc " +
            "JOIN MMTeam mt ON mc.mm_team_id = mt.mm_team_id " +
            "WHERE mm_channel_id = :channelId")
    Mono<MMChannelDetail> findDetailByChannelId(String channelId);
}
