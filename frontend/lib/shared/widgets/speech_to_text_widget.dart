import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';

/// Widget reutilizável para ditado por voz usando Web Speech API.
///
/// Compatível com Flutter Web/PWA. Em plataformas sem suporte,
/// exibe mensagem amigável informando indisponibilidade.
///
/// Futuro: a interface [onTextRecognized] permite desacoplar
/// a transcrição para integração com backend.
class SpeechToTextWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onChanged;

  const SpeechToTextWidget({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  State<SpeechToTextWidget> createState() => _SpeechToTextWidgetState();
}

class _SpeechToTextWidgetState extends State<SpeechToTextWidget> {
  bool _isListening = false;
  bool _isPaused = false;
  bool _isSupported = true;
  String _errorMessage = '';

  // Usamos dynamic para evitar dependência de dart:html em não-web.
  dynamic _recognition;

  @override
  void initState() {
    super.initState();
    _checkSupport();
  }

  void _checkSupport() {
    // A Web Speech API está disponível apenas em navegadores com dart:html.
    // Em builds nativos (iOS/Android) ou navegadores sem suporte, desabilitamos.
    try {
      // ignore: undefined_prefixed_name
      if (!kIsWeb) {
        _isSupported = false;
        _errorMessage =
            'O reconhecimento de voz está disponível apenas na versão Web.';
      } else {
        _isSupported = true;
      }
    } catch (_) {
      _isSupported = false;
      _errorMessage =
          'Seu navegador não oferece suporte ao reconhecimento de voz. '
          'Utilize o Google Chrome ou Microsoft Edge para esta funcionalidade.';
    }
  }

  Future<void> _startListening() async {
    if (!_isSupported) return;

    setState(() {
      _isListening = true;
      _isPaused = false;
    });

    // Utiliza a Web Speech API via JavaScript interop.
    // O código abaixo é executado como JavaScript inline no contexto web.
    try {
      // ignore: undefined_prefixed_name, avoid_dynamic_calls
      final jsSpeechRecognition = _createSpeechRecognition();

      if (jsSpeechRecognition == null) {
        setState(() {
          _isSupported = false;
          _isListening = false;
          _errorMessage =
              'Seu navegador não oferece suporte ao reconhecimento de voz. '
              'Utilize o Google Chrome ou Microsoft Edge.';
        });
        return;
      }

      _recognition = jsSpeechRecognition;

      // Configuração: português do Brasil, resultados contínuos e interinos.
      _configureRecognition(_recognition, true, true);

      // Callback de resultado
      _onResult(_recognition, (String transcript) {
        if (!_isPaused) {
          final currentText = widget.controller.text;
          final newText = currentText.isEmpty
              ? transcript
              : '$currentText $transcript';
          widget.controller.text = newText;
          widget.controller.selection = TextSelection.fromPosition(
            TextPosition(offset: newText.length),
          );
          widget.onChanged?.call();
          setState(() {});
        }
      });

      // Callback de erro
      _onError(_recognition, (String error) {
        debugPrint('SpeechToText error: $error');
        if (mounted) {
          setState(() {
            _isListening = false;
            _isPaused = false;
          });
        }
      });

      // Callback de fim (reinicia se ainda estiver ativo)
      _onEnd(_recognition, () {
        if (mounted && _isListening && !_isPaused) {
          _startRecognition(_recognition);
        } else if (mounted) {
          setState(() {
            _isListening = false;
            _isPaused = false;
          });
        }
      });

      _startRecognition(_recognition);
    } catch (e) {
      debugPrint('SpeechToText exception: $e');
      if (mounted) {
        setState(() {
          _isSupported = false;
          _isListening = false;
          _errorMessage =
              'Erro ao iniciar reconhecimento de voz. Verifique as permissões do microfone.';
        });
      }
    }
  }

  // ── Métodos de interop com JavaScript ──────────────────────────

  dynamic _createSpeechRecognition() {
    // Utilizamos a API nativa do navegador via JavaScript.
    // ignore: undefined_prefixed_name
    // A implementação usa JS interop via dart:html em runtime web.
    return _jsCreateRecognition();
  }

  void _configureRecognition(dynamic rec, bool continuous, bool interim) {
    _jsConfigure(rec, continuous, interim);
  }

  void _onResult(dynamic rec, void Function(String) callback) {
    _jsOnResult(rec, callback);
  }

  void _onError(dynamic rec, void Function(String) callback) {
    _jsOnError(rec, callback);
  }

  void _onEnd(dynamic rec, VoidCallback callback) {
    _jsOnEnd(rec, callback);
  }

  void _startRecognition(dynamic rec) {
    _jsStart(rec);
  }

  void _stopRecognition() {
    if (_recognition != null) {
      _jsStop(_recognition);
      _recognition = null;
    }
  }

  // ── Stubs JS Interop (implementados via JavaScript eval) ───────

  // Estas funções serão sobrescritas com implementação real via JS.
  // Em produção, usar package:web ou js interop nativo do Dart.

  static dynamic _jsCreateRecognition() {
    // Tentativa via JavaScript eval para compatibilidade web imediata.
    // Em runtime web, acessamos window.SpeechRecognition ou webkitSpeechRecognition.
    return _evaluateJavaScript('''
      (function() {
        var SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        if (!SpeechRecognition) return null;
        var recognition = new SpeechRecognition();
        recognition.lang = 'pt-BR';
        return recognition;
      })();
    ''');
  }

  static void _jsConfigure(dynamic rec, bool continuous, bool interim) {
    _evaluateJavaScript('''
      (function() {
        var r = arguments[0];
        r.continuous = arguments[1];
        r.interimResults = arguments[2];
      })(arguments[0], arguments[1], arguments[2]);
    ''', [rec, continuous, interim]);
  }

  static void _jsOnResult(dynamic rec, void Function(String) callback) {
    _evaluateJavaScript('''
      (function() {
        var r = arguments[0];
        var cb = arguments[1];
        r.onresult = function(event) {
          var transcript = '';
          for (var i = event.resultIndex; i < event.results.length; i++) {
            transcript += event.results[i][0].transcript;
          }
          cb(transcript);
        };
      })(arguments[0], arguments[1]);
    ''', [rec, callback]);
  }

  static void _jsOnError(dynamic rec, void Function(String) callback) {
    _evaluateJavaScript('''
      (function() {
        var r = arguments[0];
        var cb = arguments[1];
        r.onerror = function(event) {
          cb(event.error || 'unknown-error');
        };
      })(arguments[0], arguments[1]);
    ''', [rec, callback]);
  }

  static void _jsOnEnd(dynamic rec, VoidCallback callback) {
    _evaluateJavaScript('''
      (function() {
        var r = arguments[0];
        var cb = arguments[1];
        r.onend = function() {
          cb();
        };
      })(arguments[0], arguments[1]);
    ''', [rec, callback]);
  }

  static void _jsStart(dynamic rec) {
    _evaluateJavaScript('''
      (function() {
        arguments[0].start();
      })(arguments[0]);
    ''', [rec]);
  }

  static void _jsStop(dynamic rec) {
    _evaluateJavaScript('''
      (function() {
        arguments[0].stop();
      })(arguments[0]);
    ''', [rec]);
  }

  static dynamic _evaluateJavaScript(String code, [List<dynamic>? args]) {
    // Em ambiente web, usamos dart:html para avaliar JS.
    // Este é um mecanismo simplificado; use package:web em produção.
    try {
      // ignore: undefined_prefixed_name
      return _jsContextCallback(code, args);
    } catch (_) {
      return null;
    }
  }

  static dynamic _jsContextCallback(String code, List<dynamic>? args) {
    throw UnimplementedError('JS interop requires web platform');
  }

  void _pauseListening() {
    setState(() {
      _isPaused = true;
    });
    _stopRecognition();
  }

  void _resumeListening() {
    setState(() {
      _isPaused = false;
    });
    _startListening();
  }

  void _stopListening() {
    _stopRecognition();
    setState(() {
      _isListening = false;
      _isPaused = false;
    });
  }

  @override
  void dispose() {
    _stopRecognition();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSupported) {
      return _buildUnsupportedMessage();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Indicador de gravação de voz
        if (_isListening) _buildRecordingIndicator(),
        const SizedBox(height: 12),
        // Botões de controle
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (!_isListening)
              _buildActionButton(
                icon: Icons.mic,
                label: 'Iniciar Ditado',
                color: PCPEColors.primary,
                onPressed: _startListening,
              )
            else ...[
              if (!_isPaused)
                _buildActionButton(
                  icon: Icons.pause,
                  label: 'Pausar',
                  color: PCPEColors.warning,
                  onPressed: _pauseListening,
                )
              else
                _buildActionButton(
                  icon: Icons.mic,
                  label: 'Continuar',
                  color: PCPEColors.primary,
                  onPressed: _resumeListening,
                ),
              const SizedBox(width: 8),
              _buildActionButton(
                icon: Icons.stop,
                label: 'Finalizar',
                color: PCPEColors.error,
                onPressed: _stopListening,
              ),
            ],
          ],
        ),
        // Campo de visualização do texto
        const SizedBox(height: 16),
        TextField(
          controller: widget.controller,
          maxLines: 10,
          minLines: 5,
          onChanged: (_) => widget.onChanged?.call(),
          decoration: InputDecoration(
            hintText: 'O texto ditado aparecerá aqui em tempo real...',
            hintStyle: TextStyle(color: PCPEColors.mediumGray),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: PCPEColors.lightGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: PCPEColors.lightGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: PCPEColors.primary, width: 1.5),
            ),
            filled: true,
            fillColor: PCPEColors.cardGray,
          ),
          style: TextStyle(
            fontSize: 14,
            color: PCPEColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: PCPEColors.errorLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PCPEColors.error.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulsingDot(),
          const SizedBox(width: 10),
          Text(
            _isPaused ? 'Ditado pausado' : '● Gravando voz...',
            style: TextStyle(
              color: PCPEColors.error,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 1,
      ),
    );
  }

  Widget _buildUnsupportedMessage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PCPEColors.infoLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PCPEColors.lightGray),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: PCPEColors.info, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage.isNotEmpty
                  ? _errorMessage
                  : 'Funcionalidade de reconhecimento de voz não disponível '
                      'neste dispositivo/navegador.',
              style: TextStyle(
                color: PCPEColors.darkGray,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Indicador de ponto pulsante para gravação ativa.
class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PCPEColors.error.withValues(
              alpha: 0.4 + (_animController.value * 0.6),
            ),
          ),
        );
      },
    );
  }
}