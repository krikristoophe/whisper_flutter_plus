import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

class RecordController extends StateNotifier<bool> {
  RecordController() : super(false);

  final Record _record = Record();

  Future<void> startRecord() async {
    if (!await _record.hasPermission()) {
      return;
    }
    state = true;
    await _record.start(
      encoder: AudioEncoder.wav,
      samplingRate: 16000,
    );
  }

  Future<String?> stopRecord() async {
    final String? path = await _record.stop();
    state = false;
    return path;
  }
}

final recordControllerProvider =
    StateNotifierProvider.autoDispose<RecordController, bool>(
  (ref) => RecordController(),
);

class RecordPage extends ConsumerWidget {
  const RecordPage({super.key});

  static Future<String?> openRecordPage(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const RecordPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RecordController controller = ref.watch(
      recordControllerProvider.notifier,
    );
    final bool isRecording = ref.watch(recordControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Record'),
      ),
      body: SafeArea(
        child: Center(
          child: isRecording
              ? ElevatedButton(
                  onPressed: () async {
                    final String? outputPath = await controller.stopRecord();

                    Navigator.of(context).pop(outputPath);
                  },
                  child: const Text('stop'),
                )
              : ElevatedButton(
                  onPressed: () async {
                    await controller.startRecord();
                  },
                  child: const Text('start'),
                ),
        ),
      ),
    );
  }
}
