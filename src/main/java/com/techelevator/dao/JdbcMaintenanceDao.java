package com.techelevator.dao;

import com.techelevator.model.Apartment;
import com.techelevator.model.Maintenance;
import com.techelevator.model.MaintenanceStaff;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


import java.security.Principal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Component
public class JdbcMaintenanceDao implements  MaintenanceDao {
    private JdbcTemplate jdbcTemplate;

    public JdbcMaintenanceDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public List<Maintenance> findAllMaintenance() {
        List<Maintenance> maintenance = new ArrayList<>();
        String sql = "SELECT *" +
                "FROM maintenance;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql);
        while(results.next()){
            Maintenance maintenance1 = mapRowToMaintenance(results);
            maintenance.add(maintenance1);
        }return maintenance;
    }

    @Override
    public List<Maintenance> findIncompleteMaintenance(String username) {
        List<Maintenance> maintenance = new ArrayList<>();
        String sql = "SELECT * " +
                "FROM maintenance " +
                "WHERE (complete IS null or complete = false) " +
                "AND (maint_staff_id IN (Select maint_staff_id " +
                "FROM maint_staff " +
                "WHERE staff_name = ?) or ownership_id IN (Select ownership_id " +
                "From ownership " +
                "WHERE landlord IN (SELECT user_id " +
                "FROM users " +
                "Where username = ?)))";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, username, username);
        while(results.next()){
            Maintenance maintenance1 = mapRowToMaintenance(results);
            maintenance.add(maintenance1);
        }return maintenance;
    }

    @Override
    public List<Maintenance> findMaintenanceById(Long id) {
        List<Maintenance> maintenances = new ArrayList<>();
        String sql = "SELECT * FROM maintenance WHERE maintenance_id = ?;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, id);
        while (results.next()) {
            Maintenance maintenance = mapRowToMaintenance(results);
            maintenances.add(maintenance);
        }
        return maintenances;
    }

    @Override
    public void addMaintenanceStaffToRequest(MaintenanceStaff maintenance, Long id) {
        String sql = "Update maintenance SET maint_staff_id = (SELECT maint_staff_id FROM maint_staff WHERE staff_name = ?), assigned = true WHERE maintenance_id = ?;";
        jdbcTemplate.update(sql, maintenance.getStaffName(),id);
    }

    @Override
    public void updateMaintenanceStatus(Maintenance maintenance, Long id) {
        String sql = "UPDATE maintenance SET complete = ?, new_request = false " +
                "WHERE maintenance_id = ?";
        jdbcTemplate.update(sql, maintenance.isComplete(), id);
    }

   private int getOwnershipId(String principal){
       String sql2 = "SELECT ownership_id FROM ownership WHERE renter = (SELECT user_id FROM users " +
               "WHERE username = ?";
     SqlRowSet result = jdbcTemplate.queryForRowSet(sql2, principal);
     return result.getInt("ownership_id");
   }

    @Override
    public void createMaintenanceRequest(Maintenance maintenance, Principal principal) {
        String sql = "INSERT INTO maintenance (ownership_id, maint_staff_id, description, complete," +
                "assigned, new_request)" +
                "VALUES ((SELECT ownership_id FROM ownership WHERE renter = (SELECT user_id FROM users WHERE username = ?)),null,?,false,false,true)";
        jdbcTemplate.update(sql, principal.getName(), maintenance.getDescription());
    }

    @Override
    public Apartment getAddressForMaint(Long id){
        Apartment apartment = new Apartment();
        String sql = "SELECT address_line_1, address_line_2, city, state, zip \n" +
                "from apartments\n" +
                "JOIN ownership on apartments.property_id = ownership.property_id\n" +
                "JOIN maintenance on ownership.ownership_id = maintenance.ownership_id\n" +
                "WHERE maintenance_id = ?;";

        SqlRowSet rs = jdbcTemplate.queryForRowSet(sql, id);
        if (rs.next()) {
        apartment.setAddressLine1(rs.getString("address_line_1"));
        apartment.setAddressLine2(rs.getString("address_line_2"));
        apartment.setCity(rs.getString("city"));
        apartment.setState(rs.getString("state"));
        apartment.setZip(rs.getInt("zip"));}
        return apartment;
    }

    private Maintenance mapRowToMaintenance(SqlRowSet rs){
        Maintenance maintenance = new Maintenance();
        maintenance.setMaintenanceId(rs.getLong("maintenance_id"));
        maintenance.setOwnershipId(rs.getLong("ownership_id"));
        maintenance.setMaintenanceId(rs.getLong("maint_staff_id"));
        maintenance.setDescription(rs.getString("description"));
        maintenance.setComplete(rs.getBoolean("complete"));
        maintenance.setAssigned(rs.getBoolean("assigned"));
        maintenance.setNewRequest(rs.getBoolean("new_request"));
        maintenance.setDateSubmitted(rs.getString("date_submitted"));
        return maintenance;
    }

}
