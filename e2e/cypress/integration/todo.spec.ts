/// <reference types="cypress" />
/// <reference types="../support" />

import PageObject from "../PageObject";

let app: PageObject;

describe("Todos", () => {
  beforeEach(() => {
    cy.useSandbox();
    cy.checkoutSandbox();

    app = new PageObject();

    const user = { name: "Joe", password: "password1" };
    cy.create("user", user);

    app.login(user.name, user.password);
  });

  afterEach(() => {
    cy.checkinSandbox();
  });

  it("creates and deletes todos", () => {
    const app = new PageObject();

    app.navbar.clickTodos();

    app.todosPage.todos.should("have.length", 0);

    app.todosPage.fillTitle("Buy Milk");
    app.todosPage.submit();

    app.todosPage.todos.should("have.length", 1);

    app.todosPage.fillTitle("Write Homework");
    app.todosPage.submit();

    app.todosPage.todos.should("have.length", 2);

    app.todosPage.deleteTodo(1);

    app.todosPage.todos.should("have.length", 1);
  });
});
