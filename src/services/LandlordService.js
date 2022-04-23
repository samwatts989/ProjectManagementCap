import axios from 'axios';

export default {
     get(){
      return axios.get('/properties/available');
    },

    getMaintenance(){
        return axios.get('/maintenance/incomplete');
      },

    getRentInfo(id){
        return axios.get(`/rent/${id}`)
    },

    getRented(){
        return axios.get('/properties/rented')
    },

    create(){
        return axios.post('/properties/');
    },

    updateProperty(id, user){
        return axios.put(`/properties/${id}`, user);
    },

    deleteProperty(id){
        return axios.delete(`/properties/${id}`);
    },

    updateMaintenance(id, staff){
        return axios.put(`/maintenance/${id}/worker`, staff);
    },

    updateRenter(id, property){
        return axios.put(`/properties/renter/${id}`, property);
    },
}