-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'CHEFE_EQUIPE', 'PERITO', 'AGENTE');

-- CreateEnum
CREATE TYPE "StatusAtendimento" AS ENUM ('ABERTO', 'EM_ANDAMENTO', 'CONCLUIDO', 'CANCELADO');

-- CreateEnum
CREATE TYPE "TipoLocal" AS ENUM ('RESIDENCIA', 'VIA_PUBLICA', 'ESTABELECIMENTO_COMERCIAL', 'AREA_RURAL', 'VEICULO', 'OUTRO');

-- CreateEnum
CREATE TYPE "TipoUnidade" AS ENUM ('DELEGACIA', 'INSTITUTO', 'DEPARTAMENTO');

-- CreateEnum
CREATE TYPE "StatusOcorrencia" AS ENUM ('ABERTA', 'EM_INVESTIGACAO', 'CONCLUIDA', 'ARQUIVADA');

-- CreateEnum
CREATE TYPE "TipoEnvolvimento" AS ENUM ('VITIMA', 'TESTEMUNHA', 'SUSPEITO', 'PROPRIETARIO', 'RESPONSAVEL', 'OUTRO');

-- CreateEnum
CREATE TYPE "StatusCadeia" AS ENUM ('COLETADO', 'ACONDICIONADO', 'TRANSPORTADO', 'RECEBIDO', 'EM_ANALISE', 'ANALISADO', 'DESCARTADO', 'DEVOLVIDO');

-- CreateEnum
CREATE TYPE "TipoEquipe" AS ENUM ('PERICIA', 'INVESTIGACAO', 'PLANTAO', 'ESPECIAL');

-- CreateEnum
CREATE TYPE "StatusEquipe" AS ENUM ('ATIVA', 'INATIVA', 'EM_DESLOCAMENTO', 'EM_ATENDIMENTO');

-- CreateEnum
CREATE TYPE "StatusSincronizacao" AS ENUM ('PENDENTE', 'ENVIADO', 'CONFIRMADO', 'CONFLITO', 'FALHA');

-- CreateEnum
CREATE TYPE "TipoMidia" AS ENUM ('FOTO', 'VIDEO', 'AUDIO', 'DOCUMENTO');

-- CreateEnum
CREATE TYPE "NivelLog" AS ENUM ('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL');

-- CreateEnum
CREATE TYPE "AcaoAuditoria" AS ENUM ('CRIAR', 'ATUALIZAR', 'DELETAR', 'VISUALIZAR', 'EXPORTAR', 'LOGIN', 'LOGOUT', 'FALHA_LOGIN');

-- CreateEnum
CREATE TYPE "TipoAssinatura" AS ENUM ('BIOMETRICA', 'CERTIFICADO_DIGITAL', 'PIN', 'SENHA');

-- CreateEnum
CREATE TYPE "StatusSessao" AS ENUM ('ATIVA', 'EXPIRADA', 'REVOGADA');

-- CreateEnum
CREATE TYPE "TipoAcondicionamento" AS ENUM ('SACO_PLASTICO', 'ENVELOPE_PAPEL', 'CAIXA_PAPELAO', 'TUBO_ENSAIO', 'FRASCO_VIDRO', 'LACRE_METALICO');

-- CreateEnum
CREATE TYPE "CategoriaObjeto" AS ENUM ('ELETRONICO', 'DOCUMENTO', 'JOIA', 'FERRAMENTA', 'VESTUARIO', 'OUTRO');

-- CreateEnum
CREATE TYPE "TipoArma" AS ENUM ('REVOLVER', 'PISTOLA', 'ESPINGARDA', 'FUZIL', 'FACA', 'FACAO', 'OUTRA_BRANCA', 'OUTRA_FOGO');

-- CreateEnum
CREATE TYPE "TipoMunicao" AS ENUM ('CALIBRE_22', 'CALIBRE_38', 'CALIBRE_380', 'CALIBRE_9MM', 'CALIBRE_12', 'CALIBRE_556', 'CALIBRE_762', 'OUTRO');

-- CreateEnum
CREATE TYPE "TipoDroga" AS ENUM ('MACONHA', 'COCAINA', 'CRACK', 'HEROINA', 'LSD', 'ECSTASY', 'METANFETAMINA', 'OUTRA');

-- CreateEnum
CREATE TYPE "MetodoAutenticacao" AS ENUM ('SENHA', 'BIOMETRIA', 'CERTIFICADO', 'SSO');

-- CreateEnum
CREATE TYPE "Sexo" AS ENUM ('MASCULINO', 'FEMININO', 'NAO_INFORMADO');

-- CreateEnum
CREATE TYPE "TipoPessoa" AS ENUM ('FISICA', 'JURIDICA');

-- CreateEnum
CREATE TYPE "StatusProcessamentoMidia" AS ENUM ('PENDENTE', 'PROCESSANDO', 'CONCLUIDO', 'FALHA');

-- CreateEnum
CREATE TYPE "FuncaoEquipe" AS ENUM ('CHEFE', 'PERITO', 'AGENTE', 'FOTOGRAFO', 'MOTORISTA', 'AUXILIAR');

-- CreateTable
CREATE TABLE "usuarios" (
    "id" TEXT NOT NULL,
    "matricula" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "cargo" TEXT,
    "role" "Role" NOT NULL DEFAULT 'AGENTE',
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "unidade_id" TEXT,

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "perfis" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),

    CONSTRAINT "perfis_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permissoes" (
    "id" TEXT NOT NULL,
    "codigo" TEXT NOT NULL,
    "descricao" TEXT,
    "modulo" TEXT NOT NULL,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),

    CONSTRAINT "permissoes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "usuario_perfis" (
    "usuario_id" TEXT NOT NULL,
    "perfil_id" TEXT NOT NULL,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "usuario_perfis_pkey" PRIMARY KEY ("usuario_id","perfil_id")
);

-- CreateTable
CREATE TABLE "perfil_permissoes" (
    "perfil_id" TEXT NOT NULL,
    "permissao_id" TEXT NOT NULL,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "perfil_permissoes_pkey" PRIMARY KEY ("perfil_id","permissao_id")
);

