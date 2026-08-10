import { Controller, Get, Param, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiBearerAuth } from '@nestjs/swagger';
import { LinhaTempoService } from './linha-tempo.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { CurrentUser } from '../auth/current-user.decorator';

@ApiTags('linha-tempo')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('ocorrencias/:ocorrenciaId/linha-do-tempo')
export class LinhaTempoController {
  constructor(private readonly service: LinhaTempoService) {}

  @Get()
  async getTimeline(
    @Param('ocorrenciaId') oid: string,
    @CurrentUser() u: any,
    @Query('categoria') categoria?: string,
    @Query('ordem') ordem?: string,
  ) {
    return this.service.getTimeline(oid, u, { categoria, ordem });
  }
}