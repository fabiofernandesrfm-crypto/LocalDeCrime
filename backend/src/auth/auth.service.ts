import {
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';
import { LoginDto, AuthResponseDto } from './dto/auth.dto';

/// LocalAuthenticationProvider — temporario.
/// Futuramente sera substituido por InstitutionalAuthenticationProvider
/// que consumira autenticacao institucional externa (SSO/LDAP).
/// A interface exposta para o restante do sistema (login, refresh, me)
/// deve permanecer a mesma.

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
      unidadeId: user.unidadeId,
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
        unidadeId: user.unidadeId,
      },
    };
  }

  async refresh(refreshToken: string): Promise<{ accessToken: string; refreshToken: string }> {
    let payload: any;
    try {
      payload = this.jwtService.verify(refreshToken, {
        secret: process.env.JWT_REFRESH_SECRET || 'refresh-fallback',
      });
    } catch {
      throw new UnauthorizedException('Refresh token inválido ou expirado.');
    }

    const user = await this.prisma.usuario.findUnique({
      where: { id: payload.sub },
    });

    if (!user || !user.ativo) {
      throw new UnauthorizedException('Usuário não autorizado.');
    }

    const newPayload = {
      sub: user.id,
      matricula: user.matricula,
      role: user.role,
    };

    const accessToken = this.jwtService.sign(newPayload);
    const newRefreshToken = this.jwtService.sign(newPayload, {
      secret: process.env.JWT_REFRESH_SECRET || 'refresh-fallback',
      expiresIn: '7d' as const,
    });

    return { accessToken, refreshToken: newRefreshToken };
  }

  async me(userId: string) {
    const user = await this.prisma.usuario.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new UnauthorizedException('Usuário não encontrado.');
    }

    return {
      id: user.id,
      matricula: user.matricula,
      nome: user.nome,
      email: user.email,
      cargo: user.cargo,
      role: user.role,
      unidadeId: user.unidadeId,
      ativo: user.ativo,
    };
  }
}