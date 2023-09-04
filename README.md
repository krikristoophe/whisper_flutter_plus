# Whisper Flutter Plus

Ready to use [whisper.cpp](https://github.com/ggerganov/whisper.cpp) models implementation for iOS and Android

> Inspired by [whisper_dart](https://pub.dev/packages/whisper_dart) and [whisper_flutter](https://pub.dev/packages/whisper_flutter).

## Install library

```bash
flutter pub add whisper_flutter_plus
```

## import library

```dart
import 'package:whisper_flutter_plus/whisper_flutter_plus.dart';
```

## Quickstart

```dart
// Prepare wav file
final Directory documentDirectory = await getApplicationDocumentsDirectory();
final ByteData documentBytes = await rootBundle.load('assets/jfk.wav');

final String jfkPath = '${documentDirectory.path}/jfk.wav';

await File(jfkPath).writeAsBytes(
    documentBytes.buffer.asUint8List(),
);

// Begin whisper transcription
final Whisper whisper = Whisper(
    model: WhisperModel.base,
);

final String? whisperVersion = await whisper.getVersion();
print(whisperVersion);

final String transcription = await whisper.transcribe(
    transcribeRequest: TranscribeRequest(
        audio: jfkPath,
        isTranslate: true, // Translate result from audio lang to english text
        isNoTimestamps: false, // Get segments in result
        splitOnWord: true, // Split segments on each word 
    ),
);
print(transcription);
```
