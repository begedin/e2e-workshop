<template>
  <AccountForm class="register" text="Register" @submit="onSubmit" />
</template>

<script lang="ts">
import { defineComponent } from '@vue/runtime-core';
import { useStore } from '../store';
import AccountForm from './AccountForm.vue';

/**
 * Renders and handles interaction of the /register page.
 *
 * Submits register attempt to store.
 */
export default defineComponent({
  components: { AccountForm },
  setup() {
    const store = useStore();

    const onSubmit = (params: { name: string; password: string }) =>
      store.dispatch('register', params);

    return { onSubmit };
  },
});
</script>
