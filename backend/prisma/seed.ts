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

  // ── 4. Permissões RBAC ─────────────────────────────────────
  await seedPermissoes(prisma);

  // ── 5. Perfis e Associações RBAC HML ───────────────────────
  await seedRbacHomologacao(prisma);

  // ── 6. Usuários ────────────────────────────────────────────
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

async function seedRbacHomologacao(prisma: PrismaClient) {
  // Perfis de homologação RBAC
  const perfilCritico = await prisma.perfil.upsert({
    where: { id: 'hml-rbac-critico' },
    update: { nome: 'HML_RBAC_CRITICO', descricao: 'Homologação: operações críticas de ocorrência.', ativo: true },
    create: { id: 'hml-rbac-critico', nome: 'HML_RBAC_CRITICO', descricao: 'Homologação: operações críticas de ocorrência.', ativo: true },
  });
  const perfilSemCriticas = await prisma.perfil.upsert({
    where: { id: 'hml-rbac-sem-criticas' },
    update: { nome: 'HML_RBAC_SEM_CRITICAS', descricao: 'Homologação: sem permissões críticas.', ativo: true },
    create: { id: 'hml-rbac-sem-criticas', nome: 'HML_RBAC_SEM_CRITICAS', descricao: 'Homologação: sem permissões críticas.', ativo: true },
  });

  // Buscar permissões do catálogo
  const pFinalizar = await prisma.permissao.findUnique({ where: { codigo: 'OCORRENCIA_FINALIZAR' } });
  const pReabrir  = await prisma.permissao.findUnique({ where: { codigo: 'OCORRENCIA_REABRIR' } });
  const pArquivar = await prisma.permissao.findUnique({ where: { codigo: 'OCORRENCIA_ARQUIVAR' } });

  // Associar permissões ao perfil crítico (idempotente com createMany skipDuplicates)
  if (pFinalizar && pReabrir && pArquivar) {
    await prisma.perfilPermissao.createMany({
      data: [
        { perfilId: perfilCritico.id, permissaoId: pFinalizar.id },
        { perfilId: perfilCritico.id, permissaoId: pReabrir.id },
        { perfilId: perfilCritico.id, permissaoId: pArquivar.id },
      ],
      skipDuplicates: true,
    });
  }

  // Usuario A (matrícula 876543 - Adm. Local) → recebe perfil crítico
  // Usuario B (matrícula 987654 - Ag. Campo) → recebe perfil sem críticas
  await prisma.usuarioPerfil.createMany({
    data: [
      { usuarioId: (await prisma.usuario.findUnique({ where: { matricula: '876543' } }))!.id, perfilId: perfilCritico.id },
      { usuarioId: (await prisma.usuario.findUnique({ where: { matricula: '987654' } }))!.id, perfilId: perfilSemCriticas.id },
    ],
    skipDuplicates: true,
  });

  console.log('  RBAC HML: perfil crítico → matrícula 876543 | perfil sem críticas → matrícula 987654');
}

async function seedPermissoes(prisma: PrismaClient) {
  const catalogo = [
    { codigo: 'OCORRENCIA_FINALIZAR', modulo: 'OCORRENCIAS', descricao: 'Permite finalizar ocorrências.' },
    { codigo: 'OCORRENCIA_REABRIR',  modulo: 'OCORRENCIAS', descricao: 'Permite reabrir ocorrências concluídas.' },
    { codigo: 'OCORRENCIA_ARQUIVAR', modulo: 'OCORRENCIAS', descricao: 'Permite arquivar ocorrências concluídas.' },
  ];

  let sincronizadas = 0;
  for (const p of catalogo) {
    await prisma.permissao.upsert({
      where: { codigo: p.codigo },
      update: { modulo: p.modulo, descricao: p.descricao, deletadoEm: null },
      create: { codigo: p.codigo, modulo: p.modulo, descricao: p.descricao },
    });
    sincronizadas++;
  }
  console.log(`  Permissões RBAC sincronizadas: ${sincronizadas}`);
}

main()
  .catch((e) => {
    console.error('❌ Erro no seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });