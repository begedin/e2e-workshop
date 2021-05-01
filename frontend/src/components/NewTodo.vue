<template>
  <form class="new-todo" @submit.prevent="createTodo">
    <input v-model="newTodo" name="title" placeholder="Add a todo" />
    <button type="submit">Add</button>
  </form>
</template>

<script lang="ts">
import { defineComponent, ref } from '@vue/runtime-core';
import { useStore } from '../store';

export default defineComponent({
  setup() {
    const store = useStore();

    const newTodo = ref('');
    const createTodo = async () => {
      await store.dispatch('createTodo', { title: newTodo.value });
      if (!store.state.error) {
        newTodo.value = '';
        console.log(store.state.todos.length);
      }
    };

    return { createTodo, newTodo };
  },
});
</script>

<style lang="scss" scoped>
.new-todo {
  display: flex;
  flex-direction: column;
  row-gap: 0.5em;

  input {
    text-align: center;
    padding: 0.2em;
    font-size: 100%;
  }

  button {
    align-self: center;
    font-size: 100%;
    min-width: 5em;
    padding: 0.3em;
    background: #d8e2dc;
    border: none;
    border-radius: 0.2em;
    vertical-align: center;

    transition: background-color 0.2s ease;

    &:hover {
      background: #2a9d8f;
    }
  }
}
</style>
