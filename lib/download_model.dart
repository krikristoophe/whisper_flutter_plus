import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:whisper_flutter_plus/whisper_flutter_plus.dart';

/// Available whisper models
enum WhisperModel {
  /// tiny model for all languages
  tiny('tiny'),

  /// base model for all languages
  base('base'),

  /// small model for all languages
  small('small'),

  /// medium model for all languages
  medium('medium'),

  /// large model for all languages
  large('large'),

  /// tiny model for english only
  tinyEn('tiny.en'),

  /// base model for english only
  baseEn('base.en'),

  /// small model for english only
  smallEn('small.en'),

  /// medium model for english only
  mediumEn('medium.en');

  const WhisperModel(this.modelName);

  /// Public name of model
  final String modelName;

  /// Huggingface url to download model
  Uri get modelUri {
    return Uri.parse(
      'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-$modelName.bin',
    );
  }

  /// Get local path of model file
  String getPath(String dir) {
    return '$dir/ggml-$modelName.bin';
  }
}

/// Download [model] to [destinationPath]
Future<String> downloadModel({
  required WhisperModel model,
  required String destinationPath,
}) async {
  logger.info('Download model ${model.modelName}');
  final httpClient = HttpClient();

  final request = await httpClient.getUrl(
    model.modelUri,
  );

  final response = await request.close();

  final bytes = await consolidateHttpClientResponseBytes(response);

  final File file = File(
    model.getPath(destinationPath),
  );
  await file.writeAsBytes(bytes);

  return file.path;
}
