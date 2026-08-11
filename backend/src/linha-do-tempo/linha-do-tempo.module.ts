import { Module } from '@nestjs/common';
import { LinhaTempoService } from './linha-tempo.service';
import { LinhaTempoController } from './linha-tempo.controller';

@Module({ controllers: [LinhaTempoController], providers: [LinhaTempoService], exports: [LinhaTempoService] })
export class LinhaTempoModule {}