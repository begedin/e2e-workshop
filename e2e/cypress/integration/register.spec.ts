/// <reference types="cypress" />
/// <reference types="../support" />
import PageObject from "../PageObject";

describe("Register", () => {
  beforeEach(() => {
    cy.useSandbox();
    cy.checkoutSandbox();
  });

  afterEach(() => {
    cy.checkinSandbox();
  });

  it("registers user", () => {
    const app = new PageObject();

    app.registerPage.visit();
    app.registerPage.fillName("Joe");
    app.registerPage.fillPassword("password1");
    app.registerPage.submit();

    cy.url().should("not.contain", "register");
  });
});
