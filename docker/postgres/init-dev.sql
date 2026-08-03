-- ============================================================================
-- Script de inicialização — PostgreSQL 16 + PostGIS (DESENVOLVIMENTO)
-- Sistema PCPE
-- ============================================================================

-- Habilitar extensão pgcrypto (já referenciada no schema Prisma)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Habilitar PostGIS para suporte geoespacial futuro
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder;

-- Nota: As tabelas serão criadas via Prisma Migrate (npx prisma migrate dev)
-- Não crie tabelas manualmente aqui. Este script serve apenas para extensões e configurações.