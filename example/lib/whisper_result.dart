import 'package:whisper_flutter_plus/whisper_flutter_plus.dart';

class TranscribeResult {
  const TranscribeResult({
    required this.transcription,
    required this.time,
  });
  final WhisperTranscribeResponse transcription;
  final Duration time;
}
