import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:perplexity_dart/perplexity_dart.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // Add .env to assets in pubspec.yaml
  runApp(const PerplexityApp());
}

class PerplexityApp extends StatelessWidget {
  const PerplexityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perplexity Chat',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final PerplexityClient _client = PerplexityClient(
    apiKey: dotenv.env['PERPLEXITY_API_KEY'] ?? 'your-api-key-here-temp',
  );

  bool _useStreaming = false;
  bool _isLoading = false;
  String _response = '';

  void _sendPrompt() {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _response = '';
      _isLoading = true;
    });

    final request = ChatRequestModel.defaultRequest(
      prompt: prompt,
      stream: _useStreaming,
      model: PerplexityModel.sonar,
    );

    if (_useStreaming) {
      _client
          .streamChat(requestModel: request)
          .listen(
            (chunk) {
              setState(() {
                _response += chunk;
              });
            },
            onDone: () {
              setState(() => _isLoading = false);
            },
            onError: (e) {
              setState(() {
                _response = '❌ Error: $e';
                _isLoading = false;
              });
            },
            cancelOnError: true,
          );
    } else {
      _client
          .sendMessage(requestModel: request)
          .then((res) {
            setState(() {
              _response = res.content;
              _isLoading = false;
            });
          })
          .catchError((e) {
            setState(() {
              _response = '❌ Error: $e';
              _isLoading = false;
            });
          });
    }
  }

  Widget _buildResponse() {
    return SelectableText(
      _response.isEmpty ? '🤖 Response will appear here' : _response,
      style: const TextStyle(fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Perplexity Chat")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter your prompt',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _sendPrompt(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Use Streaming"),
                Switch(
                  value: _useStreaming,
                  onChanged: (val) {
                    setState(() {
                      _useStreaming = val;
                    });
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendPrompt,
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Send'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(child: SingleChildScrollView(child: _buildResponse())),
          ],
        ),
      ),
    );
  }
}
