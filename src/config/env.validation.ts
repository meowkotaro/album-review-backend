import { IsEnum, IsNumber, IsString, validateSync } from 'class-validator'
import { Type } from 'class-transformer'
import { plainToInstance } from 'class-transformer'

// 環境変数のenum
enum Environment {
  Development = 'development',
  Production = 'production',
  Test = 'test',
}

export class EnvironmentVariables {
  @IsEnum(Environment)
  NODE_ENV: Environment

  @Type(() => Number)
  @IsNumber()
  PORT: number

  @IsString()
  DB_HOST: string

  @Type(() => Number)
  @IsNumber()
  DB_PORT: number

  @IsString()
  DB_USER: string

  @IsString()
  DB_PASSWORD: string

  @IsString()
  DB_NAME: string
}

export function validate(config: Record<string, unknown>) {
  const validatedConfig = plainToInstance(EnvironmentVariables, config, {
    excludeExtraneousValues: true,
  })

  const errors = validateSync(validatedConfig, {
    skipMissingProperties: true,
  })

  if (errors.length > 0) {
    throw new Error(errors.toString())
  }

  return validatedConfig
}
