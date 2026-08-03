import 'package:flutter/material.dart';

/// Ícones padronizados da aplicação PCPE.
///
/// Mapeia ícones do Material Design para os contextos da
/// Polícia Civil de Pernambuco, garantindo consistência visual.
class PCPEIcons {
  PCPEIcons._();

  // ── Brand / Institucional ───────────────────────────────────
  static const IconData shield = Icons.shield;
  static const IconData badge = Icons.verified_user;
  static const IconData fingerprint = Icons.fingerprint;

  // ── Navegação ───────────────────────────────────────────────
  static const IconData dashboard = Icons.dashboard_outlined;
  static const IconData menu = Icons.menu;
  static const IconData notifications = Icons.notifications_outlined;
  static const IconData search = Icons.search;
  static const IconData logout = Icons.logout;
  static const IconData arrowForward = Icons.arrow_forward;
  static const IconData arrowBack = Icons.arrow_back;

  // ── Ações ───────────────────────────────────────────────────
  static const IconData add = Icons.add_circle_outline;
  static const IconData edit = Icons.edit;
  static const IconData delete = Icons.delete_outline;
  static const IconData save = Icons.save_outlined;
  static const IconData sync = Icons.sync;
  static const IconData upload = Icons.cloud_upload_outlined;
  static const IconData download = Icons.cloud_download_outlined;
  static const IconData filter = Icons.filter_list;
  static const IconData moreVert = Icons.more_vert;
  static const IconData moreHoriz = Icons.more_horiz;
  static const IconData share = Icons.share_outlined;
  static const IconData print = Icons.print_outlined;

  // ── Autenticação ────────────────────────────────────────────
  static const IconData login = Icons.login;
  static const IconData lock = Icons.lock_outlined;
  static const IconData person = Icons.person_outline;
  static const IconData badgeIcon = Icons.badge_outlined;
  static const IconData visibility = Icons.visibility;
  static const IconData visibilityOff = Icons.visibility_off;

  // ── Módulos do Sistema ──────────────────────────────────────
  static const IconData ocorrencias = Icons.folder_outlined;
  static const IconData novaOcorrencia = Icons.add_circle_outline;
  static const IconData atendimentos = Icons.medical_services_outlined;
  static const IconData usuarios = Icons.people_outline;
  static const IconData pessoas = Icons.person_outline;
  static const IconData vestigios = Icons.fingerprint;
  static const IconData objetos = Icons.category_outlined;
  static const IconData veiculos = Icons.directions_car_outlined;
  static const IconData fotografias = Icons.photo_library_outlined;
  static const IconData linhaDoTempo = Icons.timeline_outlined;
  static const IconData equipes = Icons.groups_outlined;
  static const IconData relatorios = Icons.assessment_outlined;
  static const IconData map = Icons.map_outlined;
  static const IconData chart = Icons.bar_chart;
  static const IconData camera = Icons.camera_alt_outlined;

  // ── Status / Indicadores ────────────────────────────────────
  static const IconData success = Icons.check_circle_outline;
  static const IconData warning = Icons.warning_amber_outlined;
  static const IconData error = Icons.error_outline;
  static const IconData info = Icons.info_outline;
  static const IconData clock = Icons.access_time;
  static const IconData calendar = Icons.calendar_today;
  static const IconData location = Icons.location_on_outlined;
  static const IconData phone = Icons.phone_outlined;
  static const IconData email = Icons.email_outlined;

  // ── Sistema ─────────────────────────────────────────────────
  static const IconData settings = Icons.settings_outlined;
  static const IconData help = Icons.help_outline;
  static const IconData about = Icons.info_outline;
  static const IconData profile = Icons.person_outline;
  static const IconData history = Icons.history;
  static const IconData flash = Icons.flash_on;
  static const IconData chevronDown = Icons.keyboard_arrow_down;
  static const IconData checkCircle = Icons.check_circle_outline;
  static const IconData cases = Icons.cases_outlined;
  static const IconData document = Icons.description_outlined;
  static const IconData personSearch = Icons.person_search;
}

/// Extensão para facilitar o uso de ícones com tamanhos padrão.
extension PCPEIconExtension on IconData {
  /// Cria um ícone de 20px (tamanho padrão para menus e listas).
  Widget icon20({Color? color}) => Icon(this, size: 20, color: color);

  /// Cria um ícone de 24px (tamanho padrão para ações).
  Widget icon24({Color? color}) => Icon(this, size: 24, color: color);

  /// Cria um ícone de 16px (tamanho compacto).
  Widget icon16({Color? color}) => Icon(this, size: 16, color: color);

  /// Cria um ícone de 40px (tamanho grande, splash/hero).
  Widget icon40({Color? color}) => Icon(this, size: 40, color: color);
}