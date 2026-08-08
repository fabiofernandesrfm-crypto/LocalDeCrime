import { PrismaClient, Role } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Iniciando seed de desenvolvimento/homologação...');

  const senhaPadrao = await bcrypt.hash('admin123', 10);

  // ── Município ──────────────────────────────────────────────
  const municipio = await prisma.municipio.upsert({
    where: { id: 'hml-recife' },
    update: {},
    create: {
      id: 'hml-recife',
      nome: 'Recife (HOMOLOGAÇÃO)',
      codigoIbge: '261160',
      uf: 'PE',
    },
  });

  // ── Unidade (Departamento — DHPP) ──────────────────────────
  const unidade = await prisma.unidade.upsert({
    where: { id: 'hml-dhpp-unisa' },
    update: {},
    create: {
      id: 'hml-dhpp-unisa',
      nome: 'DHPP — UNISA (HOMOLOGAÇÃO)',
      sigla: 'DHPP-HML',
      tipo: 'DEPARTAMENTO',
      municipioId: municipio.id,
    },
  });
  console.log(`  Unidade: ${unidade.nome}`);

  // ── Usuário de Campo (FIELD_USER) ──────────────────────────
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
  console.log(`  Usuário de Campo: ${agente.nome} (matrícula=${agente.matricula})`);

  // ── Administrador Local (UNIT_ADMIN) ───────────────────────
  // CHEFE_EQUIPE usado TEMPORARIAMENTE como equivalente ao futuro UNIT_ADMIN
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
  console.log(`  Administrador Local: ${chefe.nome} (matrícula=${chefe.matricula})`);

  // ── Gestor (MANAGER) ───────────────────────────────────────
  // ADMIN usado TEMPORARIAMENTE como equivalente ao futuro MANAGER
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
  console.log(`  Gestor: ${gestor.nome} (matrícula=${gestor.matricula})`);

  console.log('\n✅ Seed concluído com sucesso.');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('📋 Credenciais de desenvolvimento/homologação:');
  console.log(`  Unidade: ${unidade.nome}`);
  console.log('  Senha padrão (todos):   admin123');
  console.log(`  Usuário de Campo:       matrícula=${agente.matricula}`);
  console.log(`  Administrador Local:    matrícula=${chefe.matricula}`);
  console.log(`  Gestor:                 matrícula=${gestor.matricula}`);
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log('⚠️  SEED APENAS PARA DESENVOLVIMENTO/HOMOLOGAÇÃO.');
  console.log('⚠️  NÃO UTILIZAR ESTAS CREDENCIAIS EM PRODUÇÃO.');
}

main()
  .catch((e) => {
    console.error('❌ Erro no seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });