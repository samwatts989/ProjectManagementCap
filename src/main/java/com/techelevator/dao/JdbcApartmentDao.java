package com.techelevator.dao;

import com.techelevator.model.Apartment;
import com.techelevator.model.User;
import org.springframework.cglib.core.Local;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Component //anytime that a ApartmentDao gets injected, create an object of JdbcApartmentDao to use
public class JdbcApartmentDao implements ApartmentDao {

    private JdbcTemplate jdbcTemplate;

    public JdbcApartmentDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public List<Apartment> findAll() {
        List<Apartment> apartments = new ArrayList<>();
        String sql = "SELECT * FROM apartments WHERE available_for_rent = TRUE ;";

        SqlRowSet results = jdbcTemplate.queryForRowSet(sql);
        while (results.next()) {
            Apartment apartment = mapRowToApartment(results);
            apartments.add(apartment);
        }
        return apartments;
    }
    @Override
    public void createApartment(Apartment apartment, String username){
        String sql = "INSERT INTO apartments (landlord, address_line_1, address_line_2, city, " +
                "state, zip, price, picture, available, num_bedrooms, " +
                "num_bathrooms, square_feet, short_description, long_description, available_for_rent) " +
                "VALUES ((SELECT user_id FROM users WHERE username = ?),?,?,?,?,?,?,?,?,?,?,?,?, ?, ?) RETURNING property_id;";
        LocalDate lt = LocalDate.parse(apartment.getDateAvailable());
        int result = jdbcTemplate.queryForObject(sql, int.class, username, apartment.getAddressLine1(), apartment.getAddressLine2(),
                apartment.getCity(), apartment.getState(), apartment.getZip(), apartment.getPrice(),
                apartment.getPicture(), lt, apartment.getNumBedrooms(),
                apartment.getNumBathrooms(), apartment.getSquareFeet(), apartment.getShortDescription(),
                apartment.getLongDescription(), apartment.isAvailableForRent());
       String sql2 = "INSERT INTO ownership (property_id, landlord, renter) VALUES (?, (SELECT user_id FROM users WHERE username = ?),null)";
        jdbcTemplate.update(sql2, result,username);
    }
    @Override
    public Apartment findApartment(Long propertyId){
      Apartment apartment = new Apartment();
        String sql = "SELECT * FROM apartments WHERE property_id = ?;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, propertyId);
        if(results.next()){
           apartment = mapRowToApartment(results);
        }return apartment;
    }

    @Override
    public List<Apartment> findAllByLandlord(String username) {
        List<Apartment> apartments = new ArrayList<>();
        String sql = "SELECT * FROM apartments WHERE available_for_rent = true AND landlord IN " +
                "(SELECT user_id FROM users where username = ?);";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, username);
        while (results.next()) {
            Apartment apartment = mapRowToApartment(results);
            apartments.add(apartment);
        }
        return apartments;
    }

    public List<Apartment> findAptForCurrentUser(String principal){
        List<Apartment> apartments = new ArrayList<>();
        String sql = "SELECT * FROM apartments WHERE property_id in (SELECT property_id \n" +
                "FROM ownership WHERE landlord in (SELECT user_id FROM users WHERE username = ?) \n" +
                "or renter in (SELECT user_id FROM users WHERE username = ?) )";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, principal,principal);
        while(results.next()){
            Apartment apartment = mapRowToApartment(results);
            apartments.add(apartment);
        }return apartments;
    }

    @Override
    public void updatePropertyDetailsForRenter(Long id, User user) {
        String sql = "UPDATE apartments SET available = null, available_for_rent = false " +
                "WHERE property_id = ?;";
        jdbcTemplate.update(sql, id);

        String sql2 = "UPDATE ownership SET renter = ? WHERE property_id = ?";
        jdbcTemplate.update(sql, user.getId(), id);

        String sql3 = "INSERT INTO account (ownership_id, balance_due, monthly_rent_amt, past_due) VALUES " +
                "((SELECT ownership_id FROM ownership WHERE property_id = ?), 0, (SELECT price FROM apartments WHERE property_id = ?), false)";
        jdbcTemplate.update(sql, id, id);
    }

    //for landlord - make sure when adding property to inserty new connection in ownership table

    //landlord is principal.getname
    //renter is given
    //property Id is path variable
    @Override
    public void updateApartment(Apartment apartment, Long id) {
        String sql = "UPDATE apartments SET address_line_1 = ?, address_line_2 = ?, city = ?," +
                "state = ?, zip = ?, price = ?, picture = ?, available = ?, num_bedrooms = ?," +
                "num_bathrooms = ?, square_feet = ?, short_description = ?, long_description = ?" +
                "WHERE property_id =?; ";
        LocalDate lt = LocalDate.parse(apartment.getDateAvailable());
        jdbcTemplate.update(sql, apartment.getAddressLine1(), apartment.getAddressLine2(),
                apartment.getCity(), apartment.getState(), apartment.getZip(), apartment.getPrice(),
                apartment.getPicture(), lt, apartment.getNumBedrooms(),
                apartment.getNumBathrooms(), apartment.getSquareFeet(), apartment.getShortDescription(),
                apartment.getLongDescription(), id);
    }

    public  void deleteApartment(Long propertyId){
        String sql2 = "DELETE\n" +
                "FROM ownership\n" +
                "WHERE property_id = ?;";
        jdbcTemplate.update(sql2, propertyId);

        String sql = "DELETE\n" +
                "FROM apartments\n" +
                "WHERE property_id = ?;";
        jdbcTemplate.update(sql, propertyId);
    }

    @Override
    public List<Apartment> findRentedApartments(String username) {
        List<Apartment> apartments = new ArrayList<>();
        String sql = "SELECT * FROM apartments WHERE available_for_rent = false AND property_id in (SELECT property_id " +
                "                FROM ownership WHERE landlord in (SELECT user_id FROM users WHERE username = ?) )";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, username);
        while (results.next()) {
            Apartment apartment = mapRowToApartment(results);
            apartments.add(apartment);
        }
        return apartments;
    }


    private Apartment mapRowToApartment(SqlRowSet rs) {
        Apartment apartment = new Apartment();
        apartment.setPropertyId(rs.getLong("property_id"));
        apartment.setAddressLine1(rs.getString("address_line_1"));
        apartment.setAddressLine2(rs.getString("address_line_2"));
        apartment.setCity(rs.getString("city"));
        apartment.setState(rs.getString("state"));
        apartment.setZip(rs.getInt("zip"));
        apartment.setPrice(rs.getDouble("price"));
        apartment.setPicture(rs.getString("picture"));
        apartment.setDateAvailable(rs.getString("available"));
        apartment.setNumBedrooms(rs.getDouble("num_bedrooms"));
        apartment.setNumBathrooms(rs.getDouble("num_bathrooms"));
        apartment.setSquareFeet(rs.getInt("square_feet"));
        apartment.setShortDescription(rs.getString("short_description"));
        apartment.setLongDescription(rs.getString("long_description"));
        apartment.setAvailableForRent(rs.getBoolean("available_for_rent"));
        return apartment;
    }
}
