package com.techelevator.model;

import org.springframework.stereotype.Component;

import java.util.List;
@Component
public class MaintenanceStaff {

    private long maintStaffId;
    private long staffUserId;
    private String staffName;
    private String serviceDept;

    public MaintenanceStaff(long maintStaffId, long staffUserId, String staffName, String serviceDept) {
        this.maintStaffId = maintStaffId;
        this.staffUserId = staffUserId;
        this.staffName = staffName;
        this.serviceDept = serviceDept;
    }

    public MaintenanceStaff(){};

    public long getMaintStaffId() {
        return maintStaffId;
    }

    public void setMaintStaffId(long maintStaffId) {
        this.maintStaffId = maintStaffId;
    }

    public long getStaffUserId() {
        return staffUserId;
    }

    public void setStaffUserId(long staffUserId) {
        this.staffUserId = staffUserId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getServiceDept() {
        return serviceDept;
    }

    public void setServiceDept(String serviceDept) {
        this.serviceDept = serviceDept;
    }

    //---------------methods---------------------------
    public String toString() {
        return "MaintenanceStaff{" +
                "maint_staff_id=" + maintStaffId +
                ", staff_user_id='" + staffUserId + //'\'' +
                ", staff_name='" + staffName + //'\'' +
                ", service_dept='" + serviceDept + //'\'' +
                '}';
    }

}
