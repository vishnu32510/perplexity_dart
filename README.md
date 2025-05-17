# perplexity_dart

[![pub package](https://img.shields.io/pub/v/perplexity_dart.svg)](https://pub.dev/packages/perplexity_dart)
[![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)

**Perplexity Dart SDK** is a lightweight and type-safe Dart client for interacting with [Perplexity.ai](https://www.perplexity.ai)'s `chat/completions` API.  
It supports both streaming and non-streaming responses, flexible model switching (e.g., `sonar`, `sonar-pro`, etc.), and is designed to work with Flutter apps.

---

## ✨ Features

- 🔁 Streamed and full chat completion support
- 🎯 Switch between models with known context lengths
- 💬 Chat roles: `system`, `user`, `assistant`, `tool`
- 🖼️ *Coming soon:* Image input via base64 or HTTPS URL

---

## 🚀 Getting Started

Add the SDK to your project:

```yaml
dependencies:
  perplexity_dart: ^1.0.0
```

## 🔌 Direct API Usage

For more control, you can use the `PerplexityClient` directly:

```dart
import 'package:perplexity_dart/perplexity_dart.dart';

void main() async {
  final client = PerplexityClient(
    apiKey: 'your-api-key',
  );
  
  // Create messages
  final messages = [
    MessageModel(
      role: MessageRole.system,
      content: 'Be precise and concise.',
    ),
    MessageModel(
      role: MessageRole.user,
      content: 'Hello, how are you?',
    ),
  ];
  
  // Non-streaming response
  final requestModel = ChatRequestModel(
    model: PerplexityModel.sonarPro,
    messages: messages,
    stream: false,
  );
  
  final response = await client.sendMessage(requestModel: requestModel);
  print(response.content);
  
  // Streaming response
  final streamRequestModel = ChatRequestModel(
    model: PerplexityModel.sonar,
    messages: messages,
    stream: true,
  );
  
  final stream = client.streamChat(requestModel: streamRequestModel);
  
  await for (final chunk in stream) {
    print(chunk);
  }
}
```

## 📋 Available Models

The SDK supports all current Perplexity models with their context lengths:

- `PerplexityModel.sonar` - 128K tokens
- `PerplexityModel.sonarPro` - 200K tokens
- `PerplexityModel.sonarDeepResearch` - 128K tokens
- `PerplexityModel.sonarReasoning` - 128K tokens
- `PerplexityModel.sonarReasoningPro` - 128K tokens

## 🔧 Advanced Configuration

The `ChatRequestModel` supports various parameters for fine-tuning your requests:

```dart
final requestModel = ChatRequestModel(
  model: PerplexityModel.sonar,
  messages: messages,
  stream: true,
  maxTokens: 1000,
  temperature: 0.7,
  topP: 0.9,
  searchDomainFilter: ['example.com'],
  returnImages: false,
  returnRelatedQuestions: true,
  searchRecencyFilter: 'day',
  topK: 3,
  presencePenalty: 0.0,
  frequencyPenalty: 0.0,
);
```

<a href="https://buymeacoffee.com/vishnu3251p" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-blue.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

[![Buy Me a Coffee](https://img.shields.io/badge/buy%20me%20a%20coffee-donate-yellow)](https://buymeacoffee.com/vishnu3251p)
