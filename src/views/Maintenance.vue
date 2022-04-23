<template>
  
  <div id="all">
    <h1 id="OverallPageTitleOutsideOfTitles" class="page-title">
        <center>Maintenance Assignment Detail</center>
    </h1>
    <div id="this-contains-the-entire-page-and-all-contents" class="tile is-ancestor">
        <div id="this-contains-all-tiles" class="tile is-12">
            <div id="this-contains-all-tiles-and-makes-tiles-stack-vertically" class="tile is-parent is-vertical">
                <div id="this-is-a-single-tile" class="tile is-12 is-child box">
                    <div id="this-makes-all-content-within-the-tile-stack-vertically" class="tile is-vertical">
                        <p id="this-automatically-formats-to-be-a-title-in-buefy" class="assignment-title" >
                            Maintenance Assignment:
                        </p>
                        <p id="this-is-example-text-information" class="assignment">
                            <maintenance-info />
                        </p>
                    </div>
                </div>
                
            </div>
        </div>
    </div>
</div>
</template>

<script>
import MaintenanceInfo from '../components/MaintenanceInfo.vue'
export default {
    name: 'maintenance',
  components: { MaintenanceInfo },

}
</script>

<style>
.assignment{
  font-size: large;
}

.assignment-title{
  font-size: x-large;
}
.page-title{
  font-size: xx-large;
}
</style>