/// <reference types="cypress" />
/// <reference types="../support" />

import PageObject from "../PageObject";

describe("Login", () => {
  beforeEach(() => {
    cy.useSandbox();
    cy.checkoutSandbox();
  });

  afterEach(() => {
    cy.checkinSandbox();
  });

  it("logs user in", () => {
    const app = new PageObject();

    cy.create("user", { name: "Joe", password: "password1" });

    app.loginPage.visit();
    app.loginPage.fillName("Joe");
    app.loginPage.fillPassword("password1");
    app.loginPage.submit();

    cy.url().should("not.contain", "login");
  });
});
