# INFRASTRUCTURE_REVIEW.md

## Revisão da Infraestrutura — Sistema de Registro de Atendimento em Local de Crime (PCPE)

**Data:** 01/08/2026
**Versão:** 1.0.0
**Autor:** Equipe de Desenvolvimento PCPE

---

## 1. Resumo Executivo

Este documento consolida a revisão completa da infraestrutura do sistema PCPE, abrangendo todas as etapas de padronização, reestruturação e preparação do ambiente para desenvolvimento e produção.

| Etapa | Status | Descrição |
|-------|--------|-----------|
| 1. Verificar versões instaladas | ✅ Concluído | Node.js, npm, NestJS CLI, Prisma, Docker |
| 2. Padronizar versões do Prisma | ✅ Concluído | CLI e @prisma/client alinhados em v5.22.0 |
| 3. Reestruturar Docker | ✅ Concluído | docker-compose.dev.yml + docker-compose.prod.yml |
| 4. Configurar PostgreSQL 16 + PostGIS | ✅ Concluído | Container `pcpe_postgres_dev` com PostGIS 3.4 |
| 5. Remover migrations temporárias | ✅ Concluído | Apenas `20260801180401_initial_official` mantida |
| 6. Verificar banco limpo | ✅ Concluído | 50 tabelas no schema `public`, sem dados residuais |
| 7. Preparar ambiente para 1ª migration oficial | ✅ Concluído | Migration aplicada, Prisma Client regenerado, build OK |
| 8. Criar INFRASTRUCTURE_REVIEW.md | ✅ Concluído | Este documento |

---

## 2. Stack Tecnológica

### Backend
| Componente | Versão | Observações |
|------------|--------|-------------|
| Node.js | 24.x (current) | Runtime JavaScript/TypeScript |
| npm | 10.x | Gerenciador de pacotes |
| NestJS | 11.0.x | Framework backend |
| TypeScript | 5.7.x | Linguagem |
| Prisma CLI | 5.22.0 | ORM e migration tool |
| @prisma/client | 5.22.0 | Cliente gerado para o banco |
| PostgreSQL | 16 | Banco de dados (via Docker) |
| PostGIS | 3.4 | Extensão geoespacial |
| pgcrypto | — | Extensão para UUID (gen_random_uuid) |
| Passport + JWT | 0.7.0 / 11.0.2 | Autenticação |
| Swagger | 11.4.6 | Documentação da API |
| Winston | 3.19.0 | Logging |
| Helmet | 8.3.0 | Segurança HTTP |

### Frontend
| Componente | Versão | Observações |
|------------|--------|-------------|
| Flutter | SDK estável | Framework mobile/web |
| Dart | — | Linguagem |
| provider | — | Gerenciamento de estado |

### Infraestrutura
| Componente | Versão | Observações |
|------------|--------|-------------|
| Docker | 24+ | Containerização |
| Docker Compose | v3.8 | Orquestração |
| pgAdmin 4 | latest | Interface de administração (porta 5050) |

---

## 3. Estrutura de Diretórios Docker

```
docker/
├── postgres/
│   ├── init-dev.sql        # Script de inicialização do banco dev
│   └── init-prod.sql       # Script de inicialização do banco prod
├── pgadmin/                # Configurações do pgAdmin (futuro)
├── redis/                  # Cache (futuro)
├── rabbitmq/               # Fila de mensagens (futuro)
├── minio/                  # Armazenamento de objetos (futuro)
└── scripts/                # Scripts utilitários (futuro)
```

---

## 4. Arquivos Docker Compose

### 4.1 docker-compose.dev.yml

Ambiente de **desenvolvimento** com:
- PostgreSQL 16 + PostGIS 3.4 (porta `5434`)
- pgAdmin 4 (porta `5050`)
- Volume persistente `pcpe_pgdata_dev`
- Healthcheck configurado
- Rede dedicada `pcpe_network_dev`

### 4.2 docker-compose.prod.yml

Ambiente de **produção** com:
- PostgreSQL 16 + PostGIS 3.4
- pgAdmin 4
- Segurança adicional (sem portas expostas desnecessariamente)
- Volume persistente `pcpe_pgdata_prod`
- Rede dedicada `pcpe_network_prod`

