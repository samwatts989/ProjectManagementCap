package com.techelevator.model;

import org.springframework.stereotype.Component;

@Component
public class Account {

    private long accountId;
    private long ownershipId;
    private int balanceDue;
    private boolean pastDue;
    private int monthlyRentAmt;

    public Account(long accountId, long ownershipId, int balanceDue, boolean pastDue, int monthlyRentAmt) {
        this.accountId = accountId;
        this.ownershipId = ownershipId;
        this.balanceDue = balanceDue;
        this.pastDue = pastDue;
        this.monthlyRentAmt = monthlyRentAmt;
    }

    public Account(){};

    public long getAccountId() {
        return accountId;
    }

    public void setAccountId(long accountId) {
        this.accountId = accountId;
    }

    public long getOwnershipId() {
        return ownershipId;
    }

    public void setOwnershipId(long ownershipId) {
        this.ownershipId = ownershipId;
    }

    public int getBalanceDue() {
        return balanceDue;
    }

    public void setBalanceDue(int balanceDue) {
        this.balanceDue = balanceDue;
    }

    public boolean isPast_due() {
        return pastDue;
    }

    public void setPast_due(boolean pastDue) {
        this.pastDue = pastDue;
    }

    public void getMonthlyRentAmt(int monthlyRentAmt) {
        this.monthlyRentAmt = monthlyRentAmt;
    }

    public void setMonthlyRentAmt(int monthlyRentAmt) { this.monthlyRentAmt = monthlyRentAmt;}
    //---------------methods---------------------------
    public String toString() {
        return "Account{" +
                "account_id=" + accountId +
                ", ownership_id='" + ownershipId + //'\'' +
                ", balance_due='" + balanceDue + //'\'' +
                ", past_due='" + pastDue + //'\'' +
                ", monthly_rent_amt='" + monthlyRentAmt + //'\'' +
                '}';
    }
}
