import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_whisper/providers.dart';
import 'package:test_whisper/whisper_result.dart';
import 'package:whisper_flutter_plus/whisper_flutter_plus.dart';

class WhisperController extends StateNotifier<AsyncValue<TranscribeResult?>> {
  WhisperController(this.ref) : super(const AsyncData(null));

  final Ref ref;

  Future<void> transcribe(String filePath) async {
    final WhisperModel model = ref.read(modelProvider);

    state = const AsyncLoading();

    final Whisper whisper = Whisper(
      model: model,
    );

    final String? whisperVersion = await whisper.getVersion();
    print(whisperVersion);

    final DateTime start = DateTime.now();

    final String lang = ref.read(langProvider);

    final bool translate = ref.read(translateProvider);

    final bool withSegments = ref.read(withSegmentsProvider);

    final bool splitWords = ref.read(splitWordsProvider);

    try {
      final WhisperTranscribeResponse transcription = await whisper.transcribe(
        transcribeRequest: TranscribeRequest(
          audio: filePath,
          language: lang,
          isTranslate: translate,
          isNoTimestamps: !withSegments,
          splitOnWord: splitWords,
        ),
      );

      final Duration transcriptionDuration = DateTime.now().difference(start);

      state = AsyncData(
        TranscribeResult(
          time: transcriptionDuration,
          transcription: transcription,
        ),
      );
    } catch (e) {
      print(e);
      state = const AsyncData(null);
    }
  }
}

final whisperControllerProvider = StateNotifierProvider.autoDispose<
    WhisperController, AsyncValue<TranscribeResult?>>(
  (ref) => WhisperController(ref),
);
