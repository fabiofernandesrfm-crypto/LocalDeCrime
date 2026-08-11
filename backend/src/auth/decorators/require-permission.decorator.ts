import { SetMetadata } from '@nestjs/common';

export const PERMISSION_META = 'permissions';

/** Decorator que exige uma ou mais permissoes para acessar a rota. */
export const RequirePermission = (...permissions: string[]) =>
  SetMetadata(PERMISSION_META, permissions);