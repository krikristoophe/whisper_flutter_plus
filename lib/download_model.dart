import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:whisper_flutter_plus/whisper_flutter_plus.dart';

enum WhisperModel {
  tiny('tiny'),
  base('base'),
  small('small'),
  medium('medium'),
  large('large'),
  tinyEn('tiny.en'),
  baseEn('base.en'),
  smallEn('small.en'),
  mediumEn('medium.en');

  const WhisperModel(this.modelName);

  final String modelName;

  Uri get modelUri {
    return Uri.parse(
      'https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-$modelName.bin',
    );
  }

  String getPath(String dir) {
    return '$dir/ggml-$modelName.bin';
  }
}

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
