declare namespace Cypress {
  interface Chainable<Subject> {
    useSandbox(): Chainable<void>;
    checkoutSandbox(): Chainable<string>;
    checkinSandbox(): Chainable<void>;
    create<T = Record<string, any>, R = any>(type: String, params: T): Chainable<R>;
  }
}
