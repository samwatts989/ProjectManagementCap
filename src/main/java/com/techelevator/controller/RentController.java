package com.techelevator.controller;

import com.techelevator.dao.RentDao;
import com.techelevator.model.Apartment;
import com.techelevator.model.Rent;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;

@RestController
@CrossOrigin
@PreAuthorize("isAuthenticated()")
public class RentController {
 private RentDao rentDao;
 private Rent rent;

 public RentController(RentDao rentDao, Rent rent){
     this.rentDao = rentDao; this.rent = rent;
    }

    @RequestMapping(path = "/rent", method = RequestMethod.GET)
    public Rent findRent(Principal principal){
        return rentDao.findRentDueByRenterId(principal.getName());}

    @RequestMapping(path = "/rent/{id}", method = RequestMethod.PUT)
    public void updateRent(@RequestBody Rent rent, @PathVariable long id){
        rentDao.updateRent(rent, id);}

    @RequestMapping(path = "/rent/{id}", method = RequestMethod.DELETE)
    public void deleteRentalAccount(@PathVariable long id){
        rentDao.deleteRentalAccount(id);}

    @RequestMapping(path = "/rent/{id}", method = RequestMethod.GET)
    public Rent findRentById(Principal principal, @PathVariable int id){
        return rentDao.findRentDueByPropertyId(principal.getName(), id);}
}
