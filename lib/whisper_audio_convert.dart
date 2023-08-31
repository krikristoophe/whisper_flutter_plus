import 'dart:async';

import 'package:ffmpeg_dart/ffmpeg_dart.dart';
import 'package:universal_io/io.dart';
import 'package:whisper_flutter_plus/extension/ffmpeg.dart';

/// Class used to convert any audio file to wav
class WhisperAudioconvert {
  ///
  const WhisperAudioconvert();

  /// convert [audioInput] to wav file
  /// Wait the end of conversion
  static File convert({
    required File audioInput,
    required File audioOutput,
    String? pathFFmpeg,
    FFmpegArgs? fFmpegArgs,
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    Duration? timeout,
  }) {
    timeout ??= const Duration(seconds: 10);
    final DateTime timeExpire = DateTime.now().add(timeout);
    final bool res = FFmpeg(pathFFmpeg: pathFFmpeg).convertAudioToWavWhisper(
      pathAudioInput: audioInput.path,
      pathAudioOutput: audioOutput.path,
      pathFFmpeg: pathFFmpeg,
      fFmpegArgs: fFmpegArgs,
      workingDirectory: workingDirectory,
      environment: environment,
      runInShell: runInShell,
    );
    while (true) {
      if (DateTime.now().isAfter(timeExpire)) {
        throw TimeoutException(null);
      }
      if (res) {
        if (audioOutput.existsSync()) {
          return audioOutput;
        }
      } else {
        if (!audioInput.existsSync()) {
          throw Exception('audio input not found');
        }
      }
    }
  }
}
