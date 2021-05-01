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
    <button type="submit">Login</button>
  </form>
</template>

<script lang="ts">
import { defineComponent, ref } from '@vue/runtime-core';

export default defineComponent({
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

<style lang="scss">
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

    input {
      font-size: 100%;
      text-align: center;
      opacity: 0.8;
      padding: 0.3em;
    }
  }
}
</style>
