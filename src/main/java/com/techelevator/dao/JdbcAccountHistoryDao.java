package com.techelevator.dao;

import com.techelevator.model.AccountHistory;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.security.Principal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Component
public class JdbcAccountHistoryDao implements AccountHistoryDao{

    private JdbcTemplate jdbcTemplate;

    public JdbcAccountHistoryDao(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }


    @Override
    public List<AccountHistory> allHistoryByLoggedOnUser(String principal) {
        List<AccountHistory> accountHistories = new ArrayList<>();
        String sql = "SELECT account_history.account_history_id, account_history.account_id, account_history.date, account_history.memo, account_history.amount, account_history.balance\n" +
                "                FROM account_history \n" +
                "                JOIN account on account_history.account_id = account.account_id\n" +
                "                JOIN ownership on account.ownership_id = ownership.ownership_id\n" +
                "                JOIN users on (ownership.landlord = users.user_id OR ownership.renter = users.user_id)\n" +
                "                WHERE users.username = ?\n" +
                "                ORDER BY account_history.account_id ASC, account_history.account_history_id ASC;";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, principal);
        while (results.next()){
            AccountHistory accountHistory = mapRowToAccountHistory(results);
            accountHistories.add(accountHistory);
        }
        return accountHistories;
    }

    @Override
    public void payRent(AccountHistory accountHistory, String username) {

        String sql1 = "UPDATE account SET balance_due = balance_due - ?, past_due = balance_due - ? > monthly_rent_amt WHERE ownership_id = (SELECT ownership_id FROM ownership WHERE renter = (SELECT user_id FROM users WHERE username = ?));;";
        jdbcTemplate.update(sql1, accountHistory.getAmount(), accountHistory.getAmount(), username);

        String sql2 = "INSERT INTO account_history(account_id, date, memo, amount, balance)\n" +
                "VALUES ((SELECT account_id FROM account WHERE ownership_id = (SELECT ownership_id FROM ownership WHERE renter = (SELECT user_id FROM users WHERE username = ?))), ?, ?, ?,(select balance_due from account where ownership_id = (SELECT ownership_id FROM ownership WHERE renter = (SELECT user_id FROM users WHERE username = ?))));";
        LocalDate date = LocalDate.parse(accountHistory.getDate());
        jdbcTemplate.update(sql2, username,date, accountHistory.getMemo(),accountHistory.getAmount(), username);
    }

    private AccountHistory mapRowToAccountHistory(SqlRowSet rs){
        AccountHistory accountHistory = new AccountHistory();
        accountHistory.setAccountHistoryId(rs.getLong("account_history_id"));
        accountHistory.setAccountId(rs.getLong("account_id"));
        accountHistory.setDate(rs.getString("date"));
        accountHistory.setMemo(rs.getString("memo"));
        accountHistory.setAmount(rs.getInt("amount"));
        accountHistory.setBalance(rs.getInt("balance"));
        return accountHistory;
    }
}
