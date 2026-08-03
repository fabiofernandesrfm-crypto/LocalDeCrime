import {
  IsString,
  IsEmail,
  IsOptional,
  IsEnum,
  IsBoolean,
  MinLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Role } from '@prisma/client';

export class CreateUserDto {
  @ApiProperty({ example: '123456' })
  @IsString()
  @MinLength(3)
  matricula: string;

  @ApiProperty({ example: 'João Silva' })
  @IsString()
  @MinLength(3)
  nome: string;

  @ApiProperty({ example: 'joao.silva@pcpe.gov.br' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'senha123' })
  @IsString()
  @MinLength(6)
  senha: string;

  @ApiPropertyOptional({ example: 'Perito Criminal' })
  @IsOptional()
  @IsString()
  cargo?: string;

  @ApiPropertyOptional({ enum: Role, example: Role.PERITO })
  @IsOptional()
  @IsEnum(Role)
  role?: Role;
}

export class UpdateUserDto {
  @ApiPropertyOptional({ example: 'João Silva' })
  @IsOptional()
  @IsString()
  @MinLength(3)
  nome?: string;

  @ApiPropertyOptional({ example: 'joao.silva@pcpe.gov.br' })
  @IsOptional()
  @IsEmail()
  email?: string;

  @ApiPropertyOptional({ example: 'Perito Criminal' })
  @IsOptional()
  @IsString()
  cargo?: string;

  @ApiPropertyOptional({ enum: Role })
  @IsOptional()
  @IsEnum(Role)
  role?: Role;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  ativo?: boolean;
}

export class UserResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  matricula: string;

  @ApiProperty()
  nome: string;

  @ApiProperty()
  email: string;

  @ApiProperty()
  cargo: string | null;

  @ApiProperty({ enum: Role })
  role: Role;

  @ApiProperty()
  ativo: boolean;

  @ApiProperty()
  criadoEm: Date;
}