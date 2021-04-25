<template>
  <div class="">
    <h1>Todos</h1>
    <div v-for="todo in todos" :key="todo.id">
      <span>{{ todo.title }}</span
      ><button @click="deleteTodo(todo)">x</button>
    </div>
    <form @submit.prevent="createTodo">
      <input v-model="newTodo" />
    </form>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed, ref, watch } from '@vue/runtime-core';
import { useRouter } from 'vue-router';
import { Todo } from '../schema';
import { useStore } from '../store';

export default defineComponent({
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

    const newTodo = ref('');
    const createTodo = () => {
      store.dispatch('createTodo', { title: newTodo.value });
    };

    const deleteTodo = (todo: Todo) => {
      store.dispatch('deleteTodo', todo);
    };

    const todos = computed(() => store.state.todos);

    return { createTodo, deleteTodo, newTodo, todos };
  },
});
</script>

<style lang="scss" scoped></style>
