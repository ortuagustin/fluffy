import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue/dist/vue.esm';
import axios from 'axios';
import SearchBox from '../SearchBox.vue';

Vue.use(TurbolinksAdapter)

window.axios = axios;

document.addEventListener('turbolinks:load', () => {
  window.axios.defaults.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

  const app = new Vue({
    el: '#app',

    components: { SearchBox }
  })
})
