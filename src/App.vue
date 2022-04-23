<template>
  <div id="app">
      <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Libre+Baskerville&display=swap" rel="stylesheet">
      <div id="navBarContainer">
      <b-navbar id="navBarCss">
        <template #brand>
            <b-navbar-item tag="router-link" :to="{ path: '/' }">
                   <img href="data:image/jpeg;base64,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">

                <b>ScrumLords</b>
            </b-navbar-item>
        </template>
        <template #start>
            <router-link v-bind:to="{ name: 'home' }"><b-navbar-item>
                Home
            </b-navbar-item></router-link>
            <router-link v-bind:to="{ name: 'properties' }"><b-navbar-item>
                Properties
            </b-navbar-item></router-link>
            <router-link v-bind:to="{ name: 'about-us' }"><b-navbar-item>
                About Us
            </b-navbar-item></router-link>
            <router-link v-bind:to="{ name: 'logout' }" v-if="$store.state.token != ''"><b-navbar-item>
                Logout
            </b-navbar-item></router-link>

        </template>
    </b-navbar>
    </div> <!-- navbar container -->
    <router-view id="mainContent" />

  </div>
</template>

<style>


#mainContent {
    margin-top: 1rem;
    border-radius: 10px;
    padding: 1rem;

}
#navBarCss {
    background-color: #fffee0;
display: flex;
align-items: center;
border-radius: 10px;
    
}
#app {
    padding: 1.5rem;
    background-color:#fff3e7;
    height: 100vh;
    font-family: 'Libre Baskerville', serif;
}
#navBarContainer {
align-items: center;
justify-items: right;
}




</style>