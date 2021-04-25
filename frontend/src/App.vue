<template>
  <router-link v-if="authenticated" to="/">Todos</router-link>
  <button v-if="authenticated" @click="logout">Log Out</button>
  <router-link v-if="!authenticated" to="/login">Login</router-link>
  <router-link v-if="!authenticated" to="/register">Register</router-link>
  <router-view />
</template>

<script lang="ts">
import { computed, defineComponent, watch } from 'vue';
import { useStore } from './store';
export default defineComponent({
  name: 'App',
  setup() {
    const store = useStore();
    const authenticated = computed(() => store.state.authenticated);

    const logout = () => {
      store.dispatch('logout');
    };

    return { authenticated, logout };
  },
});
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
