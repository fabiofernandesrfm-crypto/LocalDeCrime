import {
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';
import { LoginDto, AuthResponseDto } from './dto/auth.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly jwtService: JwtService,
  ) {}

  async login(dto: LoginDto): Promise<AuthResponseDto> {
    const user = await this.prisma.usuario.findUnique({
      where: { matricula: dto.matricula },
    });

    if (!user) {
      throw new UnauthorizedException('Matrícula ou senha inválidos.');
    }

    if (!user.ativo) {
      throw new UnauthorizedException('Usuário desativado.');
    }

    const isPasswordValid = await bcrypt.compare(dto.senha, user.senha);

    if (!isPasswordValid) {
      throw new UnauthorizedException('Matrícula ou senha inválidos.');
    }

    const payload = {
      sub: user.id,
      matricula: user.matricula,
      role: user.role,
    };

    const accessToken = this.jwtService.sign(payload);
    const refreshToken = this.jwtService.sign(payload, {
      secret: process.env.JWT_REFRESH_SECRET || 'refresh-fallback',
      expiresIn: '7d' as const,
    });

    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        matricula: user.matricula,
        nome: user.nome,
        email: user.email,
        cargo: user.cargo,
        role: user.role,
      },
    };
  }
}