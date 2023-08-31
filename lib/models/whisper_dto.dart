abstract class WhisperDto {
  String get specialType;
}

abstract class WhisperRequestDto extends WhisperDto {
  String toRequestString();
}
