package com.techelevator.dao;

import com.techelevator.model.Apartment;
import com.techelevator.model.Maintenance;
import com.techelevator.model.MaintenanceStaff;

import java.security.Principal;
import java.util.List;

public interface MaintenanceDao {

    List<Maintenance> findAllMaintenance();

    List<Maintenance> findMaintenanceById(Long id);

    void updateMaintenanceStatus(Maintenance maintenance, Long id);

    void createMaintenanceRequest(Maintenance maintenance, Principal principal);

    List<Maintenance> findIncompleteMaintenance(String username);

    void addMaintenanceStaffToRequest(MaintenanceStaff maintenance, Long id);

    Apartment getAddressForMaint(Long id);
}
