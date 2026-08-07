import { Controller, Get, HttpCode, HttpStatus } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getInfo(): string {
    return this.appService.getHello();
  }

  @Get('health')
  @HttpCode(HttpStatus.OK)
  async healthCheck() {
    const result = await this.appService.healthCheck();
    const statusCode =
      result.database === 'connected' ? HttpStatus.OK : HttpStatus.SERVICE_UNAVAILABLE;
    return { ...result, statusCode };
  }
}