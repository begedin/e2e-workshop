<template>
  <nav>
    <RouterLink v-if="authenticated" to="/">Todos</RouterLink>
    <button v-if="authenticated" @click="logout">Log Out</button>
    <RouterLink v-if="!authenticated" to="/login">Login</RouterLink>
    <RouterLink v-if="!authenticated" to="/register">Register</RouterLink>
  </nav>
  <main>
    <RouterView />
  </main>
  <AuthenticationWatcher />
</template>

<script lang="ts">
import { computed, defineComponent } from 'vue';
import { useStore } from './store';
import AuthenticationWatcher from './components/AuthenticationWatcher.vue';
export default defineComponent({
  name: 'App',
  components: { AuthenticationWatcher },
  setup() {
    const store = useStore();
    const authenticated = computed(() => store.state.authenticated);

    const logout = store.dispatch('logout');

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

  display: grid;
  justify-content: center;
  align-items: center;
  row-gap: 1em;

  font-size: 16px;
}
</style>

<style lang="scss" scoped>
nav {
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
