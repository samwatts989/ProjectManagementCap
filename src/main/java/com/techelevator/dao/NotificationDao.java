package com.techelevator.dao;

import com.techelevator.model.Notification;

import java.util.List;

public interface NotificationDao {

    List<Notification> findAllByUsername(String userName);

    void updateNotification(int id, Notification notification);

    void addNotification(Notification notification);

   void deleteNotification(Notification notification);

    void createRentalApplication(Notification notification, int id);
}
