package com.techelevator.controller;

import com.techelevator.dao.MaintenanceStaffDao;
import com.techelevator.model.MaintenanceStaff;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin
@PreAuthorize("isAuthenticated()")
public class MaintenanceStaffController {

    private MaintenanceStaffDao maintenanceStaffDao;
    private MaintenanceStaff maintenaceStaff;

    public MaintenanceStaffController(MaintenanceStaffDao maintenanceStaffDao,
                                      MaintenanceStaff maintenaceStaff) {
        this.maintenanceStaffDao = maintenanceStaffDao;
        this.maintenaceStaff = maintenaceStaff;
    }

    @RequestMapping(value = "/maintstaff", method = RequestMethod.GET)
    public List<MaintenanceStaff> findAll(){
        return maintenanceStaffDao.findAll();}

    @RequestMapping(value = "/maintstaff/{svcDept}", method = RequestMethod.GET)
    public List<MaintenanceStaff> findAllBySvcDept(@PathVariable String svcDept){
        return maintenanceStaffDao.findAllBySvcDept(svcDept);}
}
