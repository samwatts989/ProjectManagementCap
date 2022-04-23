import axios from 'axios';

export default {
     get(){
      return axios.get('/maintenance/incomplete');
    },

    getById(id){
        return axios.get(`/maintenance/${id}`)
    },

    getAddressForMaintenance(id){
        return axios.get(`/maintenance/${id}/address`)
    },

    update(id, maintenance){
        return axios.put(`/maintenance/${id}`, maintenance)
    }
}

