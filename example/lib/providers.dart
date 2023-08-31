import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper_flutter_plus/whisper_flutter_plus.dart';

final modelProvider = StateProvider.autoDispose((ref) => WhisperModel.base);

final langProvider = StateProvider.autoDispose((ref) => 'id');
