package com.techelevator.dao;

import com.techelevator.model.Rent;

public interface RentDao {
    /**
     * Rent findRentDue(id)
     *
     * void updateRent(rent, id)
     * @param id
     */
    Rent findRentDueByRenterId(String id);

    void updateRent(Rent rent, long id);

    Rent findRentDueByPropertyId(String username, int id);

    void deleteRentalAccount(long id);

}