-- CreateTable
CREATE TABLE "sessoes" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "status" "StatusSessao" NOT NULL DEFAULT 'ATIVA',
    "ip_origem" TEXT,
    "user_agent" TEXT,
    "dispositivo_id" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expirado_em" TIMESTAMP(3),
    "usuario_id" TEXT NOT NULL,

    CONSTRAINT "sessoes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expira_em" TIMESTAMP(3) NOT NULL,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "revogado" BOOLEAN NOT NULL DEFAULT false,
    "sessao_id" TEXT NOT NULL,

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "unidades" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "sigla" TEXT,
    "tipo" "TipoUnidade" NOT NULL,
    "endereco" TEXT,
    "bairro" TEXT,
    "cep" TEXT,
    "telefone" TEXT,
    "email" TEXT,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "municipio_id" TEXT NOT NULL,

    CONSTRAINT "unidades_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "delegacias" (
    "id" TEXT NOT NULL,
    "circunscricao" TEXT,
    "titulo" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "unidade_id" TEXT NOT NULL,

    CONSTRAINT "delegacias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "institutos" (
    "id" TEXT NOT NULL,
    "especialidade" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "unidade_id" TEXT NOT NULL,

    CONSTRAINT "institutos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "departamentos" (
    "id" TEXT NOT NULL,
    "sigla" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "unidade_id" TEXT NOT NULL,

    CONSTRAINT "departamentos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "municipios" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "uf" TEXT NOT NULL DEFAULT 'PE',
    "codigo_ibge" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "municipios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ocorrencias" (
    "id" TEXT NOT NULL,
    "numero_bo" TEXT NOT NULL,
    "status" "StatusOcorrencia" NOT NULL DEFAULT 'ABERTA',
    "data_ocorrencia" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "data_conclusao" TIMESTAMP(3),
    "descricao" TEXT NOT NULL,
    "observacoes" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "municipio_id" TEXT NOT NULL,
    "delegacia_id" TEXT NOT NULL,
    "usuario_id" TEXT NOT NULL,

    CONSTRAINT "ocorrencias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "atendimentos_local" (
    "id" TEXT NOT NULL,
    "numero_registro" SERIAL NOT NULL,
    "status" "StatusAtendimento" NOT NULL DEFAULT 'ABERTO',
    "tipo_local" "TipoLocal" NOT NULL,
    "endereco" TEXT NOT NULL,
    "numero" TEXT,
    "complemento" TEXT,
    "bairro" TEXT NOT NULL,
    "cidade" TEXT NOT NULL,
    "estado" TEXT NOT NULL DEFAULT 'PE',
    "cep" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "descricao" TEXT NOT NULL,
    "observacoes" TEXT,
    "data_ocorrencia" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "data_conclusao" TIMESTAMP(3),
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "versao" INTEGER NOT NULL DEFAULT 1,
    "ocorrencia_id" TEXT NOT NULL,
    "usuario_id" TEXT NOT NULL,
    "equipe_id" TEXT,

    CONSTRAINT "atendimentos_local_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "equipes" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "tipo" "TipoEquipe" NOT NULL,
    "status" "StatusEquipe" NOT NULL DEFAULT 'ATIVA',
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "unidade_id" TEXT NOT NULL,

    CONSTRAINT "equipes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "equipe_usuarios" (
    "equipe_id" TEXT NOT NULL,
    "usuario_id" TEXT NOT NULL,
    "funcao" "FuncaoEquipe" NOT NULL DEFAULT 'AGENTE',
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "equipe_usuarios_pkey" PRIMARY KEY ("equipe_id","usuario_id")
);

