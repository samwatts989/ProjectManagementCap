package com.techelevator.dao;

import com.techelevator.model.Account;

import java.security.Principal;
import java.util.List;

public interface AccountDao {

    List<Account> findAllAcctsByLoggedOnUser(String principal);



}