### Comandos úteis
```bash
# Ambiente de desenvolvimento
docker compose -f docker-compose.dev.yml up -d
docker compose -f docker-compose.dev.yml down
docker compose -f docker-compose.dev.yml down -v  # Limpa volumes

# Ambiente de produção
docker compose -f docker-compose.prod.yml up -d
docker compose -f docker-compose.prod.yml down
```

---

## 5. Configuração de Ambiente (.env)

Arquivo `.env` na raiz do projeto (não versionado):

| Variável | Valor (dev) | Descrição |
|----------|-------------|-----------|
| POSTGRES_USER | pcpe_admin | Usuário do banco |
| POSTGRES_PASSWORD | pcpe_secret_2026 | Senha do banco |
| POSTGRES_DB | pcpe_db | Nome do banco |
| POSTGRES_PORT | 5434 | Porta do PostgreSQL |
| PGADMIN_EMAIL | admin@pcpe.gov.br | Email do pgAdmin |
| PGADMIN_PASSWORD | admin_secret_2026 | Senha do pgAdmin |
| PGADMIN_PORT | 5050 | Porta do pgAdmin |
| DATABASE_URL | postgresql://pcpe_admin:pcpe_secret_2026@localhost:5434/pcpe_db?schema=public | URL de conexão Prisma |
| JWT_SECRET | pcpe_jwt_super_secret_key_2026_change_in_production | Chave secreta JWT |
| JWT_EXPIRATION | 8h | Expiração do token |
| JWT_REFRESH_SECRET | pcpe_jwt_refresh_super_secret_2026_change_in_production | Chave do refresh token |
| JWT_REFRESH_EXPIRATION | 7d | Expiração do refresh token |
| PORT | 3000 | Porta da aplicação NestJS |
| NODE_ENV | development | Ambiente atual |

---

## 6. Histórico de Migrations

### 6.1 Situação Anterior (problemas resolvidos)
- Múltiplas migrations temporárias geradas durante o desenvolvimento inicial
- Nomes inconsistentes e dados de teste misturados com estrutura
- Schema desatualizado vs. código da aplicação

### 6.2 Limpeza Realizada
- Remoção de todas as migrations temporárias do diretório `backend/prisma/migrations/`
- Reset completo do banco de dados
- Recriação da estrutura via init-dev.sql

### 6.3 Migration Oficial Atual

| Campo | Valor |
|-------|-------|
| Nome | `20260801180401_initial_official` |
| Data | 01/08/2026 18:04:01 UTC |
| Status | Aplicada (Database schema is up to date!) |
| Tabelas Criadas | 50 tabelas + extensão pgcrypto |
| Enums | 26 tipos enumerados |

---

## 7. Schema do Banco de Dados

### 7.1 Visão Geral

O schema está documentado em detalhes nos arquivos:
- `DATABASE_ARCHITECTURE.md` — Documento de arquitetura
- `SCHEMA_SUMMARY.md` — Resumo estruturado
- `backend/prisma/schema.prisma` — Schema Prisma (fonte da verdade)

### 7.2 Domínios

| # | Domínio | Tabelas principais |
|---|---------|-------------------|
| 1 | Autenticação e Usuários | usuarios, perfis, permissoes, sessoes, refresh_tokens |
| 2 | Estrutura Organizacional | unidades, delegacias, institutos, departamentos, municipios |
| 3 | Ocorrências e Atendimentos | ocorrencias, atendimentos_local, policiais_participantes |
| 4 | Equipes | equipes, equipe_usuarios |
| 5 | Pessoas Envolvidas | pessoas_envolvidas |
| 6 | Vestígios e Cadeia de Custódia | vestigios, cadeia_custodia, tipos_vestigio, acondicionamentos, destinos_vestigio |
| 7 | Objetos e Itens Apreendidos | objetos, armas, municoes, drogas, veiculos + tabelas de tipo |
| 8 | Mídias | fotografias, videos, audios, documentos_anexos, midia_tags |
| 9 | Assinaturas | assinaturas, tipos_assinatura |
| 10 | Auditoria e Infra | auditorias, logs_sistema, historico_alteracoes, linhas_tempo, configuracoes, dispositivos, sincronizacao_offline, fila_sincronizacao, backups_registro |

