<template>
  <div class="rent-info">
    <p v-if="this.$store.state.rentInfo.pastDue">Status: Past Due</p>
    <p v-else>Status: Due</p>
    <p>Balance: {{ this.$store.state.rentInfo.balanceDue }}</p>
    <p>Monthly Rent Amount: {{ this.$store.state.rentInfo.monthlyRentAmount }}</p>
  </div>
</template>

<script>
import RenterService from "../services/RenterService.js";

export default {
  name: "rent-info",
  methods: {
    getRentInfo() {
      RenterService.getRentInfo().then((response) => {
        this.$store.commit("SET_RENT_INFO", response.data);
      });
    },
  },
  created() {
    this.getRentInfo();
  },
};

</script>

<style>
</style>