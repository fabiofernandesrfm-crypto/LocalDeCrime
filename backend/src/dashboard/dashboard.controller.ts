import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { DashboardService } from './dashboard.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';
import { DashboardOcorrenciasQueryDto } from './dto/dashboard.dto';

@ApiTags('dashboard')
@UseGuards(JwtAuthGuard)
@Controller('dashboard')
export class DashboardController {
  constructor(private readonly service: DashboardService) {}

  @Get('ocorrencias')
  getOcorrencias(@Query() query: DashboardOcorrenciasQueryDto, @CurrentUser() u: any) {
    return this.service.getOcorrencias(query, u);
  }
}