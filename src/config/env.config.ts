export interface EnvironmentVariables {
  NODE_ENV: 'development' | 'production' | 'test'
  PORT: number
  DB_HOST: string
  DB_PORT: number
  DB_USER: string
  DB_PASS: string
  DB_NAME: string
}
