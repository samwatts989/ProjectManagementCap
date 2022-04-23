<template>



<div id="all">
    
    <h1 id="OverallPageTitleOutsideOfTitles">
      <br>
        <center>Please Sign In</center>
    </h1>
    <div id="this-contains-the-entire-page-and-all-contents" class="tile is-ancestor">
        <div id="this-contains-all-tiles" class="tile is-12">
            <div id="this-contains-all-tiles-and-makes-tiles-stack-vertically" class="tile is-parent is-vertical">
                <div id="this-is-a-single-tile" class="tile is-3 is-child box">
                    <div id="this-makes-all-content-within-the-tile-stack-vertically" class="tile is-vertical">


  
    <form class="form-signin" @submit.prevent="login">
      <center><h1 class="h3 mb-3 font-weight-normal"><b>Welcome to ScrumLords!</b></h1></center>
      <div
        class="alert alert-danger"
        role="alert"
        v-if="invalidCredentials"
      >Invalid username and password!</div>
      <div
        class="alert alert-success"
        role="alert"
        v-if="this.$route.query.registration"
      >Thank you for registering, please sign in.</div>
      <label for="username" class="sr-only">Username</label>
      <input
        type="text"
        id="username"
        class="form-control"
        placeholder="Username"
        v-model="user.username"
        required
        autofocus
      />
      <br>
      <br>
      <label for="password" class="sr-only">Password</label>
      <input
        type="password"
        id="password"
        class="form-control"
        placeholder="Password"
        v-model="user.password"
        required
      />
      <br>
      <br>
      <center>
      <button type="submit">Sign in</button>
      </center>
      <br>
      <router-link :to="{ name: 'register' }">Need an account?</router-link>
    </form>
  


                    
                </div>
            </div>
        </div>
    </div>
    
</div>

 </div>
</template>

<script>
import authService from "../services/AuthService";

export default {
  name: "login",
  components: {},
  data() {
    return {
      user: {
        username: "",
        password: ""
      },
      invalidCredentials: false
    };
  },
  methods: {
    login() {
      authService
        .login(this.user)
        .then(response => {
          if (response.status == 200) {
            this.$store.commit("SET_AUTH_TOKEN", response.data.token);
            this.$store.commit("SET_USER", response.data.user);
            this.$router.push("/");
          }
        })
        .catch(error => {
          const response = error.response;

          if (response.status === 401) {
            this.invalidCredentials = true;
          }
        });
    }
  }
};
</script>

<style scoped>

.form-signin {
  text-align: center;
}

#this-contains-all-tiles-and-makes-tiles-stack-vertically {
  display: flexbox;
  align-items: center;
}
</style>
