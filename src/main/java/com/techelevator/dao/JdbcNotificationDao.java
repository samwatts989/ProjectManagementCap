package com.techelevator.dao;

import com.techelevator.model.Notification;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.PathVariable;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;
@Component
public class JdbcNotificationDao implements NotificationDao{

    private JdbcTemplate jdbcTemplate;

    public JdbcNotificationDao(JdbcTemplate jdbcTemplate){
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public List<Notification> findAllByUsername(String userName) {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT *\n" +
                "FROM notification\n" +
                "WHERE user_id =(Select user_id FROM users WHERE username = ? );";
        SqlRowSet results = jdbcTemplate.queryForRowSet(sql, userName);
        while (results.next()){
            Notification notification = mapRowToNotification(results);
            notifications.add(notification);
        }
        return notifications;
    }

    @Override
    public void updateNotification(int id, Notification notification) {
        String sql = "UPDATE notification\n" +
                "SET read = ?\n" +
                "WHERE notification_id = ?;";
        jdbcTemplate.update(sql,notification.isRead(),id);
    }

    @Override
    public void addNotification(Notification notification) {
        String sql = "INSERT INTO notification \n" +
                "(user_id, message, read)\n" +
                "VALUES (?, ?, FALSE);";
        jdbcTemplate.update(sql,notification.getUser_id(),notification.getMessage());
        return;
    }

    @Override
    public void createRentalApplication(Notification notification, int id) {
        String sql = "INSERT INTO notification \n" +
                "(user_id, message, read)\n" +
                "VALUES (?, ?, FALSE);";
        jdbcTemplate.update(sql,getLandlordId(id),notification.getMessage());
        return;
    }

    private int getLandlordId(int id){
        String sql = "\"SELECT ownership_id FROM ownership WHERE landlord = (SELECT user_id FROM ownership" +
                "WHERE property_id = ?";
        SqlRowSet result = jdbcTemplate.queryForRowSet(sql, id);
        return result.getInt("property_id");
    }

    @Override
    public void deleteNotification(Notification notification) {
        String sql = "DELETE \n" +
                "FROM notification\n" +
                "WHERE notification_id = ?;";
        jdbcTemplate.update(sql, notification.getNotification_id());
        return;
    }

    private Notification mapRowToNotification(SqlRowSet rs){
        Notification notification = new Notification();
        notification.setNotification_id(rs.getLong("notification_id"));
        notification.setUser_id(rs.getLong("user_id"));
        notification.setMessage(rs.getString("message"));
        notification.setRead(rs.getBoolean("read"));
        return notification;
    }



}
