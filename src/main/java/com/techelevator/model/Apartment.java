package com.techelevator.model;


import org.springframework.stereotype.Component;

import java.time.LocalDate;

@Component
public class Apartment {

    private Long propertyId;
    private String addressLine1;
    private String addressLine2;
    private String city;
    private String state;
    private int zip;
    private Double price;
    private String picture;
    private double numBedrooms;
    private double numBathrooms;
    private Integer squareFeet;
    private String shortDescription;
    private String longDescription;
    private String dateAvailable;
    private boolean availableForRent; // YYYY-mm-dd

    public Apartment(Long propertyId, String addressLine1,String addressLine2, String city, String state, int zip, Double price, String picture, double numBedrooms, double numBathrooms, Integer squareFeet, String shortDescription, String longDescription, String dateAvailable, boolean availableForRent) {
        this.propertyId = propertyId;
        this.addressLine1 = addressLine1;
        this.addressLine2 = addressLine2;
        this.city = city;
        this.state = state;
        this.zip = zip;
        this.price = price;
        this.picture = picture;
        this.numBedrooms = numBedrooms;
        this.numBathrooms = numBathrooms;
        this.squareFeet = squareFeet;
        this.shortDescription = shortDescription;
        this.longDescription = longDescription;
        this.dateAvailable = dateAvailable;
        this.availableForRent = availableForRent;
    }

    public Apartment() {

    }

    //-----------getters------------------------------

    public Long getPropertyId() {
        return propertyId;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public String getAddressLine2() {
        return addressLine2;
    }

    public String getCity() {
        return city;
    }

    public String getState() {
        return state;
    }

    public int getZip() {
        return zip;
    }

    public Double getPrice() {
        return price;
    }

    public String getPicture() {
        return picture;
    }

    public double getNumBedrooms() {
        return numBedrooms;
    }

    public double getNumBathrooms() {
        return numBathrooms;
    }

    public Integer getSquareFeet() {
        return squareFeet;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public String getLongDescription() {
        return longDescription;
    }

    public String getDateAvailable() {
        return dateAvailable;
    }

    public boolean isAvailableForRent() {return availableForRent;}


    //-------------------------------setters

    public void setAvailableForRent(boolean availableForRent) {this.availableForRent = availableForRent;}

    public void setPropertyId(Long propertyId) {
        this.propertyId = propertyId;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public void setNumBedrooms(double numBedrooms) {
        this.numBedrooms = numBedrooms;
    }

    public void setNumBathrooms(double numBathrooms) {
        this.numBathrooms = numBathrooms;
    }

    public void setSquareFeet(Integer squareFeet) {
        this.squareFeet = squareFeet;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public void setLongDescription(String longDescription) {
        this.longDescription = longDescription;
    }

    public void setDateAvailable(String dateAvailable) {
        this.dateAvailable = dateAvailable;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public void setState(String state) {
        this.state = state;
    }

    public void setZip(int zip) {
        this.zip = zip;
    }

    //---------------methods---------------------------
    public String toString() {
        return "Apartment{" +
                "property_id=" + propertyId +
                ", address_line_1='" + addressLine1 + //'\'' +
                ", address_line_2='" + addressLine2 + //'\'' +
                ", city='" + city + //'\'' +
                ", state='" + state + //'\'' +
                ", zip='" + zip + //'\'' +
                ", price='" + price + //'\'' +
                ", picture='" + picture + //'\'' +
                ", available='" + dateAvailable + //'\'' +
                ", num_bathrooms=" + numBathrooms +
                ", num_bedrooms=" + numBedrooms +
                ", square_feet=" + squareFeet + //'\'' +
                ", short_description=" + shortDescription +
                ", long_description=" + longDescription +
                ", available_for_rent=" + availableForRent +
                '}';
    }


}
