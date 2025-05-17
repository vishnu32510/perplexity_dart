/// Model representing a response from the Perplexity API.
class ChatResponse {
  /// The text content of the response.
  final String content;

  /// List of citation sources referenced in the response.
  final List<String> citations;

  /// Creates a new chat response.
  ///
  /// [content] is the text response from the AI.
  /// [citations] is a list of sources referenced in the response.
  ChatResponse({required this.content, required this.citations});

  /// Creates a ChatResponse from a JSON map.
  ///
  /// [json] is the decoded JSON response from the API.
  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    final choices = json['choices'] as List<dynamic>;
    final content = choices.first['message']['content'] ?? '';
    final citations = List<String>.from(json['citations'] ?? []);
    return ChatResponse(content: content, citations: citations);
  }
}
