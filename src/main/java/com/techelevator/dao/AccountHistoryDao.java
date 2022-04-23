package com.techelevator.dao;

import com.techelevator.model.AccountHistory;


import java.security.Principal;
import java.util.Date;
import java.util.List;

public interface AccountHistoryDao {

    List<AccountHistory> allHistoryByLoggedOnUser(String principal);

    void payRent(AccountHistory accountHistory, String username);

}
