module.exports = {
  parser: '@typescript-eslint/parser',
  plugins: ['cypress', 'prettier', '@typescript-eslint'],
  env: {
    'cypress/globals': true,
  },
  extends: [
    'plugin:@typescript-eslint/recommended',
    'plugin:prettier/recommended',
    'prettier',
  ],
};
