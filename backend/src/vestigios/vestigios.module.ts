import { Module } from '@nestjs/common';
import { VestigiosService } from './vestigios.service';
import { VestigiosController } from './vestigios.controller';

@Module({ controllers: [VestigiosController], providers: [VestigiosService] })
export class VestigiosModule {}