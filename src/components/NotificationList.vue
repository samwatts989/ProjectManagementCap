<template>
  <div class="notification-list">
    <div
      v-for="notification in this.$store.state.notifications"
      v-bind:key="notification.notificationId"
    >
    
    <input type="checkbox" id="notification-status" name="read" :value="notification.read" v-model="notification.read" @change="(updateNotification(notification.read, notification.notification_id))" />
    <p>{{notification.message}}</p>
    </div>
  </div>
</template>

<script>
import NotificationService from "../services/NotificationService.js";

export default {
  name: "notification-list",
  methods: {
    getNotifications() {
      NotificationService.get().then((response) => {
        this.$store.commit("SET_NOTIFICATIONS", response.data);
      });
    },
    updateNotification(read, id){
      const notification = {read: read};
        NotificationService.update(id, notification)
      }
  },
  created() {
    this.getNotifications();
  },
};
</script>

<style>
</style>