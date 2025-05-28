/// The base class for all Perplexity chat messages.
///
/// Subclasses must implement [toJson] to convert themselves into the
/// structure expected by Perplexity’s API.
sealed class MessageModel {
  /// Converts this model into a JSON-compatible map for API requests.
  Map<String, dynamic> toJson();
}

/// A standard text‐only chat message.
///
/// Example JSON:
/// ```json
/// {
///   "role": "user",
///   "content": "Hello, how are you?"
/// }
/// ```
class StandardMessageModel extends MessageModel {
  /// Who is sending the message: `system`, `user`, `assistant` or `tool`.
  final MessageRole role;

  /// The plain-text content of the message.
  final String content;

  /// Creates a new text message.
  ///
  /// - [role]: the sender’s role in the conversation.
  /// - [content]: the textual content.
  StandardMessageModel({
    required this.role,
    required this.content,
  });

  @override
  Map<String, dynamic> toJson() => {
        'role': role.name,
        'content': content,
      };
}

/// A chat message that mixes text and images in one payload.
///
/// You supply a list of [MessagePart]s, which can be either [TextPart]
/// or [ImagePart]. The API will see something like:
///
/// ```json
/// {
///   "role": "user",
///   "content": [
///     { "type": "text", "text": "Describe this image:" },
///     { "type": "image_url", "image_url": { "url": "<your‐url>" } }
///   ]
/// }
/// ```
class ImageMessageModel extends MessageModel {
  /// Who is sending the message.
  final MessageRole role;

  /// A sequence of text and/or image parts.
  final List<MessagePart> content;

  /// Creates a mixed text+image message.
  ///
  /// - [role]: the sender’s role.
  /// - [content]: a list of [TextPart] and/or [ImagePart].
  ImageMessageModel({
    required this.role,
    required this.content,
  });

  @override
  Map<String, dynamic> toJson() => {
        'role': role.name,
        'content': content.map((p) => p.toJson()).toList(),
      };
}

/// The base class for a piece of a mixed‐content message.
///
/// Use [TextPart] for plain text, or [ImagePart] to embed an image URL.
sealed class MessagePart {
  /// Converts this part into the JSON fragment expected by the API.
  Map<String, dynamic> toJson();
}

/// A single block of text within an [ImageMessageModel].
///
/// Example:
/// ```json
/// { "type": "text", "text": "Here is a photo of my cat." }
/// ```
class TextPart extends MessagePart {
  /// The textual content.
  final String text;

  /// Creates a new text segment.
  ///
  /// - [text]: the string to send.
  TextPart({required this.text});

  @override
  Map<String, dynamic> toJson() => {
        'type': 'text',
        'text': text,
      };
}

/// A single image‐URL block within an [ImageMessageModel].
///
/// Example:
/// ```json
/// {
///   "type": "image_url",
///   "image_url": { "url": "https://..." }
/// }
/// ```
class ImagePart extends MessagePart {
  /// The HTTPS URL or data URI of the image.
  final String url;

  /// Creates a new image segment.
  /// - [url]: the image URI (e.g. data:image/png;base64,… or https://…).
  ImagePart({required this.url});

  @override
  Map<String, dynamic> toJson() => {
        'type': 'image_url',
        'image_url': {'url': url},
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
