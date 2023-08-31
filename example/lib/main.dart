import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper_flutter_plus/whisper_flutter_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _text;
  Future<void> _transcribe() async {
    final Directory documentDirectory =
        await getApplicationDocumentsDirectory();
    final ByteData documentBytes = await rootBundle.load('assets/jfk.wav');

    await File('${documentDirectory.path}/jfk.wav').writeAsBytes(
      documentBytes.buffer.asUint8List(),
    );

    const Whisper whisper = Whisper(
      model: WhisperModel.base,
    );
    final String? whisperVersion = await whisper.getVersion();
    print(whisperVersion);

    final DateTime start = DateTime.now();
    final String transcription = await whisper.transcribe(
      transcribeRequest: TranscribeRequest(
        audio: '${documentDirectory.path}/jfk.wav',
      ),
    );
    print(transcription);

    print(DateTime.now().difference(start));

    setState(() {
      _text = transcription;
    });

    /// auto convert any fideo
    /* Transcribe transcribeAnyAudio = await whisper.transcribe(
      audio: WhisperAudioconvert.convert(
        audioInput: File('./path_audio_any_format'),
        audioOutput: File('./path_audio_convert.wav'),
      ).path,
      model: './path_model_whisper_bin',
      language: 'id', // language
    );
    print(transcribeAnyAudio); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_text != null)
              Text(
                _text!,
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _transcribe,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
