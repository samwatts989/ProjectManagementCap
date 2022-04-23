package com.techelevator.model;

import org.springframework.stereotype.Component;
import org.w3c.dom.Text;

import java.time.LocalDate;
@Component
public class Maintenance {

    private Long maintenanceId;
    private Long ownershipId;
    private Long maintenanceStaffId;
    private String description;
    private boolean complete;
    private String dateSubmitted;

    public Maintenance(Long maintenanceId, Long ownershipId, Long maintenanceStaffId, String description, boolean complete, boolean assigned, boolean newRequest, String dateSubmitted) {
        this.maintenanceId = maintenanceId;
        this.ownershipId = ownershipId;
        this.maintenanceStaffId = maintenanceStaffId;
        this.description = description;
        this.complete = complete;
        this.assigned = assigned;
        this.newRequest = newRequest;
        this.dateSubmitted = dateSubmitted;
    }
    public Maintenance(){}


    // GETTERS SETTERS
    public Long getMaintenanceId() {
        return maintenanceId;
    }

    public void setMaintenanceId(Long maintenanceId) {
        this.maintenanceId = maintenanceId;
    }

    public Long getOwnershipId() {
        return ownershipId;
    }

    public void setOwnershipId(Long ownershipId) {
        this.ownershipId = ownershipId;
    }

    public Long getMaintenanceStaffId() {
        return maintenanceStaffId;
    }

    public void setMaintenanceStaffId(Long maintenanceStaffId) {
        this.maintenanceStaffId = maintenanceStaffId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isComplete() {
        return complete;
    }

    public void setComplete(boolean complete) {
        this.complete = complete;
    }

    public boolean isAssigned() {
        return assigned;
    }

    public void setAssigned(boolean assigned) {
        this.assigned = assigned;
    }

    public boolean isNewRequest() {
        return newRequest;
    }

    public void setNewRequest(boolean newRequest) {
        this.newRequest = newRequest;
    }

    private boolean assigned;
    private boolean newRequest;

    //---------------methods---------------------------
    public String toString() {
        return "Maintenance{" +
                "maintenance_id=" + maintenanceId +
                ", ownership_id='" + ownershipId + //'\'' +
                ", maint_staff_id='" + maintenanceStaffId + //'\'' +
                ", description='" + description + //'\'' +
                ", complete='" + complete + //'\'' +
                ", assigned='" + assigned + //'\'' +
                ", new_request='" + newRequest + //'\'' +
                '}';
    }


    public String getDateSubmitted() {
        return dateSubmitted;
    }

    public void setDateSubmitted(String dateSubmitted) {
        this.dateSubmitted = dateSubmitted;
    }
}
