<template>
<div>
     <h1 class="titleAbout">About Us</h1>
    <div class="about-us">
     
    <div id="Sam" class="container">
      
      <p><b>Sam Watts</b></p>
      <p>“Hi I’m Sam and when I'm not doing tech sprints, I love regular running, taking my dog to the beach, and lobster diving.”</p>
      <br>
      <img src='../AboutUsPictures/SamWatts.jpg' />
        </div><div id="Maddie" class="container">
      <p><b>Maddie Meyers</b></p>
      <p>"Hello! I'm an aspiring accordion player and newly minted developer; I love cutting-edge technology like machine learning and AI, as well as snowboarding and dogs!"</p>
                  <br>

      <img src='..\AboutUsPictures\Maddie.png' />
      </div> <div id="Kevin" class="container">
      <p><b>Kevin McGoldrick</b></p>
      <p>"As a newly minted graduate of Tech Elevator’s National Live Remote Java Bootcamp, I look forward to starting a rewarding career as a software developer. What I love about coding, is the continuous learning and applying of concepts to make things work."</p>
                   <br>

        <img src='../AboutUsPictures/Kevin.jpg' />
        </div><div id="Yehudis" class="container">
      <p><b>Yehudis Sebbag</b></p>
      <p>Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit</p>
                    <br>

        <img src='../AboutUsPictures/Yehudis.jpeg' />
              <br>
        </div><div id="Zach" class="container">
    <p><b>Zach Snyder</b></p>
    <p>"I previously worked 6 years in Data Quality & was intrigued by how powerful creating scripts was compared to manual changes.  I've always enjoyed playing chess and working through analytical problems.  Tech Elevator has greatly helped with prepare me to begin my new journey as a Junior Developer."</p>
                  <br>

        <img src='../AboutUsPictures/ZachPicture.jpg' />
        </div>
        </div>
    </div>
  
</template>


<script>
export default {
  name: "about-us",
  methods: {
   }
}
</script>

<style scoped>

.titleAbout {
    font-style:italic;
    font-size:30px;
    display: flexbox;
    text-align: center;
    align-items: center;

}

img {
    border-radius: 15px;
}
.container {
    margin: 20px;
    width: 20rem;
}
img {
    width: 300px;
    height: 325px;
}

.about-us {
    display: inline-flex;
    align-items: center;
    margin: 20px;
    width: auto;
}
</style>
