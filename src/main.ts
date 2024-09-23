import { NestFactory } from '@nestjs/core'
import { ConfigService } from '@nestjs/config'
import { AppModule } from './app.module'
import { EnvironmentVariables } from './config/env.config'
import { Logger } from '@nestjs/common'

async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  const configService = app.get(ConfigService<EnvironmentVariables>)
  const logger = new Logger('bootstrap')

  const port = configService.get<number>('PORT')

  const environment = configService.get<EnvironmentVariables['NODE_ENV']>('NODE_ENV')

  if (!port) {
    throw new Error('PORT is not defined in the environment variables')
  }

  await app.listen(port)
  logger.log(`Application listening on http://localhost:${port} in ${environment} mode`)
}
bootstrap()
