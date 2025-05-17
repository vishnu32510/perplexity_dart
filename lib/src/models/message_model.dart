/// Model representing a message in a conversation with Perplexity AI.
class MessageModel {
  /// The role of the message sender (system, user, assistant, or tool).
  final MessageRole role;

  /// The text content of the message.
  final String content;

  /// Creates a new message model.
  ///
  /// [role] specifies who sent the message.
  /// [content] is the text content of the message.
  MessageModel({required this.role, required this.content});

  /// Converts this model to a JSON map for API requests.
  ///
  /// Returns a map with role and content properties.
  Map<String, dynamic> toJson() => {
        'role': role.name,
        'content': content,
      };
}

/// Represents the role of a message sender in a conversation.
class MessageRole {
  /// The name of the role as recognized by the Perplexity API.
  final String name;

  /// Creates a new message role with the specified name.
  ///
  /// This constructor is private to encourage use of the predefined roles.
  const MessageRole._(this.name);

  /// System role for setting context or instructions.
  static const MessageRole system = MessageRole._('system');

  /// User role for messages from the end user.
  static const MessageRole user = MessageRole._('user');

  /// Assistant role for messages from the AI assistant.
  static const MessageRole assistant = MessageRole._('assistant');

  /// Tool role for messages from tools or function calls.
  static const MessageRole tool = MessageRole._('tool');

  /// List of all predefined message roles.
  static const List<MessageRole> values = [system, user, assistant, tool];

  /// Creates a role from a string name, supporting future/dynamic roles.
  ///
  /// If the name matches a predefined role, returns that role.
  /// Otherwise, creates a custom role with the given name.
  factory MessageRole.dynamic(String roleName) {
    return values.firstWhere(
      (role) => role.name == roleName,
      orElse: () => MessageRole._(roleName),
    );
  }

  @override
  String toString() => name;
}
