package com.techelevator.model;

import org.springframework.stereotype.Component;
import org.w3c.dom.Text;
@Component
public class Notification {

    private long notification_id;
    private long user_id;
    private String message;
    private boolean read;

    public Notification(long notification_id, long user_id, String message, boolean read) {
        this.notification_id = notification_id;
        this.user_id = user_id;
        this.message = message;
        this.read = read;
    }
    public Notification(){};

    public long getNotification_id() {
        return notification_id;
    }

    public void setNotification_id(long notification_id) {
        this.notification_id = notification_id;
    }

    public long getUser_id() {
        return user_id;
    }

    public void setUser_id(long user_id) {
        this.user_id = user_id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isRead() {
        return read;
    }

    public void setRead(boolean read) {
        this.read = read;
    }

    //---------------methods---------------------------
    public String toString() {
        return "notification{" +
                "notification_id=" + notification_id +
                ", user_id='" + user_id + //'\'' +
                ", message='" + message + //'\'' +
                ", read='" + read + //'\'' +
                '}';
    }



}
