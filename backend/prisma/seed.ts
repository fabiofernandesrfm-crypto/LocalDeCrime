import { PrismaClient, Role } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Iniciando seed de desenvolvimento/homologação...');

  const senhaPadrao = await bcrypt.hash('admin123', 10);

  // ── 1. Municipio ───────────────────────────────────────────
  const municipio = await prisma.municipio.upsert({
    where: { id: 'hml-recife' },
    update: { codigoIbge: '261160', uf: 'PE' },
    create: {
      id: 'hml-recife',
      nome: 'Recife (HOMOLOGAÇÃO)',
      codigoIbge: '261160',
      uf: 'PE',
    },
  });

  // ── 2. Unidade ─────────────────────────────────────────────
  const unidade = await prisma.unidade.upsert({
    where: { id: 'hml-dhpp-unisa' },
    update: {
      tipo: 'DELEGACIA',
      municipioId: municipio.id,
    },
    create: {
      id: 'hml-dhpp-unisa',
      nome: 'DHPP — UNISA (HOMOLOGAÇÃO)',
      sigla: 'DHPP-HML',
      tipo: 'DELEGACIA',
      municipioId: municipio.id,
    },
  });
  console.log(`  Unidade: ${unidade.nome}`);

  // ── 3. Delegacia ───────────────────────────────────────────
  const delegacia = await prisma.delegacia.upsert({
    where: { id: 'hml-delegacia-dhpp' },
    update: {
      unidadeId: unidade.id,
      circunscricao: 'Homologação',
      titulo: 'Delegacia DHPP HML',
    },
    create: {
      id: 'hml-delegacia-dhpp',
      unidadeId: unidade.id,
      circunscricao: 'Homologação',
      titulo: 'Delegacia DHPP HML',
    },
  });
  console.log(`  Delegacia: ${delegacia.titulo}`);

  // ── 4. Usuários ────────────────────────────────────────────
  const agente = await prisma.usuario.upsert({
    where: { matricula: '987654' },
    update: { unidadeId: unidade.id },
    create: {
      matricula: '987654',
      nome: 'Ag. Campo Homologação',
      email: 'agente.campo@homologacao.pcpe.gov.br',
      senha: senhaPadrao,
      cargo: 'Agente de Polícia Civil',
      role: Role.AGENTE,
      unidadeId: unidade.id,
    },
  });

  const chefe = await prisma.usuario.upsert({
    where: { matricula: '876543' },
    update: { unidadeId: unidade.id },
    create: {
      matricula: '876543',
      nome: 'Adm. Local Homologação',
      email: 'adm.local@homologacao.pcpe.gov.br',
      senha: senhaPadrao,
      cargo: 'Chefe de Unidade',
      role: Role.CHEFE_EQUIPE,
      unidadeId: unidade.id,
    },
  });

  const gestor = await prisma.usuario.upsert({
    where: { matricula: '765432' },
    update: { unidadeId: unidade.id },
    create: {
      matricula: '765432',
      nome: 'Gestor Homologação',
      email: 'gestor@homologacao.pcpe.gov.br',
      senha: senhaPadrao,
      cargo: 'Gestor de Departamento',
      role: Role.ADMIN,
      unidadeId: unidade.id,
    },
  });

  console.log('✅ Seed concluído com sucesso.');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(`  Unidade:  ${unidade.nome}`);
  console.log(`  Delegacia: ${delegacia.titulo}`);
  console.log('  Senha (todos): admin123');
  console.log(`  Campo:     matrícula=${agente.matricula}`);
  console.log(`  Admin:     matrícula=${chefe.matricula}`);
  console.log(`  Gestor:    matrícula=${gestor.matricula}`);
  console.log('⚠️  APENAS PARA DESENVOLVIMENTO/HOMOLOGAÇÃO.');
}

main()
  .catch((e) => {
    console.error('❌ Erro no seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });