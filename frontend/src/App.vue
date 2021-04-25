<template>
  <router-link to="/">Todos</router-link>
  <router-link to="/login">Login</router-link>
  <router-link to="/register">Register</router-link>
  <router-view />
</template>

<script lang="ts">
import { defineComponent } from 'vue';
export default defineComponent({ name: 'App' });
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