-- CreateTable
CREATE TABLE "pessoas_envolvidas" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "cpf" TEXT,
    "rg" TEXT,
    "sexo" "Sexo" NOT NULL DEFAULT 'NAO_INFORMADO',
    "data_nascimento" TIMESTAMP(3),
    "telefone" TEXT,
    "endereco" TEXT,
    "bairro" TEXT,
    "cep" TEXT,
    "tipo_envolvimento" "TipoEnvolvimento" NOT NULL,
    "depoimento" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "ocorrencia_id" TEXT NOT NULL,
    "municipio_id" TEXT,

    CONSTRAINT "pessoas_envolvidas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "policiais_participantes" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "matricula" TEXT,
    "instituicao" TEXT,
    "funcao" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atendimento_local_id" TEXT NOT NULL,
    "usuario_id" TEXT,

    CONSTRAINT "policiais_participantes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tipos_vestigio" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),

    CONSTRAINT "tipos_vestigio_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "acondicionamentos" (
    "id" TEXT NOT NULL,
    "tipo" "TipoAcondicionamento" NOT NULL,
    "numero_lacre" TEXT,
    "descricao" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "acondicionamentos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "destinos_vestigio" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "destinos_vestigio_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vestigios" (
    "id" TEXT NOT NULL,
    "numero_custodia" TEXT NOT NULL,
    "descricao" TEXT NOT NULL,
    "quantidade" INTEGER NOT NULL DEFAULT 1,
    "local_coleta" TEXT,
    "observacoes" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "versao" INTEGER NOT NULL DEFAULT 1,
    "atendimento_local_id" TEXT NOT NULL,
    "tipo_vestigio_id" TEXT NOT NULL,
    "acondicionamento_id" TEXT,

    CONSTRAINT "vestigios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cadeia_custodia" (
    "id" TEXT NOT NULL,
    "status" "StatusCadeia" NOT NULL,
    "descricao" TEXT NOT NULL,
    "observacoes" TEXT,
    "data_hora" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "vestigio_id" TEXT NOT NULL,
    "usuario_id" TEXT NOT NULL,
    "destino_vestigio_id" TEXT,

    CONSTRAINT "cadeia_custodia_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categorias_objeto" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),

    CONSTRAINT "categorias_objeto_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "objetos" (
    "id" TEXT NOT NULL,
    "descricao" TEXT NOT NULL,
    "quantidade" INTEGER NOT NULL DEFAULT 1,
    "observacoes" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "atendimento_local_id" TEXT NOT NULL,
    "categoria_objeto_id" TEXT NOT NULL,

    CONSTRAINT "objetos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tipos_arma" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),

    CONSTRAINT "tipos_arma_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "armas" (
    "id" TEXT NOT NULL,
    "numero_serie" TEXT,
    "marca" TEXT,
    "modelo" TEXT,
    "calibre" TEXT,
    "observacoes" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "atendimento_local_id" TEXT NOT NULL,
    "tipo_arma_id" TEXT NOT NULL,

    CONSTRAINT "armas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tipos_municao" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),

    CONSTRAINT "tipos_municao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "municoes" (
    "id" TEXT NOT NULL,
    "quantidade" INTEGER NOT NULL DEFAULT 1,
    "marca" TEXT,
    "lote" TEXT,
    "observacoes" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "atendimento_local_id" TEXT NOT NULL,
    "tipo_municao_id" TEXT NOT NULL,

    CONSTRAINT "municoes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tipos_droga" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),

    CONSTRAINT "tipos_droga_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "drogas" (
    "id" TEXT NOT NULL,
    "peso_gramas" DOUBLE PRECISION,
    "unidade_medida" TEXT,
    "apresentacao" TEXT,
    "pureza_estimada" TEXT,
    "observacoes" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "atendimento_local_id" TEXT NOT NULL,
    "tipo_droga_id" TEXT NOT NULL,

    CONSTRAINT "drogas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "veiculos" (
    "id" TEXT NOT NULL,
    "placa" TEXT,
    "chassi" TEXT,
    "renavam" TEXT,
    "marca" TEXT,
    "modelo" TEXT,
    "cor" TEXT,
    "ano_fabricacao" INTEGER,
    "ano_modelo" INTEGER,
    "observacoes" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "atendimento_local_id" TEXT NOT NULL,

    CONSTRAINT "veiculos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "midia_tags" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "cor" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),

    CONSTRAINT "midia_tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "midia_midia_tags" (
    "id" TEXT NOT NULL,
    "midia_tag_id" TEXT NOT NULL,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fotografia_id" TEXT,
    "video_id" TEXT,
    "audio_id" TEXT,
    "documento_anexo_id" TEXT,

    CONSTRAINT "midia_midia_tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fotografias" (
    "id" TEXT NOT NULL,
    "arquivo_url" TEXT NOT NULL,
    "thumbnail_url" TEXT,
    "descricao" TEXT,
    "resolucao" TEXT,
    "tamanho_bytes" INTEGER,
    "formato" TEXT,
    "coordenadas" JSONB,
    "data_hora" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status_processamento" "StatusProcessamentoMidia" NOT NULL DEFAULT 'PENDENTE',
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "atendimento_local_id" TEXT NOT NULL,
    "usuario_id" TEXT NOT NULL,
    "vestigio_id" TEXT,
    "objeto_id" TEXT,
    "arma_id" TEXT,
    "municao_id" TEXT,
    "droga_id" TEXT,
    "veiculo_id" TEXT,

    CONSTRAINT "fotografias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "videos" (
    "id" TEXT NOT NULL,
    "arquivo_url" TEXT NOT NULL,
    "thumbnail_url" TEXT,
    "descricao" TEXT,
    "duracao_segundos" INTEGER,
    "resolucao" TEXT,
    "tamanho_bytes" INTEGER,
    "formato" TEXT,
    "status_processamento" "StatusProcessamentoMidia" NOT NULL DEFAULT 'PENDENTE',
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "atendimento_local_id" TEXT NOT NULL,
    "usuario_id" TEXT NOT NULL,

    CONSTRAINT "videos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audios" (
    "id" TEXT NOT NULL,
    "arquivo_url" TEXT NOT NULL,
    "descricao" TEXT,
    "duracao_segundos" INTEGER,
    "tamanho_bytes" INTEGER,
    "formato" TEXT,
    "transcricao" TEXT,
    "status_processamento" "StatusProcessamentoMidia" NOT NULL DEFAULT 'PENDENTE',
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "atendimento_local_id" TEXT NOT NULL,
    "usuario_id" TEXT NOT NULL,

    CONSTRAINT "audios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "documentos_anexos" (
    "id" TEXT NOT NULL,
    "arquivo_url" TEXT NOT NULL,
    "titulo" TEXT NOT NULL,
    "descricao" TEXT,
    "tipo_documento" TEXT,
    "tamanho_bytes" INTEGER,
    "formato" TEXT,
    "num_paginas" INTEGER,
    "status_processamento" "StatusProcessamentoMidia" NOT NULL DEFAULT 'PENDENTE',
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "deletado_em" TIMESTAMP(3),
    "atendimento_local_id" TEXT NOT NULL,
    "usuario_id" TEXT NOT NULL,

    CONSTRAINT "documentos_anexos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tipos_assinatura" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "descricao" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "tipos_assinatura_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assinaturas" (
    "id" TEXT NOT NULL,
    "hash" TEXT NOT NULL,
    "dados" JSONB,
    "data_hora" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ip_origem" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuario_id" TEXT NOT NULL,
    "tipo_assinatura_id" TEXT NOT NULL,
    "atendimento_local_id" TEXT,
    "cadeia_custodia_id" TEXT,
    "documento_anexo_id" TEXT,

    CONSTRAINT "assinaturas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "auditorias" (
    "id" TEXT NOT NULL,
    "acao" "AcaoAuditoria" NOT NULL,
    "entidade" TEXT NOT NULL,
    "entidade_id" TEXT,
    "valor_anterior" JSONB,
    "valor_novo" JSONB,
    "ip_origem" TEXT,
    "user_agent" TEXT,
    "data_hora" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuario_id" TEXT NOT NULL,
    "dispositivo_id" TEXT,

    CONSTRAINT "auditorias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "logs_sistema" (
    "id" TEXT NOT NULL,
    "nivel" "NivelLog" NOT NULL,
    "mensagem" TEXT NOT NULL,
    "contexto" JSONB,
    "origem" TEXT,
    "data_hora" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuario_id" TEXT,

    CONSTRAINT "logs_sistema_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "historico_alteracoes" (
    "id" TEXT NOT NULL,
    "entidade" TEXT NOT NULL,
    "entidade_id" TEXT NOT NULL,
    "dados_antes" JSONB NOT NULL,
    "dados_depois" JSONB NOT NULL,
    "versao" INTEGER NOT NULL,
    "motivo" TEXT,
    "data_hora" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuario_id" TEXT NOT NULL,
    "atendimento_local_id" TEXT,

    CONSTRAINT "historico_alteracoes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "linhas_tempo" (
    "id" TEXT NOT NULL,
    "evento" TEXT NOT NULL,
    "descricao" TEXT,
    "metadata" JSONB,
    "data_hora" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuario_id" TEXT NOT NULL,
    "ocorrencia_id" TEXT NOT NULL,
    "atendimento_local_id" TEXT,

    CONSTRAINT "linhas_tempo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "configuracoes" (
    "id" TEXT NOT NULL,
    "chave" TEXT NOT NULL,
    "valor" JSONB NOT NULL,
    "descricao" TEXT,
    "tipo" TEXT NOT NULL DEFAULT 'string',
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "configuracoes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dispositivos" (
    "id" TEXT NOT NULL,
    "device_id" TEXT NOT NULL,
    "nome" TEXT,
    "modelo" TEXT,
    "sistema_operacional" TEXT,
    "versao_app" TEXT,
    "ultimo_acesso" TIMESTAMP(3),
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizado_em" TIMESTAMP(3) NOT NULL,
    "usuario_id" TEXT NOT NULL,

    CONSTRAINT "dispositivos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sincronizacao_offline" (
    "id" TEXT NOT NULL,
    "tipo" TEXT NOT NULL,
    "data_inicio" TIMESTAMP(3) NOT NULL,
    "data_fim" TIMESTAMP(3),
    "status" "StatusSincronizacao" NOT NULL,
    "registros_enviados" INTEGER NOT NULL DEFAULT 0,
    "registros_recebidos" INTEGER NOT NULL DEFAULT 0,
    "conflitos_detectados" INTEGER NOT NULL DEFAULT 0,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "dispositivo_id" TEXT NOT NULL,

    CONSTRAINT "sincronizacao_offline_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fila_sincronizacao" (
    "id" TEXT NOT NULL,
    "entidade" TEXT NOT NULL,
    "entidade_id" TEXT NOT NULL,
    "acao" TEXT NOT NULL,
    "dados" JSONB NOT NULL,
    "data_operacao" TIMESTAMP(3) NOT NULL,
    "status" "StatusSincronizacao" NOT NULL DEFAULT 'PENDENTE',
    "tentativas" INTEGER NOT NULL DEFAULT 0,
    "ultima_tentativa" TIMESTAMP(3),
    "mensagem_erro" TEXT,
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuario_id" TEXT NOT NULL,
    "sincronizacao_offline_id" TEXT,

    CONSTRAINT "fila_sincronizacao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "backups_registro" (
    "id" TEXT NOT NULL,
    "tipo" TEXT NOT NULL,
    "tamanho_bytes" INTEGER,
    "local_armazenamento" TEXT,
    "hash_validacao" TEXT,
    "status" TEXT NOT NULL DEFAULT 'concluido',
    "observacoes" TEXT,
    "data_inicio" TIMESTAMP(3) NOT NULL,
    "data_fim" TIMESTAMP(3),
    "criado_em" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "usuario_id" TEXT NOT NULL,

    CONSTRAINT "backups_registro_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_matricula_key" ON "usuarios"("matricula");

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_email_key" ON "usuarios"("email");

-- CreateIndex
CREATE INDEX "usuarios_unidade_id_idx" ON "usuarios"("unidade_id");

-- CreateIndex
CREATE INDEX "usuarios_ativo_idx" ON "usuarios"("ativo");

-- CreateIndex
CREATE INDEX "usuarios_deletado_em_idx" ON "usuarios"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "perfis_nome_key" ON "perfis"("nome");

-- CreateIndex
CREATE INDEX "perfis_deletado_em_idx" ON "perfis"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "permissoes_codigo_key" ON "permissoes"("codigo");

-- CreateIndex
CREATE INDEX "permissoes_modulo_idx" ON "permissoes"("modulo");

-- CreateIndex
CREATE INDEX "permissoes_deletado_em_idx" ON "permissoes"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "sessoes_token_key" ON "sessoes"("token");

-- CreateIndex
CREATE INDEX "sessoes_usuario_id_idx" ON "sessoes"("usuario_id");

-- CreateIndex
CREATE INDEX "sessoes_status_idx" ON "sessoes"("status");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_token_key" ON "refresh_tokens"("token");

-- CreateIndex
CREATE INDEX "refresh_tokens_sessao_id_idx" ON "refresh_tokens"("sessao_id");

-- CreateIndex
CREATE INDEX "refresh_tokens_revogado_idx" ON "refresh_tokens"("revogado");

-- CreateIndex
CREATE INDEX "unidades_municipio_id_idx" ON "unidades"("municipio_id");

-- CreateIndex
CREATE INDEX "unidades_tipo_idx" ON "unidades"("tipo");

-- CreateIndex
CREATE INDEX "unidades_deletado_em_idx" ON "unidades"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "delegacias_unidade_id_key" ON "delegacias"("unidade_id");

-- CreateIndex
CREATE INDEX "delegacias_deletado_em_idx" ON "delegacias"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "institutos_unidade_id_key" ON "institutos"("unidade_id");

-- CreateIndex
CREATE INDEX "institutos_deletado_em_idx" ON "institutos"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "departamentos_unidade_id_key" ON "departamentos"("unidade_id");

-- CreateIndex
CREATE INDEX "departamentos_deletado_em_idx" ON "departamentos"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "municipios_codigo_ibge_key" ON "municipios"("codigo_ibge");

-- CreateIndex
CREATE INDEX "municipios_nome_idx" ON "municipios"("nome");

-- CreateIndex
CREATE INDEX "municipios_uf_idx" ON "municipios"("uf");

-- CreateIndex
CREATE UNIQUE INDEX "ocorrencias_numero_bo_key" ON "ocorrencias"("numero_bo");

-- CreateIndex
CREATE INDEX "ocorrencias_numero_bo_idx" ON "ocorrencias"("numero_bo");

-- CreateIndex
CREATE INDEX "ocorrencias_municipio_id_idx" ON "ocorrencias"("municipio_id");

-- CreateIndex
CREATE INDEX "ocorrencias_delegacia_id_idx" ON "ocorrencias"("delegacia_id");

-- CreateIndex
CREATE INDEX "ocorrencias_usuario_id_idx" ON "ocorrencias"("usuario_id");

-- CreateIndex
CREATE INDEX "ocorrencias_status_idx" ON "ocorrencias"("status");

-- CreateIndex
CREATE INDEX "ocorrencias_data_ocorrencia_idx" ON "ocorrencias"("data_ocorrencia");

-- CreateIndex
CREATE INDEX "ocorrencias_deletado_em_idx" ON "ocorrencias"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "atendimentos_local_numero_registro_key" ON "atendimentos_local"("numero_registro");

-- CreateIndex
CREATE INDEX "atendimentos_local_numero_registro_idx" ON "atendimentos_local"("numero_registro");

-- CreateIndex
CREATE INDEX "atendimentos_local_ocorrencia_id_idx" ON "atendimentos_local"("ocorrencia_id");

-- CreateIndex
CREATE INDEX "atendimentos_local_equipe_id_idx" ON "atendimentos_local"("equipe_id");

-- CreateIndex
CREATE INDEX "atendimentos_local_usuario_id_idx" ON "atendimentos_local"("usuario_id");

-- CreateIndex
CREATE INDEX "atendimentos_local_status_idx" ON "atendimentos_local"("status");

-- CreateIndex
CREATE INDEX "atendimentos_local_data_ocorrencia_idx" ON "atendimentos_local"("data_ocorrencia");

-- CreateIndex
CREATE INDEX "atendimentos_local_deletado_em_idx" ON "atendimentos_local"("deletado_em");

-- CreateIndex
CREATE INDEX "equipes_unidade_id_idx" ON "equipes"("unidade_id");

-- CreateIndex
CREATE INDEX "equipes_tipo_idx" ON "equipes"("tipo");

-- CreateIndex
CREATE INDEX "equipes_status_idx" ON "equipes"("status");

-- CreateIndex
CREATE INDEX "equipes_deletado_em_idx" ON "equipes"("deletado_em");

-- CreateIndex
CREATE INDEX "equipe_usuarios_usuario_id_idx" ON "equipe_usuarios"("usuario_id");

-- CreateIndex
CREATE INDEX "pessoas_envolvidas_ocorrencia_id_idx" ON "pessoas_envolvidas"("ocorrencia_id");

-- CreateIndex
CREATE INDEX "pessoas_envolvidas_cpf_idx" ON "pessoas_envolvidas"("cpf");

-- CreateIndex
CREATE INDEX "pessoas_envolvidas_municipio_id_idx" ON "pessoas_envolvidas"("municipio_id");

-- CreateIndex
CREATE INDEX "pessoas_envolvidas_tipo_envolvimento_idx" ON "pessoas_envolvidas"("tipo_envolvimento");

-- CreateIndex
CREATE INDEX "pessoas_envolvidas_deletado_em_idx" ON "pessoas_envolvidas"("deletado_em");

-- CreateIndex
CREATE INDEX "policiais_participantes_atendimento_local_id_idx" ON "policiais_participantes"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "policiais_participantes_usuario_id_idx" ON "policiais_participantes"("usuario_id");

-- CreateIndex
CREATE UNIQUE INDEX "tipos_vestigio_nome_key" ON "tipos_vestigio"("nome");

-- CreateIndex
CREATE INDEX "tipos_vestigio_deletado_em_idx" ON "tipos_vestigio"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "destinos_vestigio_nome_key" ON "destinos_vestigio"("nome");

-- CreateIndex
CREATE UNIQUE INDEX "vestigios_numero_custodia_key" ON "vestigios"("numero_custodia");

-- CreateIndex
CREATE INDEX "vestigios_atendimento_local_id_idx" ON "vestigios"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "vestigios_tipo_vestigio_id_idx" ON "vestigios"("tipo_vestigio_id");

-- CreateIndex
CREATE INDEX "vestigios_acondicionamento_id_idx" ON "vestigios"("acondicionamento_id");

-- CreateIndex
CREATE INDEX "vestigios_numero_custodia_idx" ON "vestigios"("numero_custodia");

-- CreateIndex
CREATE INDEX "vestigios_deletado_em_idx" ON "vestigios"("deletado_em");

-- CreateIndex
CREATE INDEX "cadeia_custodia_vestigio_id_idx" ON "cadeia_custodia"("vestigio_id");

-- CreateIndex
CREATE INDEX "cadeia_custodia_usuario_id_idx" ON "cadeia_custodia"("usuario_id");

-- CreateIndex
CREATE INDEX "cadeia_custodia_data_hora_idx" ON "cadeia_custodia"("data_hora");

-- CreateIndex
CREATE INDEX "cadeia_custodia_status_idx" ON "cadeia_custodia"("status");

-- CreateIndex
CREATE UNIQUE INDEX "categorias_objeto_nome_key" ON "categorias_objeto"("nome");

-- CreateIndex
CREATE INDEX "categorias_objeto_deletado_em_idx" ON "categorias_objeto"("deletado_em");

-- CreateIndex
CREATE INDEX "objetos_atendimento_local_id_idx" ON "objetos"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "objetos_categoria_objeto_id_idx" ON "objetos"("categoria_objeto_id");

-- CreateIndex
CREATE INDEX "objetos_deletado_em_idx" ON "objetos"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "tipos_arma_nome_key" ON "tipos_arma"("nome");

-- CreateIndex
CREATE INDEX "tipos_arma_deletado_em_idx" ON "tipos_arma"("deletado_em");

-- CreateIndex
CREATE INDEX "armas_atendimento_local_id_idx" ON "armas"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "armas_tipo_arma_id_idx" ON "armas"("tipo_arma_id");

-- CreateIndex
CREATE INDEX "armas_numero_serie_idx" ON "armas"("numero_serie");

-- CreateIndex
CREATE INDEX "armas_deletado_em_idx" ON "armas"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "tipos_municao_nome_key" ON "tipos_municao"("nome");

-- CreateIndex
CREATE INDEX "tipos_municao_deletado_em_idx" ON "tipos_municao"("deletado_em");

-- CreateIndex
CREATE INDEX "municoes_atendimento_local_id_idx" ON "municoes"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "municoes_tipo_municao_id_idx" ON "municoes"("tipo_municao_id");

-- CreateIndex
CREATE INDEX "municoes_deletado_em_idx" ON "municoes"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "tipos_droga_nome_key" ON "tipos_droga"("nome");

-- CreateIndex
CREATE INDEX "tipos_droga_deletado_em_idx" ON "tipos_droga"("deletado_em");

-- CreateIndex
CREATE INDEX "drogas_atendimento_local_id_idx" ON "drogas"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "drogas_tipo_droga_id_idx" ON "drogas"("tipo_droga_id");

-- CreateIndex
CREATE INDEX "drogas_deletado_em_idx" ON "drogas"("deletado_em");

-- CreateIndex
CREATE INDEX "veiculos_atendimento_local_id_idx" ON "veiculos"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "veiculos_placa_idx" ON "veiculos"("placa");

-- CreateIndex
CREATE INDEX "veiculos_chassi_idx" ON "veiculos"("chassi");

-- CreateIndex
CREATE INDEX "veiculos_deletado_em_idx" ON "veiculos"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "midia_tags_nome_key" ON "midia_tags"("nome");

-- CreateIndex
CREATE INDEX "midia_tags_deletado_em_idx" ON "midia_tags"("deletado_em");

-- CreateIndex
CREATE INDEX "midia_midia_tags_midia_tag_id_idx" ON "midia_midia_tags"("midia_tag_id");

-- CreateIndex
CREATE INDEX "midia_midia_tags_fotografia_id_idx" ON "midia_midia_tags"("fotografia_id");

-- CreateIndex
CREATE INDEX "midia_midia_tags_video_id_idx" ON "midia_midia_tags"("video_id");

-- CreateIndex
CREATE INDEX "midia_midia_tags_audio_id_idx" ON "midia_midia_tags"("audio_id");

-- CreateIndex
CREATE INDEX "midia_midia_tags_documento_anexo_id_idx" ON "midia_midia_tags"("documento_anexo_id");

-- CreateIndex
CREATE INDEX "fotografias_atendimento_local_id_idx" ON "fotografias"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "fotografias_usuario_id_idx" ON "fotografias"("usuario_id");

-- CreateIndex
CREATE INDEX "fotografias_vestigio_id_idx" ON "fotografias"("vestigio_id");

-- CreateIndex
CREATE INDEX "fotografias_objeto_id_idx" ON "fotografias"("objeto_id");

-- CreateIndex
CREATE INDEX "fotografias_arma_id_idx" ON "fotografias"("arma_id");

-- CreateIndex
CREATE INDEX "fotografias_municao_id_idx" ON "fotografias"("municao_id");

-- CreateIndex
CREATE INDEX "fotografias_droga_id_idx" ON "fotografias"("droga_id");

-- CreateIndex
CREATE INDEX "fotografias_veiculo_id_idx" ON "fotografias"("veiculo_id");

-- CreateIndex
CREATE INDEX "fotografias_deletado_em_idx" ON "fotografias"("deletado_em");

-- CreateIndex
CREATE INDEX "videos_atendimento_local_id_idx" ON "videos"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "videos_usuario_id_idx" ON "videos"("usuario_id");

-- CreateIndex
CREATE INDEX "videos_deletado_em_idx" ON "videos"("deletado_em");

-- CreateIndex
CREATE INDEX "audios_atendimento_local_id_idx" ON "audios"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "audios_usuario_id_idx" ON "audios"("usuario_id");

-- CreateIndex
CREATE INDEX "audios_deletado_em_idx" ON "audios"("deletado_em");

-- CreateIndex
CREATE INDEX "documentos_anexos_atendimento_local_id_idx" ON "documentos_anexos"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "documentos_anexos_usuario_id_idx" ON "documentos_anexos"("usuario_id");

-- CreateIndex
CREATE INDEX "documentos_anexos_deletado_em_idx" ON "documentos_anexos"("deletado_em");

-- CreateIndex
CREATE UNIQUE INDEX "tipos_assinatura_nome_key" ON "tipos_assinatura"("nome");

-- CreateIndex
CREATE INDEX "assinaturas_usuario_id_idx" ON "assinaturas"("usuario_id");

-- CreateIndex
CREATE INDEX "assinaturas_tipo_assinatura_id_idx" ON "assinaturas"("tipo_assinatura_id");

-- CreateIndex
CREATE INDEX "assinaturas_atendimento_local_id_idx" ON "assinaturas"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "assinaturas_cadeia_custodia_id_idx" ON "assinaturas"("cadeia_custodia_id");

-- CreateIndex
CREATE INDEX "assinaturas_documento_anexo_id_idx" ON "assinaturas"("documento_anexo_id");

-- CreateIndex
CREATE INDEX "assinaturas_data_hora_idx" ON "assinaturas"("data_hora");

-- CreateIndex
CREATE INDEX "auditorias_usuario_id_idx" ON "auditorias"("usuario_id");

-- CreateIndex
CREATE INDEX "auditorias_acao_idx" ON "auditorias"("acao");

-- CreateIndex
CREATE INDEX "auditorias_entidade_entidade_id_idx" ON "auditorias"("entidade", "entidade_id");

-- CreateIndex
CREATE INDEX "auditorias_data_hora_idx" ON "auditorias"("data_hora");

-- CreateIndex
CREATE INDEX "auditorias_dispositivo_id_idx" ON "auditorias"("dispositivo_id");

-- CreateIndex
CREATE INDEX "logs_sistema_nivel_idx" ON "logs_sistema"("nivel");

-- CreateIndex
CREATE INDEX "logs_sistema_data_hora_idx" ON "logs_sistema"("data_hora");

-- CreateIndex
CREATE INDEX "logs_sistema_usuario_id_idx" ON "logs_sistema"("usuario_id");

-- CreateIndex
CREATE INDEX "historico_alteracoes_entidade_entidade_id_idx" ON "historico_alteracoes"("entidade", "entidade_id");

-- CreateIndex
CREATE INDEX "historico_alteracoes_usuario_id_idx" ON "historico_alteracoes"("usuario_id");

-- CreateIndex
CREATE INDEX "historico_alteracoes_data_hora_idx" ON "historico_alteracoes"("data_hora");

-- CreateIndex
CREATE INDEX "historico_alteracoes_atendimento_local_id_idx" ON "historico_alteracoes"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "linhas_tempo_ocorrencia_id_idx" ON "linhas_tempo"("ocorrencia_id");

-- CreateIndex
CREATE INDEX "linhas_tempo_atendimento_local_id_idx" ON "linhas_tempo"("atendimento_local_id");

-- CreateIndex
CREATE INDEX "linhas_tempo_usuario_id_idx" ON "linhas_tempo"("usuario_id");

-- CreateIndex
CREATE INDEX "linhas_tempo_data_hora_idx" ON "linhas_tempo"("data_hora");

-- CreateIndex
CREATE UNIQUE INDEX "configuracoes_chave_key" ON "configuracoes"("chave");

-- CreateIndex
CREATE UNIQUE INDEX "dispositivos_device_id_key" ON "dispositivos"("device_id");

-- CreateIndex
CREATE INDEX "dispositivos_usuario_id_idx" ON "dispositivos"("usuario_id");

-- CreateIndex
CREATE INDEX "dispositivos_device_id_idx" ON "dispositivos"("device_id");

-- CreateIndex
CREATE INDEX "dispositivos_ativo_idx" ON "dispositivos"("ativo");

-- CreateIndex
CREATE INDEX "sincronizacao_offline_dispositivo_id_idx" ON "sincronizacao_offline"("dispositivo_id");

-- CreateIndex
CREATE INDEX "sincronizacao_offline_status_idx" ON "sincronizacao_offline"("status");

-- CreateIndex
CREATE INDEX "sincronizacao_offline_data_inicio_idx" ON "sincronizacao_offline"("data_inicio");

-- CreateIndex
CREATE INDEX "fila_sincronizacao_usuario_id_status_idx" ON "fila_sincronizacao"("usuario_id", "status");

-- CreateIndex
CREATE INDEX "fila_sincronizacao_status_idx" ON "fila_sincronizacao"("status");

-- CreateIndex
CREATE INDEX "fila_sincronizacao_sincronizacao_offline_id_idx" ON "fila_sincronizacao"("sincronizacao_offline_id");

-- CreateIndex
CREATE INDEX "backups_registro_usuario_id_idx" ON "backups_registro"("usuario_id");

-- CreateIndex
CREATE INDEX "backups_registro_data_inicio_idx" ON "backups_registro"("data_inicio");

-- CreateIndex
CREATE INDEX "backups_registro_status_idx" ON "backups_registro"("status");

-- AddForeignKey
ALTER TABLE "usuarios" ADD CONSTRAINT "usuarios_unidade_id_fkey" FOREIGN KEY ("unidade_id") REFERENCES "unidades"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "usuario_perfis" ADD CONSTRAINT "usuario_perfis_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "usuario_perfis" ADD CONSTRAINT "usuario_perfis_perfil_id_fkey" FOREIGN KEY ("perfil_id") REFERENCES "perfis"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "perfil_permissoes" ADD CONSTRAINT "perfil_permissoes_perfil_id_fkey" FOREIGN KEY ("perfil_id") REFERENCES "perfis"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "perfil_permissoes" ADD CONSTRAINT "perfil_permissoes_permissao_id_fkey" FOREIGN KEY ("permissao_id") REFERENCES "permissoes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sessoes" ADD CONSTRAINT "sessoes_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_sessao_id_fkey" FOREIGN KEY ("sessao_id") REFERENCES "sessoes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "unidades" ADD CONSTRAINT "unidades_municipio_id_fkey" FOREIGN KEY ("municipio_id") REFERENCES "municipios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "delegacias" ADD CONSTRAINT "delegacias_unidade_id_fkey" FOREIGN KEY ("unidade_id") REFERENCES "unidades"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "institutos" ADD CONSTRAINT "institutos_unidade_id_fkey" FOREIGN KEY ("unidade_id") REFERENCES "unidades"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "departamentos" ADD CONSTRAINT "departamentos_unidade_id_fkey" FOREIGN KEY ("unidade_id") REFERENCES "unidades"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ocorrencias" ADD CONSTRAINT "ocorrencias_municipio_id_fkey" FOREIGN KEY ("municipio_id") REFERENCES "municipios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ocorrencias" ADD CONSTRAINT "ocorrencias_delegacia_id_fkey" FOREIGN KEY ("delegacia_id") REFERENCES "delegacias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ocorrencias" ADD CONSTRAINT "ocorrencias_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "atendimentos_local" ADD CONSTRAINT "atendimentos_local_ocorrencia_id_fkey" FOREIGN KEY ("ocorrencia_id") REFERENCES "ocorrencias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "atendimentos_local" ADD CONSTRAINT "atendimentos_local_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "atendimentos_local" ADD CONSTRAINT "atendimentos_local_equipe_id_fkey" FOREIGN KEY ("equipe_id") REFERENCES "equipes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "equipes" ADD CONSTRAINT "equipes_unidade_id_fkey" FOREIGN KEY ("unidade_id") REFERENCES "unidades"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "equipe_usuarios" ADD CONSTRAINT "equipe_usuarios_equipe_id_fkey" FOREIGN KEY ("equipe_id") REFERENCES "equipes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "equipe_usuarios" ADD CONSTRAINT "equipe_usuarios_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pessoas_envolvidas" ADD CONSTRAINT "pessoas_envolvidas_ocorrencia_id_fkey" FOREIGN KEY ("ocorrencia_id") REFERENCES "ocorrencias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pessoas_envolvidas" ADD CONSTRAINT "pessoas_envolvidas_municipio_id_fkey" FOREIGN KEY ("municipio_id") REFERENCES "municipios"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "policiais_participantes" ADD CONSTRAINT "policiais_participantes_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "policiais_participantes" ADD CONSTRAINT "policiais_participantes_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vestigios" ADD CONSTRAINT "vestigios_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vestigios" ADD CONSTRAINT "vestigios_tipo_vestigio_id_fkey" FOREIGN KEY ("tipo_vestigio_id") REFERENCES "tipos_vestigio"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vestigios" ADD CONSTRAINT "vestigios_acondicionamento_id_fkey" FOREIGN KEY ("acondicionamento_id") REFERENCES "acondicionamentos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cadeia_custodia" ADD CONSTRAINT "cadeia_custodia_vestigio_id_fkey" FOREIGN KEY ("vestigio_id") REFERENCES "vestigios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cadeia_custodia" ADD CONSTRAINT "cadeia_custodia_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cadeia_custodia" ADD CONSTRAINT "cadeia_custodia_destino_vestigio_id_fkey" FOREIGN KEY ("destino_vestigio_id") REFERENCES "destinos_vestigio"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "objetos" ADD CONSTRAINT "objetos_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "objetos" ADD CONSTRAINT "objetos_categoria_objeto_id_fkey" FOREIGN KEY ("categoria_objeto_id") REFERENCES "categorias_objeto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "armas" ADD CONSTRAINT "armas_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "armas" ADD CONSTRAINT "armas_tipo_arma_id_fkey" FOREIGN KEY ("tipo_arma_id") REFERENCES "tipos_arma"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "municoes" ADD CONSTRAINT "municoes_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "municoes" ADD CONSTRAINT "municoes_tipo_municao_id_fkey" FOREIGN KEY ("tipo_municao_id") REFERENCES "tipos_municao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drogas" ADD CONSTRAINT "drogas_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drogas" ADD CONSTRAINT "drogas_tipo_droga_id_fkey" FOREIGN KEY ("tipo_droga_id") REFERENCES "tipos_droga"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "veiculos" ADD CONSTRAINT "veiculos_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "midia_midia_tags" ADD CONSTRAINT "midia_midia_tags_midia_tag_id_fkey" FOREIGN KEY ("midia_tag_id") REFERENCES "midia_tags"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "midia_midia_tags" ADD CONSTRAINT "midia_midia_tags_fotografia_id_fkey" FOREIGN KEY ("fotografia_id") REFERENCES "fotografias"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "midia_midia_tags" ADD CONSTRAINT "midia_midia_tags_video_id_fkey" FOREIGN KEY ("video_id") REFERENCES "videos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "midia_midia_tags" ADD CONSTRAINT "midia_midia_tags_audio_id_fkey" FOREIGN KEY ("audio_id") REFERENCES "audios"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "midia_midia_tags" ADD CONSTRAINT "midia_midia_tags_documento_anexo_id_fkey" FOREIGN KEY ("documento_anexo_id") REFERENCES "documentos_anexos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias" ADD CONSTRAINT "fotografias_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias" ADD CONSTRAINT "fotografias_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias" ADD CONSTRAINT "fotografias_vestigio_id_fkey" FOREIGN KEY ("vestigio_id") REFERENCES "vestigios"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias" ADD CONSTRAINT "fotografias_objeto_id_fkey" FOREIGN KEY ("objeto_id") REFERENCES "objetos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias" ADD CONSTRAINT "fotografias_arma_id_fkey" FOREIGN KEY ("arma_id") REFERENCES "armas"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias" ADD CONSTRAINT "fotografias_municao_id_fkey" FOREIGN KEY ("municao_id") REFERENCES "municoes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias" ADD CONSTRAINT "fotografias_droga_id_fkey" FOREIGN KEY ("droga_id") REFERENCES "drogas"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fotografias" ADD CONSTRAINT "fotografias_veiculo_id_fkey" FOREIGN KEY ("veiculo_id") REFERENCES "veiculos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "videos" ADD CONSTRAINT "videos_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "videos" ADD CONSTRAINT "videos_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audios" ADD CONSTRAINT "audios_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audios" ADD CONSTRAINT "audios_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documentos_anexos" ADD CONSTRAINT "documentos_anexos_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "documentos_anexos" ADD CONSTRAINT "documentos_anexos_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assinaturas" ADD CONSTRAINT "assinaturas_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assinaturas" ADD CONSTRAINT "assinaturas_tipo_assinatura_id_fkey" FOREIGN KEY ("tipo_assinatura_id") REFERENCES "tipos_assinatura"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assinaturas" ADD CONSTRAINT "assinaturas_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assinaturas" ADD CONSTRAINT "assinaturas_cadeia_custodia_id_fkey" FOREIGN KEY ("cadeia_custodia_id") REFERENCES "cadeia_custodia"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "assinaturas" ADD CONSTRAINT "assinaturas_documento_anexo_id_fkey" FOREIGN KEY ("documento_anexo_id") REFERENCES "documentos_anexos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "auditorias" ADD CONSTRAINT "auditorias_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "auditorias" ADD CONSTRAINT "auditorias_dispositivo_id_fkey" FOREIGN KEY ("dispositivo_id") REFERENCES "dispositivos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "logs_sistema" ADD CONSTRAINT "logs_sistema_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "historico_alteracoes" ADD CONSTRAINT "historico_alteracoes_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "historico_alteracoes" ADD CONSTRAINT "historico_alteracoes_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "linhas_tempo" ADD CONSTRAINT "linhas_tempo_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "linhas_tempo" ADD CONSTRAINT "linhas_tempo_ocorrencia_id_fkey" FOREIGN KEY ("ocorrencia_id") REFERENCES "ocorrencias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "linhas_tempo" ADD CONSTRAINT "linhas_tempo_atendimento_local_id_fkey" FOREIGN KEY ("atendimento_local_id") REFERENCES "atendimentos_local"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dispositivos" ADD CONSTRAINT "dispositivos_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sincronizacao_offline" ADD CONSTRAINT "sincronizacao_offline_dispositivo_id_fkey" FOREIGN KEY ("dispositivo_id") REFERENCES "dispositivos"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fila_sincronizacao" ADD CONSTRAINT "fila_sincronizacao_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fila_sincronizacao" ADD CONSTRAINT "fila_sincronizacao_sincronizacao_offline_id_fkey" FOREIGN KEY ("sincronizacao_offline_id") REFERENCES "sincronizacao_offline"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "backups_registro" ADD CONSTRAINT "backups_registro_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
