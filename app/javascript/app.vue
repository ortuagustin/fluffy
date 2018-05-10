<template>
  <div>
    <p>{{ message }}</p>
  </div>
</template>

<script>
export default {
  props: ['data-message'],

  data() {
    return {
      message: this.dataMessage
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
