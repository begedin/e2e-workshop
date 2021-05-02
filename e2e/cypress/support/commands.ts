const apiUrl = (path: string) => `http://localhost:4000/${path}`;

/**
 * Sends a POST request to a special backend endpoint which checks out a sandbox
 * db connection and returns an id for it.
 *
 * Needs to be run before every test that deals with the db.
 */
Cypress.Commands.add('checkoutSandbox', () =>
  cy.request('POST', apiUrl('sandbox')).then((response) => {
    Cypress.env('sandboxId', response.body);
  })
);

/**
 * Intercept all requests to backend and add a sandbox header, if present in
 * cypress environment.
 *
 * Needs to be run before every test that deals with the db.
 * Assumes the `cy.checkoutSandbox` command was called first.
 */
Cypress.Commands.add('useSandbox', () =>
  cy.intercept({ url: 'http://localhost:4000/**' }, (req) => {
    const sandboxId = Cypress.env('sandboxId');
    if (sandboxId) {
      req.headers['sandbox'] = sandboxId;
    }
    req.continue();
  })
);

/**
 * Sends a DELETE request to a special backend endpoint, which checks a checked
 * out sandbox db connection back in.
 *
 * Needs to be run before every test that deals with the db.
 */
Cypress.Commands.add('checkinSandbox', () =>
  cy.request({
    method: 'DELETE',
    url: apiUrl('sandbox'),
    headers: { Sandbox: Cypress.env('sandboxId') },
  })
);

const createRequest = (
  schema: string,
  attributes: Record<string, unknown>
) => ({
  method: 'POST',
  url: apiUrl('factory'),
  body: { schema, attributes },
  headers: { Sandbox: Cypress.env('sandboxId') },
});

/**
 * Factory command, used to create db records on the backend.
 *
 * See how `TodoList.FactoryPlug` was implemented in `<projectRoot>/backend` on
 * specific details on how it works.
 *
 * Generally, pass in
 *
 * @param {string} recordType
 * Type of record to create. Underscore format.
 *
 * @param {Record<string, any>} attributes
 * Attributes for the record.
 *
 * To specify associations, pass in a map containing an id of the association.
 *
 * For example
 *
 * ```
 * cy.create('todo', { title: 'Foo', user: { id: 1} })
 * ```
 */
Cypress.Commands.add(
  'create',
  (recordType: string, attributes: Record<string, unknown>) =>
    cy.request(createRequest(recordType, attributes)).its('body')
);
