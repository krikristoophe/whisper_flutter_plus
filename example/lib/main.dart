import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_whisper/providers.dart';
import 'package:test_whisper/record_page.dart';
import 'package:test_whisper/whisper_controller.dart';
import 'package:test_whisper/whisper_result.dart';
import 'package:whisper_flutter_plus/whisper_flutter_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter whisper demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WhisperModel model = ref.watch(modelProvider);
    final String lang = ref.watch(langProvider);
    final WhisperController controller = ref.watch(
      whisperControllerProvider.notifier,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Whisper flutter demo',
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Consumer(
          builder: (context, ref, _) {
            final AsyncValue<TranscribeResult?> transcriptionAsync = ref.watch(
              whisperControllerProvider,
            );

            return transcriptionAsync.maybeWhen(
              skipLoadingOnRefresh: true,
              skipLoadingOnReload: true,
              data: (TranscribeResult? transcriptionResult) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text('Model :'),
                    DropdownButton(
                      isExpanded: true,
                      value: model,
                      items: WhisperModel.values
                          .map(
                            (WhisperModel model) => DropdownMenuItem(
                              value: model,
                              child: Text(model.modelName),
                            ),
                          )
                          .toList(),
                      onChanged: (WhisperModel? model) {
                        if (model != null) {
                          ref.read(modelProvider.notifier).state = model;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButton(
                      isExpanded: true,
                      value: lang,
                      items: ['id', 'fr', 'en']
                          .map(
                            (String lang) => DropdownMenuItem(
                              value: lang,
                              child: Text(lang),
                            ),
                          )
                          .toList(),
                      onChanged: (String? lang) {
                        if (lang != null) {
                          ref.read(langProvider.notifier).state = lang;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final Directory documentDirectory =
                                await getApplicationDocumentsDirectory();
                            final ByteData documentBytes =
                                await rootBundle.load(
                              'assets/jfk.wav',
                            );

                            final String jfkPath =
                                '${documentDirectory.path}/jfk.wav';

                            await File(jfkPath).writeAsBytes(
                              documentBytes.buffer.asUint8List(),
                            );

                            await controller.transcribe(jfkPath);
                          },
                          child: const Text('jfk.wav'),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () async {
                            final String? recordFilePath =
                                await RecordPage.openRecordPage(
                              context,
                            );

                            if (recordFilePath != null) {
                              await controller.transcribe(recordFilePath);
                            }
                          },
                          child: const Text('record'),
                        ),
                      ],
                    ),
                    if (transcriptionResult != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        transcriptionResult.transcription,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        transcriptionResult.time.toString(),
                      ),
                    ],
                  ],
                );
              },
              orElse: () {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
