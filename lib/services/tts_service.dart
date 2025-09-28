import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  Future<void> init({
    String language = 'en-US',
    double rate = 0.45,
    double pitch = 1.0,
    double volume = 1.0,
  }) async {
    await _tts.setLanguage(language);
    await _tts.setSpeechRate(rate);
    await _tts.setPitch(pitch);
    await _tts.setVolume(volume);

    // Ensure await speak completion works on supported platforms
    try {
      await _tts.awaitSpeakCompletion(true);
    } catch (_) {}

    _tts.setStartHandler(() => _isSpeaking = true);
    _tts.setCompletionHandler(() => _isSpeaking = false);
    _tts.setCancelHandler(() => _isSpeaking = false);
    _tts.setErrorHandler((_) => _isSpeaking = false);
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    await stop();
    // Chunk long text to avoid platform limits
    final chunks = _chunk(text, 1800);
    for (final part in chunks) {
      _isSpeaking = true;
      await _tts.speak(part);
      // Allow awaitSpeakCompletion to resolve; fallback polling
      while (_isSpeaking) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
  }

  Future<void> pause() async {
    try {
      await _tts.pause();
    } catch (_) {}
    _isSpeaking = false;
  }

  Future<void> setRate(double rate) => _tts.setSpeechRate(rate);
  Future<void> setPitch(double pitch) => _tts.setPitch(pitch);
  Future<void> setLanguage(String lang) => _tts.setLanguage(lang);

  List<String> _chunk(String text, int maxLen) {
    final parts = <String>[];
    final sentences = text.split(RegExp(r'(?<=[\.\!\?\n])\s+'));
    final buf = StringBuffer();
    for (final s in sentences) {
      if ((buf.length + s.length + 1) > maxLen) {
        parts.add(buf.toString().trim());
        buf.clear();
      }
      buf.write(s);
      buf.write(' ');
    }
    if (buf.isNotEmpty) parts.add(buf.toString().trim());
    return parts;
  }
}