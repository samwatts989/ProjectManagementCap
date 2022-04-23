package com.techelevator.dao;

import com.techelevator.model.MaintenanceStaff;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class JdbcMaintenanceStaffDao implements  MaintenanceStaffDao{
    private JdbcTemplate jdbcTemplate;

    public JdbcMaintenanceStaffDao(JdbcTemplate jdbcTemplate){
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public List<MaintenanceStaff> findAll() {
        List<MaintenanceStaff> maintenanceStaffs = new ArrayList<>();
        String sql = "SELECT *\n" +
                "From maint_staff;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql);
        while(results.next()){
            MaintenanceStaff maintenaceStaff = mapRowToMaintenanceStaff(results);
            maintenanceStaffs.add(maintenaceStaff);
        }
        return maintenanceStaffs;
    }

    @Override
    public List<MaintenanceStaff> findAllBySvcDept(String svcDept) {
        List<MaintenanceStaff> maintenanceStaffs = new ArrayList<>();
        String sql = "SELECT *\n" +
                "FROM maint_staff\n" +
                "WHERE service_dept = ?;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, svcDept);
        while(results.next()){
            MaintenanceStaff maintenaceStaff = mapRowToMaintenanceStaff(results);
            maintenanceStaffs.add(maintenaceStaff);
        }
        return maintenanceStaffs;
    }

    private MaintenanceStaff mapRowToMaintenanceStaff(SqlRowSet rs){
        MaintenanceStaff maintenanceStaff = new MaintenanceStaff();
        maintenanceStaff.setMaintStaffId(rs.getLong("maint_staff_id"));
        maintenanceStaff.setStaffUserId(rs.getLong("staff_user_id"));
        maintenanceStaff.setStaffName(rs.getString("staff_name"));
        maintenanceStaff.setServiceDept(rs.getString("service_dept"));

        return maintenanceStaff;
    }
}
