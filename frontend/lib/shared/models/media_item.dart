import 'dart:math';
import 'package:flutter/material.dart';

/// Tipos de mídia suportados na galeria unificada.
enum MediaType {
  photo,
  video,
  audio,
}

/// Modelo unificado para itens de mídia (fotos, vídeos, áudios).
///
/// Armazenamento temporário (mock). Preparado para futura integração
/// com backend — basta adicionar campos como [remoteUrl], [uploadStatus].
class MediaItem {
  final int id;
  final MediaType type;
  String legenda;
  final DateTime data;
  final String hora;
  final String gps;
  final Duration? duracao; // para vídeos e áudios
  final String? fileName;

  MediaItem({
    required this.id,
    required this.type,
    this.legenda = '',
    DateTime? data,
    this.hora = '',
    this.gps = '',
    this.duracao,
    this.fileName,
  }) : data = data ?? DateTime.now();

  // ── Metadata ──────────────────────────────────────────────────

  String get tipoLabel {
    switch (type) {
      case MediaType.photo:
        return 'Foto';
      case MediaType.video:
        return 'Vídeo';
      case MediaType.audio:
        return 'Áudio';
    }
  }

  IconData get tipoIcon {
    switch (type) {
      case MediaType.photo:
        return Icons.image;
      case MediaType.video:
        return Icons.videocam;
      case MediaType.audio:
        return Icons.mic;
    }
  }

  String get duracaoFormatada {
    if (duracao == null) return '';
    final m = duracao!.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = duracao!.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duracao!.inHours > 0) {
      final h = duracao!.inHours.toString().padLeft(2, '0');
      return '$h:$m:$s';
    }
    return '$m:$s';
  }

  // ── Cor placeholder (consistente com o design system) ─────────

  Color get placeholderColor {
    const colors = [
      Color(0xFF1565C0), // azul
      Color(0xFF2E7D32), // verde
      Color(0xFFEF6C00), // laranja
      Color(0xFF6A1B9A), // roxo
      Color(0xFFC62828), // vermelho
      Color(0xFF00838F), // teal
    ];
    return colors[id % colors.length];
  }

  // ── Factory helpers ───────────────────────────────────────────

  /// Cria um item de foto mock.
  factory MediaItem.foto({
    required int id,
    String legenda = '',
    DateTime? data,
    String gps = '',
  }) {
    final now = data ?? DateTime.now();
    return MediaItem(
      id: id,
      type: MediaType.photo,
      legenda: legenda,
      data: now,
      hora:
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      gps: gps,
      fileName:
          'foto_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
          '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.jpg',
    );
  }

  /// Cria um item de vídeo mock.
  factory MediaItem.video({
    required int id,
    String legenda = '',
    DateTime? data,
    String gps = '',
    Duration? duracao,
  }) {
    final now = data ?? DateTime.now();
    final d = duracao ??
        Duration(seconds: 10 + Random().nextInt(50));
    return MediaItem(
      id: id,
      type: MediaType.video,
      legenda: legenda,
      data: now,
      hora:
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      gps: gps,
      duracao: d,
      fileName:
          'video_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
          '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.mp4',
    );
  }

  /// Cria um item de áudio mock.
  factory MediaItem.audio({
    required int id,
    String legenda = '',
    DateTime? data,
    String gps = '',
    Duration? duracao,
    String? fileName,
  }) {
    final now = data ?? DateTime.now();
    return MediaItem(
      id: id,
      type: MediaType.audio,
      legenda: legenda,
      data: now,
      hora:
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      gps: gps,
      duracao: duracao ?? Duration.zero,
      fileName: fileName ??
          'audio_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
          '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}.wav',
    );
  }
}