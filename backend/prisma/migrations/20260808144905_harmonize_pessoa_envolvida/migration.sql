-- AlterEnum
ALTER TYPE "TipoEnvolvimento" ADD VALUE 'NOTICIANTE';

-- AlterTable
ALTER TABLE "pessoas_envolvidas" ADD COLUMN     "identificada" BOOLEAN NOT NULL DEFAULT true,
ADD COLUMN     "nic" TEXT,
ALTER COLUMN "nome" DROP NOT NULL;
