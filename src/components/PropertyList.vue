<template>



<div id="all">
    <h1 id="OverallPageTitleOutsideOfTitles">
        <center>Rentals Currently Available</center>
    </h1>
    <div id="this-contains-the-entire-page-and-all-contents" class="tile is-ancestor">
  
            <div id="this-contains-all-tiles-and-makes-tiles-stack-vertically" class="tile is-parent is-vertical">
                <div id="this-is-a-single-tile" class="tile">
                  
                      <div id="tileID" class="tile is-vertical box" v-for="property in this.$store.state.properties" v-bind:key="property.propertyId">
                        <img v-bind:src="property.picture" />
                         <div id="propertyInfo">
                              <h1><router-link :to="{name: 'property-info', params: {id: property.propertyId}}">Address: {{property.addressLine1}} {{property.city}} {{property.state}} {{property.zip}}</router-link></h1>
                             <p> Date Available: {{property.dateAvailable}}, ${{property.price}}</p>
                              <p>Bed: {{property.numBedrooms}} Bath: {{property.numBathrooms}} {{property.squareFeet}}sqft</p>
                               <p>Description: {{property.shortDescription}}</p>
                         </div>
                    





                    </div>
                </div>
                <div id="this-is-a-single-tile" class="tile is-12 is-child box">
                  <p>
                    Interested? Please contact us at actuallydon't@fakeemail.com or at 867-5309 today!
                    </p>
                </div>
            </div>
      
    </div>
</div>




<!--

  <div class="property-list column">

  </div>
  -->
 
</template>

<script>
import PropertyService from '../services/PropertyService.js'
export default {
    name: "property-list",
    methods: {
        getProperties(){
            PropertyService.get().then(response => {
                this.$store.commit("SET_PROPERTY", response.data)
            })
        },
        deleteProperty(id) {
            PropertyService.delete(id).then((response) => {
             if (response.status == 200){
            this.$store.commit("DELETE_PROPERTY", id);
        }
      })
    }
    },
    created(){
        this.getProperties();
    }

};
</script>

<style>

#tileID {
  margin: 20px;
  display:flex;
  flex-wrap:wrap;
  min-width:300px;
}

#this-is-a-single-tile {
  display:flex;
  flex-wrap:wrap;
}

#OverallPageTitleOutsideOfTitles {
  font-size: 30px;
}



</style>
