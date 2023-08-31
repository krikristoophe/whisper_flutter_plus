import 'package:freezed_annotation/freezed_annotation.dart';

part 'transcribe_request.freezed.dart';

/// Transcription request parameters
@freezed
class TranscribeRequest with _$TranscribeRequest {
  ///
  const factory TranscribeRequest({
    required String audio,
    @Default(false) bool isTranslate,
    @Default(6) int threads,
    @Default(false) bool isVerbose,
    @Default('id') String language,
    @Default(false) bool isSpecialTokens,
    @Default(false) bool isNoTimestamps,
    @Default(1) int nProcessors,
    @Default(false) bool splitOnWord,
    @Default(false) bool noFallback,
    @Default(false) bool diarize,
    @Default(false) bool speedUp,
  }) = _TranscribeRequest;
  const TranscribeRequest._();
}
