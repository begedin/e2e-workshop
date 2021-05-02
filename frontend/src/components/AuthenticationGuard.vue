<script lang="ts">
import { defineComponent } from '@vue/runtime-core';
import { useRouter } from 'vue-router';
import { useStore } from '../store';

/**
 * Checks authentication status and redirects to /login if not authenticated.
 *
 * Used by route components, to ensure user is redirected away if not
 * authenticated.
 *
 * Could be extended to remember the last attempted route before redirecting.
 */
export default defineComponent({
  name: 'AuthenticationGuard',
  setup() {
    const router = useRouter();
    const store = useStore();

    if (!store.state.authenticated) {
      router.push('/login');
    }

    return {};
  },
  render: () => null,
});
</script>
