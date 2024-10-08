const path = require('path')

module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: 'tsconfig.json',
    tsconfigRootDir: path.resolve(__dirname),
    sourceType: 'module',
    ecmaVersion: 2018,
  },
  plugins: ['@typescript-eslint', 'prettier'],
  extends: [
    'plugin:@typescript-eslint/recommended',
    'plugin:prettier/recommended',
  ],
  root: true,
  env: {
    node: true,
    jest: true,
  },
  ignorePatterns: ['.eslintrc.js'],
  rules: {
    '@typescript-eslint/interface-name-prefix':
      'off',
    '@typescript-eslint/explicit-function-return-type':
      'off',
    '@typescript-eslint/explicit-module-boundary-types':
      'off',
    '@typescript-eslint/no-explicit-any': 'off',
    'prettier/prettier': 'error',
    'function-paren-newline': [
      'error',
      'consistent',
    ],
    'function-call-argument-newline': [
      'error',
      'consistent',
    ],
  },
}
