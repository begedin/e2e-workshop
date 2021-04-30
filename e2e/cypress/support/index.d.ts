declare namespace Cypress {
  interface Chainable {
    checkoutSandbox(): Promise<string>;
    checkinSandbox(): Chainable;
    create<T = object, R = object>(params: T): Promise<R>;
    login(params: { name: string; password: string }): Chainable;
  }
}
