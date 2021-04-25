<template>
  <div class="">Login</div>
  <form @submit.stop.prevent="onSubmit">
    <input name="name" v-model="name" />
    <input name="password" v-model="password" />
    <button type="submit">Login</button>
  </form>
</template>

<script lang="ts">
import { defineComponent, computed, ref, watch } from '@vue/runtime-core';
import { useRouter } from 'vue-router';
import { useStore } from '../store';

export default defineComponent({
  setup() {
    const router = useRouter();
    const store = useStore();

    const authenticated = computed(() => store.state.authenticated);

    watch(authenticated, (authenticated) => {
      if (authenticated) {
        router.push('/');
      }
    });

    const name = ref('');
    const password = ref('');

    const onSubmit = () => {
      store.dispatch('login', {
        name: name.value,
        password: password.value,
      });
    };

    return {
      name,
      password,
      onSubmit,
    };
  },
});
</script>

<style lang="scss" scoped></style>
