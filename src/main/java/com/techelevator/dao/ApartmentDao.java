package com.techelevator.dao;

import com.techelevator.model.Apartment;
import com.techelevator.model.Notification;
import com.techelevator.model.User;


import java.security.Principal;
import java.util.List;


public interface ApartmentDao {

    List<Apartment> findAll();

    void updateApartment(Apartment apartment, Long id);

    Apartment findApartment(Long id);

    void createApartment(Apartment apartment, String username);

    void deleteApartment(Long id);

    List<Apartment> findAptForCurrentUser(String principal);

    void updatePropertyDetailsForRenter(Long id, User user);

    List<Apartment> findRentedApartments(String username);

    List<Apartment> findAllByLandlord(String username);


}
