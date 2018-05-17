<template>
  <div class="field is-grouped dropdown" :class="shouldShowPosts() ? 'is-active' : ''">
    <div class="control has-icons-left has-icons-right" :class="loading ? 'is-loading' : ''">
      <input class="input is-loading" type="text" autofocus
        :placeholder="placeholder"
        v-model="query"
        @input="fetchPosts"
        @blur="hidePosts"
        @focus="showPosts"
      >

      <span class="icon is-small is-left">
        <i class="fa fa-search"></i>
      </span>
    </div>

    <div class="dropdown-menu" v-if="shouldShowPosts()">
      <div class="dropdown-content">
        <div v-for="(post, index) in posts" :key="post._id" class="dropdown-item">
          <a :href="post._source.path" class="dropdown-item">
            <p class="has-text-weight-bold" v-html="highlight(post._source.title, query)"></p>
            <p class="has-text-weight-light" v-html="highlight(post._source.body, query)"></p>
          </a>

          <hr class="dropdown-divider" v-if="index != posts.length - 1">
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['route', 'placeholder'],

  data() {
    return {
      query: '',
      posts: [],
      loading: false,
      displayPosts: false,
    };
  },

  methods: {
    highlight(text, substr) {
      let index = text.toLowerCase().indexOf(substr);

      if (index < 0) {
        return text;
      }

      return `${text.substring(0, index)}<mark>${text.substring(index, index + substr.length)}</mark>${text.substring(index + substr.length)}`;
    },

    fetchPosts() {
      this.posts = [];

      if (this.query == '') {
        return;
      }

      this.loading = true;

      axios
        .get(`${this.route}/${this.query}`)
        .then(response => {
          this.posts = response.data;
          this.loading = false;
        })
        .catch(error => {
          this.loading = false;
        });
    },

    shouldShowPosts() {
      return (this.hasPosts()) && (this.displayPosts);
    },

    hasPosts() {
      return this.posts.length > 0;
    },

    showPosts() {
      this.displayPosts = true;
    },

    hidePosts() {
      setTimeout(() => {
        this.displayPosts = false;
      }, 150);
    }
  }
}
</script>