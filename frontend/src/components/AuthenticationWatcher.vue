<script lang="ts">
import { defineComponent, computed, watch } from '@vue/runtime-core';
import { useRouter } from 'vue-router';
import { useStore } from '../store';

/**
 * Watches authentication status and, upon change, redirects
 * either to '/', or '/login'.
 *
 * A single instance is used globally, to react on authentication status
 * changes.
 *
 * Could be extended to redirect to last attempted route, upon login.
 */
export default defineComponent({
  name: 'AuthenticationWatcher',
  setup() {
    const router = useRouter();
    const store = useStore();

    const authenticated = computed(() => store.state.authenticated);

    watch(authenticated, (authenticated) =>
      router.push(authenticated ? '/' : '/login')
    );

    return {};
  },
});
</script>
