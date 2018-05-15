<template>
  <div class="field is-grouped dropdown" :class="hasResults() ? 'is-active' : ''">
    <div class="control">
      <input class="input" type="text" :placeholder="placeholder" v-model="query" autofocus>
    </div>

    <div class="dropdown-menu" v-if="hasResults()">
      <div class="dropdown-content">
        <div v-for="(result, index) in results" :key="result._id" class="dropdown-item">
          <a :href="result._source.path" class="dropdown-item">
            <p class="has-text-weight-bold" v-text="result._source.title"></p>
            <p class="has-text-weight-light" v-text="result._source.body"></p>
          </a>

          <hr class="dropdown-divider" v-if="index != results.length - 1">
        </div>
      </div>
    </div>

    <p class="control">
      <a class="button is-white" :class="loading ? 'is-loading' : ''" :disabled="loading" @click="submit">
        <span class="icon is-small">
          <i class="fa fa-search"></i>
        </span>
      </a>
    </p>
  </div>
</template>

<script>
export default {
  props: ['route', 'placeholder'],

  data() {
    return {
      loading: false,
      query: '',
      results: []
    };
  },

  methods: {
    submit() {
      this.loading = true;

      axios
        .get(`${this.route}/${this.query}`)
        .then(response => {
          this.results = response.data;
          this.loading = false;
        })
        .catch(error => {
          this.loading = false;
        });
    },

    hasResults() {
      return this.results.length > 0;
    }
  }
}
</script>
