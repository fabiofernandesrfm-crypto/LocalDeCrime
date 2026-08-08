import { Module } from '@nestjs/common';
import { OcorrenciasService } from './ocorrencias.service';
import { OcorrenciasController } from './ocorrencias.controller';

@Module({
  controllers: [OcorrenciasController],
  providers: [OcorrenciasService],
  exports: [OcorrenciasService],
})
export class OcorrenciasModule {}