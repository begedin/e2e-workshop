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
    cy.get(".register button").click();
  }
}

class LoginPage {
  visit() {
    cy.visit("/login");
  }

  fillName(value: string) {
    cy.get(".login input[name=name]").clear().type(value);
  }

  fillPassword(value: string) {
    cy.get(".login input[name=password]").clear().type(value);
  }

  submit() {
    cy.get(".login button").click();
  }
}

class TodosPage {
  visit() {
    cy.visit("/");
  }

  fillTitle(value: string) {
    cy.get(".new-todo input[name=title]").clear().type(value);
  }

  submit() {
    cy.get(".new-todo button").click();
  }

  get todos() {
    return cy.get(".todo");
  }

  getTodo(index: number) {
    this.todos.eq(index);
  }

  deleteTodo(index: number) {
    this.todos.eq(index).within(() => {
      cy.get("button").click();
    });
  }
}

export default class PageObject {
  registerPage: RegisterPage;
  loginPage: LoginPage;
  todosPage: TodosPage;

  navbar = {
    clickLogin() {
      cy.get("navbar a[href='/login']").click();
    },

    clickTodos() {
      cy.get("navbar a[href='/']").click();
    },
  };

  constructor() {
    this.registerPage = new RegisterPage();
    this.loginPage = new LoginPage();
    this.todosPage = new TodosPage();
  }

  login(name: string, password: string) {
    this.loginPage.visit();
    this.loginPage.fillName(name);
    this.loginPage.fillPassword(password);
    this.loginPage.submit();
  }
}
