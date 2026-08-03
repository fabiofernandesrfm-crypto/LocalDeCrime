import {
  Injectable,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';
import { CreateUserDto, UpdateUserDto, UserResponseDto } from './dto/users.dto';

@Injectable()
export class UsersService {
  constructor(private readonly prisma: PrismaService) {}

  async create(dto: CreateUserDto): Promise<UserResponseDto> {
    const existing = await this.prisma.usuario.findFirst({
      where: {
        OR: [{ matricula: dto.matricula }, { email: dto.email }],
      },
    });

    if (existing) {
      throw new ConflictException(
        'Já existe um usuário com esta matrícula ou email.',
      );
    }

    const hashedPassword = await bcrypt.hash(dto.senha, 10);

    const user = await this.prisma.usuario.create({
      data: {
        ...dto,
        senha: hashedPassword,
      },
    });

    return this.mapToResponse(user);
  }

  async findAll(): Promise<UserResponseDto[]> {
    const users = await this.prisma.usuario.findMany({
      orderBy: { nome: 'asc' },
    });

    return users.map((u) => this.mapToResponse(u));
  }

  async findOne(id: string): Promise<UserResponseDto> {
    const user = await this.prisma.usuario.findUnique({
      where: { id },
    });

    if (!user) {
      throw new NotFoundException('Usuário não encontrado.');
    }

    return this.mapToResponse(user);
  }

  async update(id: string, dto: UpdateUserDto): Promise<UserResponseDto> {
    await this.findOne(id);

    const user = await this.prisma.usuario.update({
      where: { id },
      data: dto,
    });

    return this.mapToResponse(user);
  }

  async remove(id: string): Promise<void> {
    await this.findOne(id);

    await this.prisma.usuario.delete({
      where: { id },
    });
  }

  private mapToResponse(user: any): UserResponseDto {
    return {
      id: user.id,
      matricula: user.matricula,
      nome: user.nome,
      email: user.email,
      cargo: user.cargo,
      role: user.role,
      ativo: user.ativo,
      criadoEm: user.criadoEm,
    };
  }
}