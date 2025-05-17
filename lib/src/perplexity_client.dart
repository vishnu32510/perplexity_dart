import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/model.dart';

/// Client for interacting with the Perplexity AI API.
class PerplexityClient {
  /// API key used for authentication with Perplexity AI.
  final String apiKey;

  /// Base URL for the Perplexity API.
  final String baseUrl;

  /// Creates a new Perplexity API client.
  ///
  /// [apiKey] is required for authentication with the Perplexity API.
  /// [baseUrl] defaults to 'https://api.perplexity.ai' but can be overridden for testing.
  PerplexityClient(
      {required this.apiKey, this.baseUrl = 'https://api.perplexity.ai'});

  /// Sends a message to the Perplexity API and returns a non-streaming response.
  ///
  /// [requestModel] contains the message content and configuration options.
  /// Returns a [ChatResponse] with the AI's response.
  /// Throws an exception if the API request fails.
  Future<ChatResponse> sendMessage(
      {required ChatRequestModel requestModel}) async {
    final request = requestModel.copyWith(stream: false);

    final response = await http.post(
      Uri.parse('$baseUrl/chat/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return ChatResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to get response: ${response.statusCode} - ${response.body}');
    }
  }

  /// Streams a chat response from the Perplexity API.
  ///
  /// [requestModel] contains the message content and configuration options.
  /// Returns a stream of string chunks that form the complete response.
  /// Throws an exception if the API request fails.
  Stream<String> streamChat({required ChatRequestModel requestModel}) async* {
    final request = requestModel.copyWith(stream: true);

    final uri = Uri.parse('$baseUrl/chat/completions');
    final client = http.Client();

    final req = http.Request("POST", uri)
      ..headers.addAll({
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json'
      })
      ..body = jsonEncode(request.toJson());

    final response = await client.send(req);

    if (response.statusCode != 200) {
      throw Exception('Failed to connect: ${response.statusCode}');
    }

    final lines =
        response.stream.transform(utf8.decoder).transform(const LineSplitter());

    await for (final line in lines) {
      if (line.trim().isEmpty || line == 'data: [DONE]') continue;

      final jsonLine = line.replaceFirst('data: ', '');
      final jsonData = jsonDecode(jsonLine);
      final delta = jsonData['choices'][0]['delta'];
      final chunk = delta['content'] ?? '';
      yield chunk;
    }

    client.close();
  }
}
