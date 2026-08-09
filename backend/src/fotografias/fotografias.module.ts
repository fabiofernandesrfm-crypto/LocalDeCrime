import { Module } from '@nestjs/common';
import { FotografiasService } from './fotografias.service';
import { FotografiasController } from './fotografias.controller';

@Module({ controllers: [FotografiasController], providers: [FotografiasService] })
export class FotografiasModule {}