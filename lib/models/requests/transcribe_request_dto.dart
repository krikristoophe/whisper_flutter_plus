import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whisper_flutter_plus/models/requests/transcribe_request.dart';
import 'package:whisper_flutter_plus/models/whisper_dto.dart';

part 'transcribe_request_dto.freezed.dart';
part 'transcribe_request_dto.g.dart';

@freezed
class TranscribeRequestDto
    with _$TranscribeRequestDto
    implements WhisperRequestDto {
  const factory TranscribeRequestDto({
    required String audio,
    required String model,
    @JsonKey(name: 'is_translate') required bool isTranslate,
    required int threads,
    @JsonKey(name: 'is_verbose') required bool isVerbose,
    required String language,
    @JsonKey(name: 'is_special_tokens') required bool isSpecialTokens,
    @JsonKey(name: 'is_no_timestamps') required bool isNoTimestamps,
    @JsonKey(name: 'n_processors') required int nProcessors,
    @JsonKey(name: 'split_on_word') required bool splitOnWord,
    @JsonKey(name: 'no_fallback') required bool noFallback,
    required bool diarize,
    @JsonKey(name: 'speed_up') required bool speedUp,
  }) = _TranscribeRequestDto;

  factory TranscribeRequestDto.fromTranscribeRequest(
    TranscribeRequest request,
    String modelPath,
  ) {
    return TranscribeRequestDto(
      audio: request.audio,
      model: modelPath,
      isTranslate: request.isTranslate,
      threads: request.threads,
      isVerbose: request.isVerbose,
      language: request.language,
      isSpecialTokens: request.isSpecialTokens,
      isNoTimestamps: request.isNoTimestamps,
      nProcessors: request.nProcessors,
      splitOnWord: request.splitOnWord,
      noFallback: request.noFallback,
      diarize: request.diarize,
      speedUp: request.speedUp,
    );
  }
  const TranscribeRequestDto._();

  factory TranscribeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$TranscribeRequestDtoFromJson(json);

  @override
  String get specialType => 'getTextFromWavFile';

  @override
  String toRequestString() {
    return json.encode({
      '@type': specialType,
      ...toJson(),
    });
  }
}
