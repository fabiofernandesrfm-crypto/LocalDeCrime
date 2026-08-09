import { IsString, IsOptional, IsInt, IsNumber, Min, Max, MinLength } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class CreateObjetoDto {
  @ApiPropertyOptional({ example: 'Celular' })
  @IsOptional() @IsString()
  categoria?: string;

  @ApiPropertyOptional({ example: 'iPhone 12 preto com trinca na tela' })
  @IsOptional() @IsString()
  descricao?: string;

  @ApiPropertyOptional({ example: 'Apple' })
  @IsOptional() @IsString()
  marca?: string;

  @ApiPropertyOptional({ example: 'iPhone 12' })
  @IsOptional() @IsString()
  modelo?: string;

  @ApiPropertyOptional({ example: 'SR123456789' })
  @IsOptional() @IsString()
  numeroSerie?: string;

  @ApiPropertyOptional({ example: 1, default: 1 })
  @IsOptional() @IsInt() @Min(1)
  quantidade?: number;

  @ApiPropertyOptional({ example: 'Trinca na tela, acompanha carregador' })
  @IsOptional() @IsString()
  caracteristicas?: string;

  @ApiPropertyOptional({ example: 'Apreendido' })
  @IsOptional() @IsString()
  situacao?: string;

  @ApiPropertyOptional({ example: 'Encaminhado para perícia' })
  @IsOptional() @IsString()
  destinacao?: string;

  @ApiPropertyOptional({ description: 'Responsável físico pela coleta' })
  @IsOptional() @IsString()
  coletadoPor?: string;

  @ApiPropertyOptional()
  @IsOptional() @IsString()
  destinatario?: string;

  @ApiPropertyOptional()
  @IsOptional() @IsString()
  docDestinatario?: string;

  @ApiPropertyOptional({ example: 'Proprietario' })
  @IsOptional() @IsString()
  vinculoDest?: string;

  @ApiPropertyOptional({ example: -8.04762 })
  @IsOptional() @IsNumber() @Min(-90) @Max(90)
  gpsLat?: number;

  @ApiPropertyOptional({ example: -34.87703 })
  @IsOptional() @IsNumber() @Min(-180) @Max(180)
  gpsLng?: number;

  @ApiPropertyOptional()
  @IsOptional() @IsString()
  observacoes?: string;

  @ApiPropertyOptional({ description: 'UUID da PessoaEnvolvida vinculada (opcional)' })
  @IsOptional() @IsString()
  pessoaId?: string;
}

export class UpdateObjetoDto {
  @ApiPropertyOptional() @IsOptional() @IsString() categoria?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() descricao?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() marca?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() modelo?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() numeroSerie?: string;
  @ApiPropertyOptional() @IsOptional() @IsInt() @Min(1) quantidade?: number;
  @ApiPropertyOptional() @IsOptional() @IsString() caracteristicas?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() situacao?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() destinacao?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() coletadoPor?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() destinatario?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() docDestinatario?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() vinculoDest?: string;
  @ApiPropertyOptional() @IsOptional() @IsNumber() @Min(-90) @Max(90) gpsLat?: number;
  @ApiPropertyOptional() @IsOptional() @IsNumber() @Min(-180) @Max(180) gpsLng?: number;
  @ApiPropertyOptional() @IsOptional() @IsString() observacoes?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() pessoaId?: string;
}