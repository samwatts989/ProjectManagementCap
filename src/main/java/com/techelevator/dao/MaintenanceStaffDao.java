package com.techelevator.dao;

import com.techelevator.model.MaintenanceStaff;

import java.util.List;

public interface MaintenanceStaffDao {

    List<MaintenanceStaff> findAll();

    List<MaintenanceStaff> findAllBySvcDept(String svcDept);
}
