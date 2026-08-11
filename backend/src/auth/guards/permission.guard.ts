import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PrismaService } from '../../prisma/prisma.service';
import { PERMISSION_META } from '../decorators/require-permission.decorator';

@Injectable()
export class PermissionGuard implements CanActivate {
  constructor(private readonly reflector: Reflector, private readonly prisma: PrismaService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const required = this.reflector.get<string[]>(PERMISSION_META, context.getHandler());
    if (!required || required.length === 0) return true; // rota sem metadata

    const req = context.switchToHttp().getRequest();
    const user = req.user;
    if (!user?.id) return false; // nao autenticado

    const usuario = await this.prisma.usuario.findUnique({
      where: { id: user.id },
      select: {
        id: true,
        usuarioPerfis: {
          where: { perfil: { ativo: true, deletadoEm: null } },
          select: {
            perfil: {
              select: {
                perfilPermissoes: {
                  where: { permissao: { deletadoEm: null } },
                  select: { permissao: { select: { codigo: true } } },
                },
              },
            },
          },
        },
      },
    });

    const userPermissions = new Set<string>();
    if (usuario?.usuarioPerfis) {
      for (const up of usuario.usuarioPerfis) {
        for (const pp of up.perfil.perfilPermissoes) {
          userPermissions.add(pp.permissao.codigo);
        }
      }
    }

    const missing = required.filter((p) => !userPermissions.has(p));
    if (missing.length > 0) {
      throw new ForbiddenException('Você não possui permissão para executar esta operação.');
    }

    return true;
  }
}