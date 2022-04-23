package com.techelevator.dao;

import com.techelevator.model.Account;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

@Component
public class JdbcAccountDao implements AccountDao {

        private JdbcTemplate jdbcTemplate;

    public JdbcAccountDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public List<Account> findAllAcctsByLoggedOnUser(String principal) {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT account_id, account.ownership_id, balance_due, past_due, monthly_rent_amt\n" +
                "FROM account\n" +
                "JOIN ownership on account.ownership_id = ownership.ownership_id\n" +
                "JOIN users on (ownership.landlord = users.user_id OR ownership.renter = users.user_id)\n" +
                "WHERE users.username = ?;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, principal);
        while (results.next()){
            Account account = mapRowToAccount(results);
            accounts.add(account);
        }
        return accounts;
    }



    private Account mapRowToAccount(SqlRowSet rs){
        Account account = new Account();
        account.setAccountId(rs.getLong("account_id"));
        account.setOwnershipId(rs.getLong("ownership_id"));
        account.setBalanceDue(rs.getInt("balance_due"));
        account.setMonthlyRentAmt(rs.getInt("monthly_rent_amt"));
        return account;
    }

}
