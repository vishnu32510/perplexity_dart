import 'dart:convert';
import 'dart:io';
import 'package:perplexity_dart/perplexity_dart.dart';
import 'package:dotenv/dotenv.dart' as dotenv;

Future<void> main() async {
  final env = dotenv.DotEnv()..load();
  final apiKey = env['PERPLEXITY_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    print('Error: Missing PERPLEXITY_API_KEY in .env file.');
    exit(1);
  }

  final client = PerplexityClient(apiKey: apiKey);

  print('Welcome to Perplexity CLI Chat');
  print('Type `exit` to quit, or `!img <path-or-URL>` to send an image.');
  print(
      'For multiple images, separate paths/URLs with commas: `!img path1.jpg,https://example.com/img.png`\n');

  while (true) {
    stdout.write('> ');
    final line = stdin.readLineSync(encoding: utf8)?.trim();
    if (line == null || line.toLowerCase() == 'exit') break;

    if (line.startsWith('!img ')) {
      final targets = line.substring(5).trim().split(',');
      List<String> uris = [];

      for (final target in targets) {
        final trimmedTarget = target.trim();
        if (trimmedTarget.startsWith('http')) {
          // It's a URL
          uris.add(trimmedTarget);
        } else {
          // It's a local file
          try {
            final bytes = File(trimmedTarget).readAsBytesSync();
            final ext = trimmedTarget.split('.').last.toLowerCase();
            final mime =
                ext == 'jpg' || ext == 'jpeg' ? 'image/jpeg' : 'image/png';
            uris.add('data:$mime;base64,${base64Encode(bytes)}');
          } catch (e) {
            print('Error processing file $trimmedTarget: $e');
            continue;
          }
        }
      }

      if (uris.isEmpty) {
        print('No valid images found. Please try again.');
        continue;
      }

      stdout.write('Image prompt (enter to default): ');
      final imgPrompt = stdin.readLineSync()?.trim();
      final req = ChatRequestModel.defaultImageRequest(
        urlList: uris,
        imagePrompt: imgPrompt?.isNotEmpty == true
            ? imgPrompt
            : 'Please describe these images and extract key facts.',
        stream: false,
        model: PerplexityModel.sonar,
      );

      stdout.writeln('\n⏳ Sending ${uris.length} image(s)...');
      try {
        final resp = await client.sendMessage(requestModel: req);
        print('\n💬 Image response:\n${resp.content}\n');
      } catch (e) {
        print('Image request failed: $e\n');
      }
    } else {
      stdout.write('Stream? (y/n): ');
      final stream = stdin.readLineSync()?.toLowerCase() == 'y';
      final req = ChatRequestModel.defaultRequest(
        prompt: line,
        stream: stream,
        model: PerplexityModel.sonar,
      );

      if (stream) {
        stdout.write('⏳ ');
        await for (final chunk in client.streamChat(requestModel: req)) {
          stdout.write(chunk);
        }
        print('\n');
      } else {
        try {
          final resp = await client.sendMessage(requestModel: req);
          print('\n💬 ${resp.content}\n');
        } catch (e) {
          print('Error: $e\n');
        }
      }
    }
  }

  print('👋 Goodbye!');
}
