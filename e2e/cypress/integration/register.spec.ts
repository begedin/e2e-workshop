/// <reference types="cypress" />
/// <reference path="../support/index.d.ts" />

class RegisterPage {
  visit() {
    cy.visit("/register");
  }

  fillName(value: string) {
    cy.get(".register input[name=name]").clear().type(value);
  }

  fillPassword(value: string) {
    cy.get(".register input[name=password]").clear().type(value);
  }

  submit() {
    cy.get("button").click();
  }
}

describe("Register", () => {
  beforeEach(() => cy.checkoutSandbox());
  afterEach(() => cy.checkinSandbox());

  it("registers user", () => {
    const page = new RegisterPage();

    console.log("visiting...");

    page.visit();
    page.fillName("Joe");
    page.fillPassword("password1");
    page.submit();

    cy.url().should("not.contain", "register");
  });
});
