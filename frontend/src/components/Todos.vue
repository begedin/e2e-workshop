<template>
  <div class="todos">
    <h1>Todos</h1>
    <todo v-for="todo in todos" :key="todo.id" :todo="todo" />
    <new-todo />
  </div>
</template>

<script lang="ts">
import { defineComponent, computed, watch } from '@vue/runtime-core';
import { useRouter } from 'vue-router';
import { useStore } from '../store';
import NewTodo from './NewTodo.vue';
import Todo from './Todo.vue';

export default defineComponent({
  components: { NewTodo, Todo },
  setup() {
    const store = useStore();
    const router = useRouter();

    const authenticated = computed(() => store.state.authenticated);

    watch(authenticated, (authenticated) => {
      if (!authenticated) {
        router.push('/login');
      }
    });

    if (store.state.authenticated) {
      store.dispatch('loadTodos');
    }

    const todos = computed(() => store.state.todos);

    return { todos };
  },
});
</script>

<style lang="scss" scoped>
.todos {
  font-size: 100%;
  display: flex;
  flex-direction: column;
  row-gap: 1em;
}
</style>
