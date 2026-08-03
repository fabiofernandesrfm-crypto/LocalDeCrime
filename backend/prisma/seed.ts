import { PrismaClient, Role } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const adminExists = await prisma.usuario.findUnique({
    where: { matricula: '000001' },
  });

  if (adminExists) {
    console.log('🌱 Seed já executado anteriormente. Pulando...');
    return;
  }

  const senhaPadrao = await bcrypt.hash('admin123', 10);

  // Admin
  await prisma.usuario.create({
    data: {
      matricula: '000001',
      nome: 'Administrador do Sistema',
      email: 'admin@pcpe.gov.br',
      senha: senhaPadrao,
      cargo: 'Coordenador de TI',
      role: Role.ADMIN,
    },
  });

  // Usuários de exemplo
  await prisma.usuario.create({
    data: {
      matricula: '123456',
      nome: 'João Silva',
      email: 'joao.silva@pcpe.gov.br',
      senha: senhaPadrao,
      cargo: 'Perito Criminal',
      role: Role.PERITO,
    },
  });

  await prisma.usuario.create({
    data: {
      matricula: '234567',
      nome: 'Maria Santos',
      email: 'maria.santos@pcpe.gov.br',
      senha: senhaPadrao,
      cargo: 'Chefe de Equipe',
      role: Role.CHEFE_EQUIPE,
    },
  });

  await prisma.usuario.create({
    data: {
      matricula: '345678',
      nome: 'Carlos Oliveira',
      email: 'carlos.oliveira@pcpe.gov.br',
      senha: senhaPadrao,
      cargo: 'Agente de Campo',
      role: Role.AGENTE,
    },
  });

  console.log('🌱 Seed executado com sucesso!');
  console.log('📋 Usuários criados:');
  console.log('  Admin:    matrícula=000001, senha=admin123');
  console.log('  Perito:   matrícula=123456, senha=admin123');
  console.log('  Chefe:    matrícula=234567, senha=admin123');
  console.log('  Agente:   matrícula=345678, senha=admin123');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });