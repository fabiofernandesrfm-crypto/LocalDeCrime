/// Estrutura Organizacional da Polícia Civil de Pernambuco (PCPE)
///
/// Representa a hierarquia: Diretoria → Divisão → Unidade.
/// Os dados são mockados para o frontend e futuramente serão carregados via API.
library;

class UnidadeOrganizacional {
  final String nome;
  final String sigla;

  const UnidadeOrganizacional({
    required this.nome,
    required this.sigla,
  });
}

class DivisaoOrganizacional {
  final String nome;
  final List<UnidadeOrganizacional> unidades;

  const DivisaoOrganizacional({
    required this.nome,
    required this.unidades,
  });
}

class DiretoriaOrganizacional {
  final String nome;
  final String sigla;
  final List<DivisaoOrganizacional> divisoes;

  const DiretoriaOrganizacional({
    required this.nome,
    required this.sigla,
    required this.divisoes,
  });
}

/// Mock da estrutura organizacional completa.
/// Futuramente será substituído por chamada à API.
const List<DiretoriaOrganizacional> diretoriasMock = [
  DiretoriaOrganizacional(
    nome: 'DIRESP',
    sigla: 'DIRESP',
    divisoes: [
      DivisaoOrganizacional(
        nome: 'DHPP — Departamento de Homicídios e Proteção à Pessoa',
        unidades: [
          UnidadeOrganizacional(
            nome: 'DIVISÃO DE HOMICÍDIOS METROPOLITANA NORTE - DHMN/DIRESP',
            sigla: 'DHMN/DIRESP',
          ),
          UnidadeOrganizacional(
            nome: '6ª DELEGACIA DE POLÍCIA DE HOMICÍDIOS - PAULISTA - 06ª DPH/DHMN/DIRESP',
            sigla: '06ª DPH/DHMN/DIRESP',
          ),
          UnidadeOrganizacional(
            nome: '7ª DELEGACIA DE POLÍCIA DE HOMICÍDIOS - PAULISTA - 07ª DPH/DHMN/DIRESP',
            sigla: '07ª DPH/DHMN/DIRESP',
          ),
          UnidadeOrganizacional(
            nome: '8ª DELEGACIA DE POLÍCIA DE HOMICÍDIOS - PAULISTA - 08ª DPH/DHMN/DIRESP',
            sigla: '08ª DPH/DHMN/DIRESP',
          ),
          UnidadeOrganizacional(
            nome: '9ª DELEGACIA DE POLÍCIA DE HOMICÍDIOS - OLINDA - 09ª DPH/DHMN/DIRESP',
            sigla: '09ª DPH/DHMN/DIRESP',
          ),
          UnidadeOrganizacional(
            nome: '10ª DELEGACIA DE POLÍCIA DE HOMICÍDIOS - SÃO LOURENÇO DA MATA - 10ª DPH/DHMN/DIRESP',
            sigla: '10ª DPH/DHMN/DIRESP',
          ),
          UnidadeOrganizacional(
            nome: 'SETOR DE ADMINISTRAÇÃO, PLANEJAMENTO E LOGÍSTICA DA DHMN - SAPLOG/DHMN',
            sigla: 'SAPLOG/DHMN',
          ),
          UnidadeOrganizacional(
            nome: 'SETOR DE REMESSA E CONTROLE DA DHMN - SERCON/DHMN',
            sigla: 'SERCON/DHMN',
          ),
          UnidadeOrganizacional(
            nome: 'DIVISÃO DE HOMICÍDIOS METROPOLITANA SUL - DHMS',
            sigla: 'DHMS',
          ),
          UnidadeOrganizacional(
            nome: '11ª DELEGACIA DE POLÍCIA DE HOMICÍDIOS - 11ª DPH/DHMS/DIRESP',
            sigla: '11ª DPH/DHMS/DIRESP',
          ),
          UnidadeOrganizacional(
            nome: '12ª DELEGACIA DE POLÍCIA DE HOMICÍDIOS - 12ª DPH/DHMS/DIRESP',
            sigla: '12ª DPH/DHMS/DIRESP',
          ),
          UnidadeOrganizacional(
            nome: '13ª DELEGACIA DE POLÍCIA DE HOMICÍDIOS - JABOATÃO DOS GUARARAPES - 13ª DPH/DHMS/DIRESP',
            sigla: '13ª DPH/DHMS/DIRESP',
          ),
        ],
      ),
    ],
  ),
];