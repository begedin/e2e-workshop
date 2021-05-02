class RegisterPage {
  visit() {
    cy.visit('/register');
  }

  fillName(value: string) {
    cy.get('.register input[name=name]').clear().type(value);
  }

  fillPassword(value: string) {
    cy.get('.register input[name=password]').clear().type(value);
  }

  submit() {
    cy.get('.register button').click();
  }
}

class LoginPage {
  visit() {
    cy.visit('/login');
  }

  fillName(value: string) {
    cy.get('.login input[name=name]').clear().type(value);
  }

  fillPassword(value: string) {
    cy.get('.login input[name=password]').clear().type(value);
  }

  submit() {
    cy.get('.login button').click();
  }
}

class TodosPage {
  visit() {
    cy.visit('/');
  }

  fillTitle(value: string) {
    cy.get('.new-todo input[name=title]').clear().type(value);
  }

  submit() {
    cy.get('.new-todo button').click();
  }

  get todos() {
    return cy.get('.todo');
  }

  getTodo(index: number) {
    this.todos.eq(index);
  }

  deleteTodo(index: number) {
    this.todos.eq(index).within(() => {
      cy.get('button').click();
    });
  }
}

/**
 * Main page object used to interact with te page in tests.
 *
 * This is a basic example of how one could deal with test selectors and making
 * tests less brittle/easier to write.
 *
 * A larger app would likely deal with multiple page objects.
 *
 * Page objects could also be simple objects which just define css selectors for
 * test interaction. That makes them less powerful, but it allows them to be
 * less coupled to the test suite actually being used.
 */
export default class PageObject {
  registerPage: RegisterPage;
  loginPage: LoginPage;
  todosPage: TodosPage;

  navbar = {
    clickLogin(): void {
      cy.get("nav a[href='/login']").click();
    },

    clickTodos(): void {
      cy.get("nav a[href='/']").click();
    },
  };

  constructor() {
    this.registerPage = new RegisterPage();
    this.loginPage = new LoginPage();
    this.todosPage = new TodosPage();
  }

  /**
   * Complex action which
   * - navigates to the login page
   * - fills in form
   * - submits it
   */
  login(name: string, password: string): void {
    this.loginPage.visit();
    this.loginPage.fillName(name);
    this.loginPage.fillPassword(password);
    this.loginPage.submit();
  }
}
