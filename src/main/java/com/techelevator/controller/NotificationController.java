package com.techelevator.controller;

import com.techelevator.dao.NotificationDao;
import com.techelevator.model.Notification;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@RestController
@CrossOrigin
@PreAuthorize("isAuthenticated()")

public class NotificationController {
    private NotificationDao notificationDao;
    private Notification notification;

    public NotificationController(Notification notification,NotificationDao notificationDao){
        this.notificationDao = notificationDao; this.notification = notification;
    }

    @RequestMapping(path = "/notification", method = RequestMethod.GET)
        public List<Notification> findAllByUsername(Principal principal){
        return notificationDao.findAllByUsername(principal.getName());
    }

    @RequestMapping(path = "/notification", method = RequestMethod.POST)
    public void addNotification(@RequestBody  Notification notification){
         notificationDao.addNotification(notification);
    }

    @RequestMapping(path = "/notification/{id}", method = RequestMethod.PUT)
    public void updateNotification( @PathVariable int id, @RequestBody Notification notification){
        notificationDao.updateNotification(id, notification);
    }

    @RequestMapping(path = "/notification", method = RequestMethod.DELETE)
    public void deleteNotification( @RequestBody Notification notification){
        notificationDao.deleteNotification(notification);
    }

    @RequestMapping(path = "/rental/application/{id}", method = RequestMethod.POST)
    public void createRentalApplication (@RequestBody  Notification notification, @PathVariable int id){
        notificationDao.createRentalApplication(notification, id);
    }
}