### 7.3 Características Técnicas
- **UUIDs:** Todas as chaves primárias usam UUID v4 (gerados via `@default(uuid())` do Prisma)
- **Extensões:** `pgcrypto` (habilitada via migration)
- **Soft Delete:** Modelos com campo `deletadoEm` (DateTime?) com índices
- **Timestamps:** `criadoEm` (createdAt) e `atualizadoEm` (updatedAt) em todos os modelos
- **Versionamento:** `AtendimentoLocal` e `Vestigio` com campo `versao`
- **Auditoria:** Tabelas dedicadas para auditoria, logs e histórico de alterações
- **JSONB:** Uso extensivo para dados flexíveis (coordenadas, metadados, contexto)

---

## 8. Estado Atual do Ambiente

### 8.1 Containers em Execução

| Container | Status | Portas |
|-----------|--------|--------|
| pcpe_postgres_dev | Up (healthy) | 5434:5432 |
| pcpe_pgadmin | Up | 5050:80 |

### 8.2 Banco de Dados
- **Host:** localhost:5434
- **Database:** pcpe_db
- **Schema:** public
- **Tabelas:** 50 tabelas criadas
- **Extensões:** pgcrypto
- **Dados:** Banco limpo (sem dados de seed aplicados)

### 8.3 Prisma
- **Versão CLI:** 5.22.0
- **Versão Client:** 5.22.0 (regenerado em 01/08/2026)
- **Migration Status:** Up to date
- **Preview Features:** fullTextSearch, postgresqlExtensions

### 8.4 Backend (NestJS)
- **Build:** Compilando sem erros TypeScript
- **Model Prisma:** `atendimentoLocal` (substituiu o antigo `atendimento`)

---

## 9. Próximos Passos Recomendados

### 9.1 Imediatos (Curto Prazo)
1. **Executar seed inicial:** Popular banco com dados de exemplo (usuário admin, municípios PE, tipos de vestígio)
   ```bash
   cd backend && npx prisma db seed
   ```
2. **Iniciar backend e testar rotas:**
   ```bash
   cd backend && npm run start:dev
   ```
3. **Acessar Swagger:** http://localhost:3000/api/docs
4. **Validar CRUDs:** Testar endpoints de usuários e atendimentos
5. **Acessar pgAdmin:** http://localhost:5050 (admin@pcpe.gov.br / admin_secret_2026)

### 9.2 Médio Prazo
1. Implementar RBAC completo (perfis e permissões no seed)
2. Configurar Redis para cache de sessão
3. Implementar fila de sincronização offline
4. Criar testes de integração para todos os domínios
5. Configurar CI/CD

### 9.3 Longo Prazo
1. Implementar PostGIS para consultas geoespaciais
2. Configurar RabbitMQ para processamento assíncrono de mídias
3. Implementar MinIO para armazenamento de arquivos
4. Criar backup automatizado do banco
5. Migrar para Kubernetes em produção

---

## 10. Troubleshooting

### Problemas Conhecidos e Soluções

| Problema | Causa | Solução |
|----------|-------|---------|
| `prisma generate` falha | Prisma CLI desatualizado | `npm install prisma@5.22.0 -D` |
| Migration inconsistente | Schema alterado sem migration | `npx prisma migrate dev --name <nome>` |
| Banco não acessível | Container parado | `docker compose -f docker-compose.dev.yml up -d postgres` |
| Porta 5434 em uso | Container antigo ou outro serviço | `docker ps` e `docker stop <container>` |
| `Relation not found` | Migration não aplicada | `npx prisma migrate deploy` ou `npx prisma migrate dev` |
| `Property does not exist` | Model Prisma renomeado | Verificar schema.prisma e atualizar código |

---

## 11. Referências

- [Prisma Docs](https://www.prisma.io/docs)
- [NestJS Docs](https://docs.nestjs.com)
- [PostGIS Docs](https://postgis.net/documentation/)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [DATABASE_ARCHITECTURE.md](./DATABASE_ARCHITECTURE.md) — Arquitetura detalhada
- [SCHEMA_SUMMARY.md](./SCHEMA_SUMMARY.md) — Resumo do schema
- [backend/prisma/schema.prisma](./backend/prisma/schema.prisma) — Schema Prisma (fonte da verdade)