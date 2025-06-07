import 'package:flutter/material.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _addFlashcardPair(); // Agrega las primeras dos cajas al iniciar
  }

  void _addFlashcardPair() {
    setState(() {
      _controllers.add(TextEditingController(text: 'Ejemplo'));
      _controllers.add(TextEditingController(text: 'Ejemplo'));
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addFlashcardPair,
          ),
        ],
      ),
      body: _controllers.isEmpty
          ? const Center(child: Text('No hay flashcards aún.'))
          : ListView.builder(
              itemCount: _controllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: TextField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      labelText: 'Flashcard ${index + 1}',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
