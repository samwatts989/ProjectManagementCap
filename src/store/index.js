import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'
import Buefy from 'buefy'
import 'buefy/dist/buefy.css'

Vue.use(Buefy)
Vue.use(Vuex)

/*
 * The authorization header is set for axios when you login but what happens when you come back or
 * the page is refreshed. When that happens you need to check for the token in local storage and if it
 * exists you should set the header so that it will be attached to each request
 */
const currentToken = localStorage.getItem('token')
const currentUser = JSON.parse(localStorage.getItem('user'));

if(currentToken != null) {
  axios.defaults.headers.common['Authorization'] = `Bearer ${currentToken}`;
}

export default new Vuex.Store({
  state: {
    token: currentToken || '',
    user: currentUser || {},
    properties: [],
    activeProperty: {},
    renterProperty: {},
    rentedProperty: {},
    maintenance: {},
    activeMaintenance: {},
    notifications: [],
    rentInfo: {} 
  },
  mutations: {
    SET_AUTH_TOKEN(state, token) {
      state.token = token;
      localStorage.setItem('token', token);
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
    },
    SET_USER(state, user) {
      state.user = user;
      localStorage.setItem('user',JSON.stringify(user));
    },
    LOGOUT(state) {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      state.token = '';
      state.user = {};
      axios.defaults.headers.common = {};
    },
    SET_PROPERTY(state, data){
      state.properties = data;
    },
    SET_ACTIVE_PROPERTY(state, data) {
      state.activeProperty = data;
    },
    SET_RENTER_PROPERTY(state, data) {
      state.renterProperty = data;
    },
    SET_RENTED_PROPERTY(state, data) {
      state.rentedProperty = data;
    },
    SET_MAINTENANCE(state, data) {
      state.maintenance = data;
    },
    SET_ACTIVE_MAINTENANCE(state, data) {
      state.activeMaintenance = data;
    },
    SET_NOTIFICATIONS(state, data){
      state.notifications = data;
    },
    SET_RENT_INFO(state, data){
      state.rentInfo = data;
    },
    DELETE_PROPERTY(state, id) {
      state.properties = state.properties.filter((property) => {
        return property.id !== id;
      });
    },
  }
})
