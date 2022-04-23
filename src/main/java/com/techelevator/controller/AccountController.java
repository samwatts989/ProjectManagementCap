package com.techelevator.controller;

import com.techelevator.dao.AccountDao;
import com.techelevator.model.Account;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.List;

@RestController
@CrossOrigin
@PreAuthorize("isAuthenticated()")
public class AccountController {
    private AccountDao accountDao;
    private Account account;

    public AccountController(AccountDao accountDao, Account account) {
        this.accountDao = accountDao;
        this.account = account;
    }

    @RequestMapping(path = "/account", method = RequestMethod.GET)
    public List<Account> findAllAcctsByLoggedOnUser(Principal principal){
        return accountDao.findAllAcctsByLoggedOnUser(principal.getName());
    }
}
