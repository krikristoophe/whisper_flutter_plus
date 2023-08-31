/// Common whisper communication fields
abstract class WhisperDto {
  /// Type of request or response
  String get specialType;
}

/// Common whisper request
abstract class WhisperRequestDto extends WhisperDto {
  /// Convert current request to String encoded whisper json
  String toRequestString();
}
