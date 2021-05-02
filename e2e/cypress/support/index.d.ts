declare namespace Cypress {
  interface Chainable {
    useSandbox(): Chainable<void>;
    checkoutSandbox(): Chainable<string>;
    checkinSandbox(): Chainable<void>;
    create<T = Record<string, unknown>, R = unknown>(
      type: string,
      params: T
    ): Chainable<R>;
  }
}
