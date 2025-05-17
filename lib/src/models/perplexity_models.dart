/// Represents a Perplexity AI model with its capabilities.
class PerplexityModel {
  /// The name of the model as recognized by the Perplexity API.
  final String name;

  /// The maximum context length in tokens that this model supports.
  final int? contextLength;

  /// Creates a new model with the specified name and context length.
  const PerplexityModel._(this.name, [this.contextLength]);

  /// Sonar model - general purpose with 128K context.
  static const PerplexityModel sonar = PerplexityModel._('sonar', 128000);

  /// Sonar Pro model - enhanced capabilities with 200K context.
  static const PerplexityModel sonarPro =
      PerplexityModel._('sonar-pro', 200000);

  /// Sonar Deep Research model - specialized for in-depth research with 128K context.
  static const PerplexityModel sonarDeepResearch =
      PerplexityModel._('sonar-deep-research', 128000);

  /// Sonar Reasoning model - specialized for logical reasoning with 128K context.
  static const PerplexityModel sonarReasoning =
      PerplexityModel._('sonar-reasoning', 128000);

  /// Sonar Reasoning Pro model - enhanced reasoning capabilities with 128K context.
  static const PerplexityModel sonarReasoningPro =
      PerplexityModel._('sonar-reasoning-pro', 128000);

  /// List of all predefined Perplexity models.
  static const List<PerplexityModel> values = [
    sonar,
    sonarPro,
    sonarDeepResearch,
    sonarReasoning,
    sonarReasoningPro,
  ];

  /// Creates a model instance from a string name.
  ///
  /// If the name matches a predefined model, returns that model.
  /// Otherwise, creates a custom model with the given name.
  factory PerplexityModel(String name) {
    try {
      return values.firstWhere((m) => m.name == name);
    } catch (_) {
      return PerplexityModel._(name);
    }
  }

  /// Whether this model is one of the predefined known models.
  bool get isKnown => values.any((m) => m.name == name);
}
