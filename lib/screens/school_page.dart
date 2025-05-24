import 'package:flutter/material.dart';
import '../widgets/tema_card.dart';
import '../widgets/add_tema_card.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SchoolPage extends StatelessWidget {
  const SchoolPage({super.key});

  static const List<Map<String, dynamic>> _temas = [
    {'titulo': 'Tema 1', 'icono': LucideIcons.atom},
    {'titulo': 'Tema 2', 'icono': LucideIcons.folder},
    {'titulo': 'Tema 3', 'icono': LucideIcons.folder},
    {'titulo': 'Tema 4', 'icono': LucideIcons.atom},
    {'titulo': 'Tema 5', 'icono': LucideIcons.atom},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: _temas.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  if (index < _temas.length) {
                    return TemaCard(tema: _temas[index]);
                  } else {
                    return const AddTemaCard();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
