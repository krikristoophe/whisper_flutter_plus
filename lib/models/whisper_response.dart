// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whisper_flutter_plus/models/whisper_dto.dart';

part 'whisper_response.freezed.dart';
part 'whisper_response.g.dart';

/// Response model of whisper
@freezed
class WhisperResponse with _$WhisperResponse implements WhisperDto {
  ///
  const factory WhisperResponse({
    @JsonKey(name: '@type') required String type,
    required String? text,
    required String? message,
  }) = _WhisperResponse;

  const WhisperResponse._();

  /// Parse [json] to WhisperResponse
  factory WhisperResponse.fromJson(Map<String, dynamic> json) =>
      _$WhisperResponseFromJson(json);

  @override
  String get specialType => type;
}
