package com.moass.api.domain.device.dto;

import com.moass.api.domain.device.entity.Device;
import lombok.Data;

@Data
public class DeviceDetail {

    private String deviceId;

    private String userId;

    private Integer xcoord;

    private Integer ycoord;

    private String classCode;

    public DeviceDetail(Device device){
        this.deviceId = device.getDeviceId();
        this.userId = device.getUserId();
        this.xcoord = device.getXCoord();
        this.ycoord = device.getYCoord();
        this.classCode = device.getClassCode();
    }
}
