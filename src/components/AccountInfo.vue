<template>
  <div>
    <div class="account-info">
      <p v-if="this.rentInf.pastDue">Status: Past Due</p>
      <p v-else>Status: Due</p>
      <p>Monthly Rent Amount: {{ this.rentInf.monthlyRentAmount }}</p>
    </div>
  </div>
</template>

<script>
import LandlordService from "../services/LandlordService.js";

export default {
  name: "account-info",
  props: {
    id: Number,
  },
  data() {
    return {
      rentInf: {},
    };
  },
  created() {
    LandlordService.getRentInfo(this.id).then((response) => {
      this.rentInf = response.data;
    });
  },
};
</script>

<style>
</style>