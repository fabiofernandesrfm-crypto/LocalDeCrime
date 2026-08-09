import { IsString, IsOptional, IsNumber, Min, Max } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class CreateVeiculoDto {
  @ApiPropertyOptional({ example: 'ABC1D23' })
  @IsOptional() @IsString()
  placa?: string;
  @ApiPropertyOptional({ example: 'Fiat' })
  @IsOptional() @IsString()
  marca?: string;
  @ApiPropertyOptional({ example: 'Uno' })
  @IsOptional() @IsString()
  modelo?: string;
  @ApiPropertyOptional({ example: '2020' })
  @IsOptional() @IsString()
  ano?: string;
  @ApiPropertyOptional({ example: 'Branco' })
  @IsOptional() @IsString()
  cor?: string;
  @ApiPropertyOptional({ example: 'Apreendido' })
  @IsOptional() @IsString()
  situacao?: string;
  @ApiPropertyOptional({ example: 'Encaminhado para pericia' })
  @IsOptional() @IsString()
  destinacao?: string;
  @ApiPropertyOptional({ description: 'Responsável operacional pelo recolhimento' })
  @IsOptional() @IsString()
  responsavel?: string;
  @ApiPropertyOptional()
  @IsOptional() @IsString()
  destinatario?: string;
  @ApiPropertyOptional()
  @IsOptional() @IsString()
  docDestinatario?: string;
  @ApiPropertyOptional()
  @IsOptional() @IsString()
  vinculo?: string;
  @ApiPropertyOptional({ example: -8.04762 })
  @IsOptional() @IsNumber() @Min(-90) @Max(90)
  gpsLat?: number;
  @ApiPropertyOptional({ example: -34.87703 })
  @IsOptional() @IsNumber() @Min(-180) @Max(180)
  gpsLng?: number;
  @ApiPropertyOptional()
  @IsOptional() @IsString()
  observacoes?: string;
}

export class UpdateVeiculoDto {
  @ApiPropertyOptional() @IsOptional() @IsString() placa?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() marca?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() modelo?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() ano?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() cor?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() situacao?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() destinacao?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() responsavel?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() destinatario?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() docDestinatario?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() vinculo?: string;
  @ApiPropertyOptional() @IsOptional() @IsNumber() @Min(-90) @Max(90) gpsLat?: number;
  @ApiPropertyOptional() @IsOptional() @IsNumber() @Min(-180) @Max(180) gpsLng?: number;
  @ApiPropertyOptional() @IsOptional() @IsString() observacoes?: string;
}