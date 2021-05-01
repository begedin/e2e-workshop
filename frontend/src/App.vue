<template>
  <navbar>
    <router-link v-if="authenticated" to="/">Todos</router-link>
    <button v-if="authenticated" @click="logout">Log Out</button>
    <router-link v-if="!authenticated" to="/login">Login</router-link>
    <router-link v-if="!authenticated" to="/register">Register</router-link>
  </navbar>
  <main>
    <router-view />
  </main>
</template>

<script lang="ts">
import { computed, defineComponent } from 'vue';
import { useStore } from './store';
export default defineComponent({
  name: 'App',
  setup() {
    const store = useStore();
    const authenticated = computed(() => store.state.authenticated);

    const logout = store.dispatch('logout');

    return { authenticated, logout };
  },
});
</script>

<style lang="scss">
body {
  font-size: 16px;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;

  display: grid;
  justify-content: center;
  align-items: center;
  row-gap: 1em;
}

navbar {
  display: grid;
  grid-auto-flow: column;
  column-gap: 0.5em;

  align-items: center;

  a,
  button {
    display: block;
    text-decoration: none;
    text-transform: uppercase;
    font-weight: bold;

    font-size: 100%;
    line-height: 100%;

    padding: 0.5em;
    background: #e8e8e4;
    border-radius: 0.2em;
    border: none;
    outline: none;

    cursor: pointer;

    transition: background 0.2s ease;

    &:hover {
      background: #d8e2dc;
    }

    &:visited {
      color: inherit;
    }
  }
}
</style>
