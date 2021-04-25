import { createRouter, createWebHistory } from 'vue-router';
import Todos from './components/Todos.vue';
import Register from './components/Register.vue';
import Login from './components/Login.vue';

export const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', component: Todos },
    { path: '/register', component: Register },
    { path: '/login', component: Login },
  ],
});
