<template>
  <AuthenticationGuard />
  <div class="todos">
    <h1>Todos</h1>
    <TodoItem v-for="todo in todos" :key="todo.id" :todo="todo" />
    <NewTodo />
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from '@vue/runtime-core';
import { useStore } from '../store';
import AuthenticationGuard from './AuthenticationGuard.vue';
import NewTodo from './NewTodo.vue';
import TodoItem from './TodoItem.vue';

/**
 * Lists out all currently loaded todos, as well as the UI to create a new todo.
 */
export default defineComponent({
  components: { NewTodo, TodoItem, AuthenticationGuard },
  setup() {
    const store = useStore();

    store.dispatch('loadTodos');

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
