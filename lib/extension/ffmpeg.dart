import 'package:easy_dart_logger/easy_dart_logger.dart';
import 'package:ffmpeg_dart/ffmpeg_dart.dart';
import 'package:universal_io/io.dart';

extension ConvertAudioToWavWhisper on FFmpeg {
  bool convertAudioToWavWhisper({
    required String pathAudioInput,
    required String pathAudioOutput,
    String? pathFFmpeg,
    FFmpegArgs? fFmpegArgs,
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
  }) {
    final File inputAudioFile = File(pathAudioInput);
    if (!inputAudioFile.existsSync()) {
      return false;
    }
    final File outputAudioFile = File(pathAudioOutput);
    if (outputAudioFile.existsSync()) {
      outputAudioFile.deleteSync(recursive: true);
    }
    final FFmpegRawResponse res = invokeSync(
      pathFFmpeg: pathFFmpeg,
      fFmpegArgs: FFmpegArgs(
        [
          '-i',
          pathAudioInput,
          '-ar',
          '16000',
          '-ac',
          '1',
          '-c:a',
          'pcm_s16le',
          pathAudioOutput,
        ],
      ),
    );
    if (res.special_type == 'ok') {
      return true;
    }
    DartLogger.global.debug(res.toJson());
    return false;
  }
}
