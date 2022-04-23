package com.techelevator.model;

import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.Date;

@Component
public class AccountHistory {

    private Long accountHistoryId;
    private Long accountId;
    private String date;
    private String memo;
    private int amount;
    private int balance;

    public AccountHistory(Long accountHistoryId, Long accountId, String date, String memo, int amount, int balance) {
        this.accountHistoryId = accountHistoryId;
        this.accountId = accountId;
        this.date = date;
        this.memo = memo;
        this.amount = amount;
        this.balance = balance;
    }
    public AccountHistory(){};

    public Long getAccountHistoryId() {
        return accountHistoryId;
    }

    public void setAccountHistoryId(Long accountHistoryId) {
        this.accountHistoryId = accountHistoryId;
    }

    public Long getAccountId() {
        return accountId;
    }

    public void setAccountId(Long accountId) {
        this.accountId = accountId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getMemo() {
        return memo;
    }

    public void setMemo(String memo) {
        this.memo = memo;
    }

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public int getBalance() {
        return balance;
    }

    public void setBalance(int balance) {
        this.balance = balance;
    }

    //---------------methods---------------------------
    public String toString() {
        return "account_history{" +
                "account_history_id=" + accountHistoryId +
                ", account_id='" + accountId + //'\'' +
                ", date='" + date + //'\'' +
                ", memo='" + memo + //'\'' +
                ", amount='" + amount + //'\'' +
                ", balance='" + balance + //'\'' +
                '}';
    }

}
