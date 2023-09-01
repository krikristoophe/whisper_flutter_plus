import 'dart:async';

import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:universal_io/io.dart';
import 'package:whisper_flutter_plus/whisper_flutter_plus.dart';

/// Class used to convert any audio file to wav
class WhisperAudioconvert {
  ///
  const WhisperAudioconvert({
    required this.audioInput,
    required this.audioOutput,
  });

  /// Input audio file
  final File audioInput;

  /// Output audio file
  /// Overwriten if already exist
  final File audioOutput;

  /// convert [audioInput] to wav file
  Future<File?> convert() async {
    final FFmpegSession session = await FFmpegKit.execute(
      [
        '-y',
        '-i',
        audioInput.path,
        '-ar',
        '16000',
        '-ac',
        '1',
        '-c:a',
        'pcm_s16le',
        audioOutput.path,
      ].join(' '),
    );

    final ReturnCode? returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      return audioOutput;
    } else if (ReturnCode.isCancel(returnCode)) {
      logger.debug('File convertion canceled');
    } else {
      logger.error(
        'File convertion error with returnCode ${returnCode?.getValue()}',
      );
    }

    return null;
  }
}
