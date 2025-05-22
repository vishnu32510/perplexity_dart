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
  } else {
    print('API Key Loaded Successfully');
  }

  final client = PerplexityClient(apiKey: apiKey);

  stdout.writeln('Welcome to Perplexity CLI Chat');
  stdout.writeln('Enter "exit" to quit.\n');

  while (true) {
    stdout.write('You: ');
    final input = stdin.readLineSync(encoding: utf8)?.trim();
    if (input == null || input.toLowerCase() == 'exit') break;

    stdout.write('Use streaming? (y/n): ');
    final streamChoice = stdin.readLineSync()?.toLowerCase().trim() == 'y';

    final request = ChatRequestModel.defaultRequest(
      prompt: input,
      stream: streamChoice,
      model: PerplexityModel.sonar,
    );

    if (streamChoice) {
      stdout.write('Perplexity (streaming): ');
      await for (final chunk in client.streamChat(requestModel: request)) {
        stdout.write(chunk);
      }
      stdout.write('\n\n');
    } else {
      try {
        final response = await client.sendMessage(requestModel: request);
        stdout.writeln('Perplexity: ${response.content}\n');
      } catch (e) {
        stdout.writeln('Error: $e\n');
      }
    }
  }

  stdout.writeln('Goodbye!');
}
