import { Module } from '@nestjs/common'
import { ConfigModule } from '@nestjs/config'
import { TypeOrmModule } from '@nestjs/typeorm'
import { EnvironmentVariables } from './config/env.validation'
import { ConfigService } from '@nestjs/config'
import { validate } from './config/env.validation'

@Module({
  imports: [
    ConfigModule.forRoot({
      validate,
      isGlobal: true,
    }),
    TypeOrmModule.forRootAsync({
      useFactory: (
        configService: ConfigService<EnvironmentVariables>,
      ) => ({
        type: 'mysql',
        host: configService.get('DB_HOST'),
        port: configService.get('DB_PORT'),
        username: configService.get('DB_USER'),
        password: configService.get(`DB_PASS`),
        database: configService.get('DB_NAME'),
        entities: [],
        synchronize:
          configService.get('NODE_ENV') !==
          'production',
      }),
      inject: [ConfigService],
    }),
  ],
})
export class AppModule {}
