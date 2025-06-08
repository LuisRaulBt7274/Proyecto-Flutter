import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  // Reemplaza con tu API Key de Gemini
  static const String _geminiApiKey = 'AIzaSyCsv2eWD2TJkLNh9OQkt4lU2YqKUKm3yII';

  Future<void> _sendMessage(String text) async {
    setState(() {
      _messages.add({"role": "user", "content": text});
      _isLoading = true;
    });

    final pregunta = text.toLowerCase().trim();

    if (pregunta == '¿qué eres?' || pregunta == 'que eres') {
      setState(() {
        _messages.add({
          "role": "assistant",
          "content": "Soy FisiBot, un asistente de física diseñado para ayudarte a resolver ejercicios y entender conceptos de forma clara y sencilla."
        });
        _isLoading = false;
        _controller.clear();
      });
      return;
    }

    try {
      // Construir el contexto de la conversación para Gemini
      String conversationContext = "Eres un asistente de física llamado Fisibot que ayuda a resolver ejercicios y explicar conceptos de forma clara.\n\n";

      // Agregar mensajes anteriores al contexto
      for (int i = 0; i < _messages.length - 1; i++) {
        final msg = _messages[i];
        if (msg["role"] == "user") {
          conversationContext += "Usuario: ${msg["content"]}\n";
        } else {
          conversationContext += "Asistente: ${msg["content"]}\n";
        }
      }

      conversationContext += "Usuario: $text\nAsistente:";

      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$_geminiApiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text": conversationContext
                }
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "topK": 40,
            "topP": 0.95,
            "maxOutputTokens": 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extraer la respuesta de Gemini
        String reply = '';
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          reply = data['candidates'][0]['content']['parts'][0]['text'];

          // Limpiar asteriscos de formato Markdown
          reply = reply.replaceAll('**', '').replaceAll('*', '');
        } else {
          reply = 'No se pudo obtener respuesta del asistente.';
        }

        setState(() {
          _messages.add({"role": "assistant", "content": reply.trim()});
        });
      } else {
        throw Exception("Error API: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      setState(() {
        _messages.add({"role": "assistant", "content": "Ocurrió un error: $e"});
      });
    } finally {
      setState(() {
        _isLoading = false;
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente de Física'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['role'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? theme.primaryColor : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['content']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading) const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu pregunta...',
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty) {
                        _sendMessage(text.trim());
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      _sendMessage(text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}