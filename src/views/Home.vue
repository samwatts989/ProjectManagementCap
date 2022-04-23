<template>
  <div class="home">
    <div class="renter-view" v-if="this.$store.state.user.authorities[0].name === 'ROLE_RENTER'">
      <renter />
    </div>
    <div class="maintenance-view" v-else-if="this.$store.state.user.authorities[0].name === 'ROLE_STAFF'">
      <maintenance />
    </div>
    <div class="landlord-view" v-else>
      <landlord />
    </div>
  </div>
</template>

<script>
import Landlord from '../components/Landlord.vue';
import Maintenance from '../components/Maintenance.vue';
import Renter from '../components/Renter.vue'

export default {
  name: "home",
  components:  {Landlord, Renter, Maintenance}
}
</script>
