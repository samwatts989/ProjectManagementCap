<template>
  <!-- Renter:  Will want rental information (if renting) and maintenance request info, browsing properties-->
  <div>


    <h1 id="OverallPageTitleOutsideOfTitles">
        <center>My Account</center>
    </h1>
    <div id="this-contains-the-entire-page-and-all-contents" class="tile is-ancestor">
        <div id="this-contains-all-tiles" class="tile is-6">
            <div id="this-contains-all-tiles-and-makes-tiles-stack-vertically" class="tile is-parent is-vertical">
                <div id="this-is-a-single-tile" class="tile is-12 is-child box">
                    <div id="this-makes-all-content-within-the-tile-stack-vertically" class="tile is-vertical">
                        <p id="this-automatically-formats-to-be-a-title-in-buefy" class="title">
                            <b>Rent Status</b>
                        </p>
                        <p id="this-is-example-text-information">
                            
    <div
      class="rental-property-info"
      v-for="property in this.$store.state.renterProperty"
      v-bind:key="property.propertyId"
    >
      <h1>
        <b>Address:</b><br> {{ property.addressLine1 }}<br>
        {{ property.addressLine2 }}
        {{ property.city }},
        {{ property.state }}
        {{ property.zip }}
      </h1>
    </div>
    <rent-info />

    <div class="payment-form">
      <form v-on:submit.prevent>
        <div class="field">
          <p><b>Payment Form:</b></p>
          <label for="date">Date:</label>
          <input type="date" name="date" id="date" v-model="payment.date" />
          <label for="amount">Amount:</label>
          <input
            type="text"
            name="amount"
            id="amount"
            v-model="payment.amount"
          />
        </div>
        
        <div class="actions">
          <button type="submit" v-on:click="savePayment()" @click="resetPayment">
            Submit Payment
          </button>
        </div>
      </form>
    </div>

                        
                    </div>
                </div>
                <div id="this-is-a-single-tile" class="tile is-12 is-child box">
                    <div id="this-makes-all-content-within-the-tile-stack-vertically" class="tile is-vertical">
                        <p id="this-automatically-formats-to-be-a-title-in-buefy" class="title">                
                            Account Messages        
                        </p>
                        <p id="this-is-example-text-information">
                           
    <div class="notifications">
      <p>Notification List:</p>
      Mark as read: <notification-list />
    </div>
                                           
                    </div>
                </div>
<div id="this-is-a-single-tile" class="tile is-12 is-child box">
                    <div id="this-makes-all-content-within-the-tile-stack-vertically" class="tile is-vertical">
                        <p id="this-automatically-formats-to-be-a-title-in-buefy" class="title">                
                            Submit Maintenance Request        
                        </p>
                        <p id="this-is-example-text-information">
                           
     <div class="maintenance-form">
      <form v-on:submit.prevent>
        <div class="field">
          <!-- <label for="maintenance-type">Maintenance Type</label>
          <select name="maintenance-type" id="maintenance-type" v-model="maintenance.type">
            <option value="plumber">Plumber</option>
            <option value="appliances">Appliances</option>
            <option value="heating-and-cooling">Heating and Cooling</option>
          </select> -->
          <p>Maintenance Request:</p>
          <label for="problem-description">Problem Description</label>
          <input type="text" v-model="maintenance.description" />
        </div>
        <div class="actions">
          <button type="submit" v-on:click="saveMaintenance()" @click="resetMaintenance">
            Submit Maintenance Request
          </button>
        </div>
      </form>
    </div>
                                           
                    </div>
                </div>

            </div>
        </div>
    </div>







   
  </div>
</template>



<script>
import RenterService from "../services/RenterService";
import NotificationList from "../components/NotificationList.vue";
import RentInfo from "./RentInfo.vue";

export default {
  name: "renter-details",
  props: ["rented"],
  components: { NotificationList, RentInfo },
  data() {
    return {
      maintenance: {
        description: "",
      },
      payment: {
        amount: "",
        memo: "",
        date: "",
      },
    };
  },
  methods: {
    saveMaintenance() {
      RenterService.addMaintenance(this.maintenance)
    },
    savePayment() {
      const payment = {amount: this.payment.amount, memo: this.payment.memo, date: this.payment.date}
      RenterService.addPayment(payment)
    },
    resetPayment(){
      this.payment = {};
      location.reload()
    },
      resetMaintenance(){
      this.maintenance = {};
      location.reload()
    }
  },
  created() {
    RenterService.getRental()
      .then((response) => {
        this.$store.commit("SET_RENTER_PROPERTY", response.data);
      })
      .catch((error) => {
        if (error.response.status == 404) {
          this.$router.push({ name: "NotFound" });
        }
      });
  },
};
</script>

<style>
#this-makes-all-content-within-the-tile-stack-vertically{
  align-content: left ;
}


</style>