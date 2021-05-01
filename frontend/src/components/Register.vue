<template>
  <account-form class="register" @submit="onSubmit" />
</template>

<script lang="ts">
import { defineComponent, computed, watch } from '@vue/runtime-core';
import { useRouter } from 'vue-router';
import { useStore } from '../store';
import AccountForm from './AccountForm.vue';

export default defineComponent({
  components: { AccountForm },
  setup() {
    const store = useStore();
    const router = useRouter();

    const authenticated = computed(() => store.state.authenticated);

    watch(authenticated, (authenticated) => {
      if (authenticated) {
        router.push('/');
      }
    });

    const onSubmit = (params: { name: string; password: string }) =>
      store.dispatch('register', params);

    return { onSubmit };
  },
});
</script>

<style lang="scss" scoped></style>
