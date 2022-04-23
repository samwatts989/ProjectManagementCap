<template>
<div id="all">
    
    <h1 id="OverallPageTitleOutsideOfTitles">
        <center>Title Here</center>
    </h1>
    <div id="this-contains-the-entire-page-and-all-contents" class="tile is-ancestor">
        <div id="this-contains-all-tiles" class="tile is-12">
            <div id="this-contains-all-tiles-and-makes-tiles-stack-vertically" class="tile is-parent is-vertical">
                <div id="this-is-a-single-tile" class="tile is-12 is-child box">
                    <div id="this-makes-all-content-within-the-tile-stack-vertically" class="tile is-vertical">
                        <p id="this-automatically-formats-to-be-a-title-in-buefy" class="title">
                            Title 1
                        </p>
                        <p id="this-is-example-text-information">
                            Hello World :D 
                        </p>
                    </div>
                </div>
                <div id="this-is-a-single-tile" class="tile is-12 is-child box">
                    <div id="this-makes-all-content-within-the-tile-stack-vertically" class="tile is-vertical">
                        <p id="this-automatically-formats-to-be-a-title-in-buefy" class="title">                
                            Title 2        
                        </p>
                        <p id="this-is-example-text-information">
                            Hello World :D 
                        </p>                        
                    </div>
                </div>
            </div>
        </div>
    </div>
    
</div>
</template>




<script>
export default {
    name: "Login",
    methods: {
        
    }
}
</script>



<style scoped>
#all {
    background-color:none;
}
.info {
    min-height:200px;
    display: flex;
    align-items: center;
}

.titleAbout {
    font-style:italic;
    font-size:35px;
    display: flexbox;
    text-align: center;
}

/*this simply rounds images to look pretty*/
img {
    border-radius: 15px;
    margin: auto;
}
.container {
    margin: auto;

}
img {
    width: 300px;
    height: 325px;
}

/*this formats the title of the page*/
#OverallPageTitleOutsideOfTitles {
    display: flexbox;
    font-size: 2rem;
    align-items: center;
    text-align: center;
    margin: 20px;
    width: auto;
}
</style>