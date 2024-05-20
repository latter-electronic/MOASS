package com.moass.api.domain.device.dto;

import com.moass.api.domain.device.entity.Device;
import com.moass.api.domain.user.entity.UserSearchDetail;
import lombok.Data;

@Data
public class DeviceUserDetail {

    private String deviceId;

    private String userId;

    private Integer xcoord;

    private Integer ycoord;

    private String classCode;

    private UserSearchDetail userSearchDetail;

    public DeviceUserDetail(Device device, UserSearchDetail userSearchDetail){
        this.deviceId = device.getDeviceId();
        this.userId = device.getUserId();
        this.xcoord = device.getXCoord();
        this.ycoord = device.getYCoord();
        this.classCode = device.getClassCode();
        this.userSearchDetail = userSearchDetail;
    }

    public DeviceUserDetail(Device device){
        this.deviceId = device.getDeviceId();
        this.userId = device.getUserId();
        this.xcoord = device.getXCoord();
        this.ycoord = device.getYCoord();
        this.classCode = device.getClassCode();
    }
}
