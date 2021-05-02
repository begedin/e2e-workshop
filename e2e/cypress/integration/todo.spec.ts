/// <reference types="cypress" />
/// <reference types="../support" />

import PageObject from '../PageObject';

let user: { id: number; name: string; password: string };
type UserParams = Pick<typeof user, 'name' | 'password'>;
type User = typeof user;

describe('Todos', () => {
  beforeEach(() => {
    cy.useSandbox();
    cy.checkoutSandbox();

    cy.create<UserParams, User>('user', {
      name: 'Joe',
      password: 'password1',
    }).then((record) => {
      user = record;
    });
  });

  afterEach(() => {
    cy.checkinSandbox();
  });

  it('creates and deletes todos', () => {
    const app = new PageObject();
    app.login(user.name, user.password);

    app.navbar.clickTodos();

    app.todosPage.todos.should('have.length', 0);

    app.todosPage.fillTitle('Buy Milk');
    app.todosPage.submit();

    app.todosPage.todos.should('have.length', 1);

    app.todosPage.fillTitle('Write Homework');
    app.todosPage.submit();

    app.todosPage.todos.should('have.length', 2);

    app.todosPage.deleteTodo(1);

    app.todosPage.todos.should('have.length', 1);
  });

  it.only('loads and lists todos', () => {
    cy.create('todo', { title: 'Read a Book', user });
    cy.create('todo', { title: 'Watch a Movie', user });

    const app = new PageObject();
    app.login(user.name, user.password);
    app.navbar.clickTodos();

    app.todosPage.todos.should('have.length', 2);
  });
});
