import { Promise } from "cypress/types/bluebird";

const apiUrl = (path: string) => `http://localhost:4000/${path}`;

const useSandbox = () =>
  cy.intercept(
    {
      url: "http://localhost:4000/**",
    },
    (req) => {
      const sandboxId = Cypress.env("sandboxId");
      if (sandboxId) {
        req.headers["sandbox"] = sandboxId;
      }
      req.continue();
    }
  );

Cypress.Commands.add("useSandbox", useSandbox);

const checkoutSandbox = () =>
  cy.request("POST", apiUrl("sandbox")).then((response) => {
    Cypress.env("sandboxId", response.body);
  });

Cypress.Commands.add("checkoutSandbox", checkoutSandbox);

const checkinSandboxCommand = () =>
  cy.request({
    method: "DELETE",
    url: apiUrl("sandbox"),
    headers: { Sandbox: Cypress.env("sandboxId") },
  });

Cypress.Commands.add("checkinSandbox", checkinSandboxCommand);

const createRequest = (schema: string, attributes: {}) => ({
  method: "POST",
  url: apiUrl("factory"),
  body: { schema, attributes },
  headers: { Sandbox: Cypress.env("sandboxId") },
});

const createCommand = (schema: string, attributes: {}) =>
  cy.request(createRequest(schema, attributes)).its("body");

Cypress.Commands.add("create", createCommand);
