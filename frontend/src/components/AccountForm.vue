<template>
  <form class="account-form" @submit.stop.prevent="onSubmit">
    <label>
      <span>Name</span>
      <input v-model="name" name="name" />
    </label>
    <label>
      <span>Password</span>
      <input v-model="password" name="password" />
    </label>
    <button type="submit">{{ text }}</button>
  </form>
</template>

<script lang="ts">
import { defineComponent, ref } from '@vue/runtime-core';

/**
 * Common component used by /register and /login pages.
 *
 * Renders account form and emits submit event with account params
 */
export default defineComponent({
  props: {
    text: { required: false, default: 'Login', type: String as () => string },
  },
  emits: ['submit'],
  setup(props, { emit }) {
    const name = ref('');
    const password = ref('');

    const onSubmit = () =>
      emit('submit', { name: name.value, password: password.value });

    return {
      name,
      password,
      onSubmit,
    };
  },
});
</script>

<style lang="scss" scoped>
.account-form {
  display: flex;
  flex-direction: column;
  row-gap: 1em;

  label {
    display: flex;
    flex-direction: column;
    row-gap: 0.2em;

    span {
      opacity: 0.7;
    }

    input,
    button {
      font-size: 100%;
      text-align: center;
      padding: 0.3em;
    }

    input {
      opacity: 0.8;
    }
  }

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
