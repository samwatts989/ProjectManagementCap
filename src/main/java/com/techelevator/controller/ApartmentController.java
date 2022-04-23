package com.techelevator.controller;

import com.techelevator.dao.ApartmentDao;
import com.techelevator.model.Apartment;
import com.techelevator.model.User;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.lang.reflect.AnnotatedParameterizedType;
import java.security.Principal;
import java.util.List;

@RestController
@CrossOrigin
@PreAuthorize("isAuthenticated()")
public class ApartmentController {
    private ApartmentDao apartmentDao;
    private Apartment apartment;

    public ApartmentController(ApartmentDao apartmentDao, Apartment apartment){
        this.apartmentDao = apartmentDao; this.apartment = apartment;
    }

    @PreAuthorize("permitAll")
    @RequestMapping(path = "/properties", method = RequestMethod.GET)
    public List<Apartment> findAll(){
        return apartmentDao.findAll();}

    @PreAuthorize("permitAll")
    @RequestMapping(path = "/properties/{id}", method = RequestMethod.GET)
    public Apartment findApartment(@PathVariable long id){
        return apartmentDao.findApartment(id);}

    @PreAuthorize("hasRole('LANDLORD')")
    @RequestMapping(path = "/properties/{id}", method = RequestMethod.PUT)
    public void updateApartment(@RequestBody Apartment apartment, @PathVariable long id){
      apartmentDao.updateApartment(apartment, id);}

    @PreAuthorize("hasRole('LANDLORD')")
    @RequestMapping(path = "/properties", method = RequestMethod.POST)
    public void createApartment(Principal principal, @RequestBody Apartment apartment){
         apartmentDao.createApartment(apartment, principal.getName());}

    @PreAuthorize("hasRole('LANDLORD')")
    @RequestMapping(path = "/properties/{id}", method = RequestMethod.DELETE)
    public void deleteApartment(@PathVariable long id){
        apartmentDao.deleteApartment(id);}

    @RequestMapping(path = "/apartments", method = RequestMethod.GET)
    public List<Apartment> findAptForCurrentUser(Principal principal){
        return apartmentDao.findAptForCurrentUser(principal.getName());}

    @PreAuthorize("hasRole('LANDLORD')")
    @RequestMapping(path = "/properties/renter/{id}", method = RequestMethod.PUT)
    public void UpdateApartmentWithRenter(@PathVariable long id, @RequestBody User user){
        apartmentDao.updatePropertyDetailsForRenter(id, user);
    }

    @PreAuthorize("hasRole('LANDLORD')")
    @RequestMapping(path = "/properties/rented", method = RequestMethod.GET)
    public List<Apartment> findRentedApartments(Principal principal){
        return apartmentDao.findRentedApartments(principal.getName());}

    @GetMapping(path = "/properties/available")
    public List<Apartment> findAllByLandlord(Principal principal){
        return apartmentDao.findAllByLandlord(principal.getName());
    }


}






