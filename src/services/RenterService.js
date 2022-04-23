import axios from 'axios';

export default {
     getRental(){
      return axios.get('apartments');
    },

    getRentInfo(){
      return axios.get('rent');
    },

    addPayment(payment){
      return axios.post('pay_rent', payment);
    },

    getNotifications(){
      return axios.get('notification');
    },

    updateNotifications(id, notification){
      return axios.put(`notifications/${id}`, notification);
    },

    addMaintenance(maintenance){
      return axios.post(`maintenance`, maintenance);
    }

}