<template>
  <div id="all">
    <h1 id="OverallPageTitleOutsideOfTitles">
        <center>Maintenance Assignments</center>
    </h1>
    <div id="this-contains-the-entire-page-and-all-contents" class="tile is-ancestor">
        <div id="this-contains-all-tiles" class="tile is-12">
            <div id="this-contains-all-tiles-and-makes-tiles-stack-vertically" class="tile is-parent is-vertical">
                <div id="this-is-a-single-tile" class="tile is-12 is-child box">
                    <div id="this-makes-all-content-within-the-tile-stack-vertically" >
                        
                        <div id="tileID" class="tile is-vertical box" v-for="maint in this.$store.state.maintenance" v-bind:key="maint.maintenanceId">
                          <label for="maintenance-status">
                            <input type="checkbox" id="maintenance-status" name="maintenance-status" :value="maint.complete" v-model="maint.complete" @change="(updateMaintenance(maint.complete, maint.maintenanceId))" />
                            Assignment Complete</label>
                          <router-link :to="{name: 'maintenance', params: {id: maint.maintenanceId}}"><p>Date Submitted: {{maint.dateSubmitted}}</p>
                          </router-link>
                        
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
  </div>
</template>

<script>
import MaintenanceService from "../services/MaintenanceService";

export default {
    name: 'maintenance',
      methods: {
    updateMaintenance(complete, id){
      const maintenance = {complete: complete};
        MaintenanceService.update(id, maintenance)
      }
  },
  created() {
    MaintenanceService.get().then((response) => {
        this.$store.commit("SET_MAINTENANCE", response.data);
      }).catch((error) => {
        if (error.response.status == 404) {
          this.$router.push({ name: "NotFound" });
        }
      });
  
  },
};
</script>

<style>
</style>