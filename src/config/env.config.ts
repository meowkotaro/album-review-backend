import { registerAs } from '@nestjs/config'

export interface EnvironmentVariables {
  NODE_ENV: 'development' | 'production' | 'test'
  PORT: number
  DB_HOST: string
  DB_PORT: number
  DB_USER: string
  DB_PASSWORD: string
  DB_NAME: string
}

export default registerAs(
  'env',
  (): EnvironmentVariables => ({
    NODE_ENV: process.env.NODE_ENV as 'development' | 'production' | 'test',
    PORT: parseInt(process.env.PORT, 10) || 8888,
    DB_HOST: process.env.DB_HOST,
    DB_PORT: parseInt(process.env.DB_PORT, 10),
    DB_USER: process.env.DB_USER,
    DB_PASSWORD: process.env.DB_PASSWORD,
    DB_NAME: process.env.DB_NAME,
  }),
)
