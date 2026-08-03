-- ============================================================================
-- Script de inicialização — PostgreSQL 16 + PostGIS (PRODUÇÃO)
-- Sistema PCPE
-- ============================================================================

-- Habilitar extensão pgcrypto (já referenciada no schema Prisma)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Habilitar PostGIS para suporte geoespacial
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;

-- Ajustes de performance para produção
ALTER SYSTEM SET shared_buffers = '512MB';
ALTER SYSTEM SET effective_cache_size = '1536MB';
ALTER SYSTEM SET work_mem = '32MB';
ALTER SYSTEM SET maintenance_work_mem = '128MB';
ALTER SYSTEM SET random_page_cost = 1.1;
ALTER SYSTEM SET effective_io_concurrency = 200;

-- Nota: As tabelas serão criadas via Prisma Migrate (npx prisma migrate deploy)
-- Não crie tabelas manualmente aqui.
