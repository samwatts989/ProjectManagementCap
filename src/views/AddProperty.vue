<template>
  <div>
    <h1>Add New Property</h1>
    <create-property />
  </div>
</template>

<script>
import CreateProperty from '../components/CreateProperty.vue'
export default {
    name: "add-property",
    components: {
    CreateProperty
  }
}
</script>

<style>

</style>