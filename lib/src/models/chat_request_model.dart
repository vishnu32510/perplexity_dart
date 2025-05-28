import 'model.dart';

/// Model representing a chat request to the Perplexity API.
class ChatRequestModel {
  /// The Perplexity model to use for generating responses.
  final PerplexityModel model;

  /// List of messages in the conversation.
  final List<MessageModel> messages;

  /// Whether to stream the response or return it all at once.
  final bool? stream;

  /// Maximum number of tokens to generate.
  final int? maxTokens;

  /// Controls randomness in the response (0.0 to 1.0).
  final double? temperature;

  /// Controls diversity via nucleus sampling (0.0 to 1.0).
  final double? topP;

  /// Domains to filter search results to.
  final List<String>? searchDomainFilter;

  /// Whether to return images in the response.
  final bool? returnImages;

  /// Whether to return related questions in the response.
  final bool? returnRelatedQuestions;

  /// Time filter for search results (e.g., 'day', 'week', 'month').
  final String? searchRecencyFilter;

  /// Number of top search results to consider.
  final int? topK;

  /// Penalty for repeating the same token (0.0 to 1.0).
  final double? presencePenalty;

  /// Penalty for repeating the same token sequence (0.0 to 1.0).
  final double? frequencyPenalty;

  /// Format options for the response.
  final Map<String, dynamic>? responseFormat;

  /// Options for web search behavior.
  final Map<String, dynamic>? webSearchOptions;

  /// Creates a new chat request model with the specified parameters.
  ///
  /// [model] and [messages] are required. All other parameters are optional.
  ChatRequestModel({
    required this.model,
    required this.messages,
    this.maxTokens,
    this.temperature,
    this.topP,
    this.searchDomainFilter,
    this.returnImages,
    this.returnRelatedQuestions,
    this.searchRecencyFilter,
    this.topK,
    this.stream,
    this.presencePenalty,
    this.frequencyPenalty,
    this.responseFormat,
    this.webSearchOptions,
  });

  /// Creates a default chat request with minimal configuration.
  ///
  /// [prompt] is the user's input text.
  /// [stream] determines whether to stream the response (defaults to true).
  /// [model] specifies which model to use (defaults to sonar).
  factory ChatRequestModel.defaultRequest({
    required String prompt,
    String? systemPrompt,
    bool? stream,
    PerplexityModel? model,
    int? topk,
    Map<String, dynamic>? responseFormat
  }) {
    return ChatRequestModel(
      responseFormat: responseFormat,
      stream: stream ?? true,
      model: model ?? PerplexityModel.sonar,
      topK: topk,
      messages: [
        StandardMessageModel(
          role: MessageRole.system,
          content: systemPrompt?? 'Be precise and concise.',
        ),
        StandardMessageModel(
          role: MessageRole.user,
          content: prompt,
        ),
      ],
    );
  }
  /// Creates a chat request that includes an image.
  ///
  /// [url] is the HTTP or data-URI of the image.
  /// [systemPrompt] is an optional system instruction.
  /// [imagePrompt] is an optional text prompt describing what to do with the image.
  /// [stream] toggles streaming responses.
  /// [model] selects which Perplexity model to use.
  factory ChatRequestModel.defaultImageRequest({
    required List<String> urlList,
    String? systemPrompt,
    String? imagePrompt,
    bool? stream,
    int? topk,
    PerplexityModel? model,
    Map<String, dynamic>? responseFormat
  }) {
    /// Create a list of ImagePart objects from the urlList
    List<MessagePart> contentParts = [
      TextPart(text: imagePrompt ?? 'Extract Details From Image'),
    ];
    
    /// Add each URL as an ImagePart
    for (String url in urlList) {
      contentParts.add(ImagePart(url: url));
    }
    
    return ChatRequestModel(
      responseFormat: responseFormat,
      topK: topk,
      stream: stream ?? true,
      model: model ?? PerplexityModel.sonar,
      messages: [
        StandardMessageModel(
          role: MessageRole.system,
          content: systemPrompt ?? 'Be precise and concise.',
        ),
        ImageMessageModel(
          role: MessageRole.user,
          content: contentParts,
        ),
      ],
    );
  }

  /// Converts this model to a JSON map for API requests.
  ///
  /// Returns a map with all non-null properties included.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'model': model.name,
      'messages': messages.map((m) => m.toJson()).toList(),
    };

    if (maxTokens != null) {
      json['max_tokens'] = maxTokens;
    }
    if (temperature != null) {
      json['temperature'] = temperature;
    }
    if (topP != null) {
      json['top_p'] = topP;
    }
    if (searchDomainFilter != null) {
      json['search_domain_filter'] = searchDomainFilter;
    }
    if (returnImages != null) {
      json['return_images'] = returnImages;
    }
    if (returnRelatedQuestions != null) {
      json['return_related_questions'] = returnRelatedQuestions;
    }
    if (searchRecencyFilter != null) {
      json['search_recency_filter'] = searchRecencyFilter;
    }
    if (topK != null) {
      json['top_k'] = topK;
    }
    if (stream != null) {
      json['stream'] = stream;
    }
    if (presencePenalty != null) {
      json['presence_penalty'] = presencePenalty;
    }
    if (frequencyPenalty != null) {
      json['frequency_penalty'] = frequencyPenalty;
    }
    if (responseFormat != null) {
      json['response_format'] = responseFormat;
    }
    if (webSearchOptions != null) {
      json['web_search_options'] = webSearchOptions;
    }

    return json;
  }
}

/// Extension providing a copyWith method for [ChatRequestModel].
extension ChatRequestModelCopyWith on ChatRequestModel {
  /// Creates a copy of this model with the specified fields replaced.
  ///
  /// Any parameter not provided will keep its original value.
  ChatRequestModel copyWith({
    PerplexityModel? model,
    List<MessageModel>? messages,
    bool? stream,
    int? maxTokens,
    double? temperature,
    double? topP,
    List<String>? searchDomainFilter,
    bool? returnImages,
    bool? returnRelatedQuestions,
    String? searchRecencyFilter,
    int? topK,
    double? presencePenalty,
    double? frequencyPenalty,
    Map<String, dynamic>? responseFormat,
    Map<String, dynamic>? webSearchOptions,
  }) {
    return ChatRequestModel(
      model: model ?? this.model,
      messages: messages ?? this.messages,
      stream: stream ?? this.stream,
      maxTokens: maxTokens ?? this.maxTokens,
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      searchDomainFilter: searchDomainFilter ?? this.searchDomainFilter,
      returnImages: returnImages ?? this.returnImages,
      returnRelatedQuestions:
          returnRelatedQuestions ?? this.returnRelatedQuestions,
      searchRecencyFilter: searchRecencyFilter ?? this.searchRecencyFilter,
      topK: topK ?? this.topK,
      presencePenalty: presencePenalty ?? this.presencePenalty,
      frequencyPenalty: frequencyPenalty ?? this.frequencyPenalty,
      responseFormat: responseFormat ?? this.responseFormat,
      webSearchOptions: webSearchOptions ?? this.webSearchOptions,
    );
  }
}
