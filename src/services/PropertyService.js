import axios from 'axios';

export default {

    get(){
        return axios.get('properties');
    },

    getProperty(id){
        return axios.get(`properties/${id}`);
    },

    addProperty(property){
      return axios.post('properties', property);
    },

    deleteProperty(id){
      return axios.delete(`properties/${id}`)
    },

    update(id, property){
      return axios.put(`properties/${id}`, property)
    }
  
  }
  