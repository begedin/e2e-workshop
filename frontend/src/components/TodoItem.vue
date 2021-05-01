<template>
  <div class="todo">
    <span>{{ todo.title }}</span>
    <button @click="deleteTodo(todo)">x</button>
  </div>
</template>

<script lang="ts">
import { defineComponent } from '@vue/runtime-core';
import { Todo } from '../schema';
import { useStore } from '../store';

/**
 * Renders a single todo item, with associated deletion UI and actions
 */
export default defineComponent({
  name: 'TodoItem',
  props: {
    todo: {
      required: true,
      type: Object as () => Todo,
    },
  },
  setup(props) {
    const store = useStore();

    const deleteTodo = () => {
      store.dispatch('deleteTodo', props.todo);
    };

    return { deleteTodo };
  },
});
</script>

<style lang="scss" scoped>
.todo {
  display: grid;
  grid-template-columns: 1fr auto;
  align-items: center;

  button {
    font-size: 150%;
    background: #f8edeb;
    border: none;
    border-radius: 50%;
    height: 2em;
    width: 2em;

    transition: background-color 0.2s ease;

    &:hover {
      background: #fec5bb;
    }
  }
}
</style>
