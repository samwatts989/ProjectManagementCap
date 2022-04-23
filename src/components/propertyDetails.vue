<template>



<div id="all">

    <div id="this-contains-the-entire-page-and-all-contents" class="tile is-ancestor">
        <div id="this-contains-all-tiles" class="tile is-8">
            <div id="this-contains-all-tiles-and-makes-tiles-stack-vertically" class="tile is-parent is-vertical">
                <div id="this-is-a-single-tile" class="tile is-12 is-child box">
                    <div id="this-makes-all-content-within-the-tile-stack-vertically" class="tile is-vertical">
                        <p id="this-automatically-formats-to-be-a-title-in-buefy" class="title">
                                Address: {{this.$store.state.activeProperty.addressLine1}} {{this.$store.state.activeProperty.addressLine2}} {{this.$store.state.activeProperty.city}} {{this.$store.state.activeProperty.state}} {{this.$store.state.activeProperty.zip}}

                        </p>




  <div>
    <div>
        <!-- <img v-bind:src="property.picture" v-bind:alt="property.address1" /> -->
         <img v-bind:src="this.$store.state.activeProperty.picture"/>
      <p> Date Available: {{this.$store.state.activeProperty.dateAvailable}}, ${{this.$store.state.activeProperty.price}}</p>
      <p>Bed: {{this.$store.state.activeProperty.numBedrooms}} Bath: {{this.$store.state.activeProperty.numBathrooms}} {{this.$store.state.activeProperty.squareFeet}}sqft</p>
      <p>Description: {{this.$store.state.activeProperty.longDescription}}</p>
       
    </div>
      <!-- contact realtor button -->
  </div>






                    </div>
                </div>
                <div id="this-is-a-single-tile" class="tile is-12 is-child box">
                    <div id="this-makes-all-content-within-the-tile-stack-vertically" class="tile is-vertical">
                        <p id="this-is-example-text-information">
                            Interested in this property? Please contact our sales team TODAY at 867-5309, we are looking forward to serving you! 
                        </p>                        
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


</template>









<script>
import PropertyService from '../services/PropertyService'
export default {
    name: "property-details",
    methods: {},
    created(){
      PropertyService.getProperty(this.$route.params.id).then(response => {
        this.$store.commit("SET_ACTIVE_PROPERTY", response.data)
      }).catch(error => {
        if (error.response.status == 404){
          this.$router.push({name: 'NotFound'})
        }
      })
    }

}
</script>

<style>

#this-contains-all-tiles {
  margin: auto;
  text-align: center;
}

</style>

