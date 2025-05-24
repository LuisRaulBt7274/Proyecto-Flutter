import 'package:flutter/material.dart';

class AddTemaCard extends StatelessWidget {
  const AddTemaCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Añadir Tema"),
          content: const Text("Implementar formulario aquí"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
          ],
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 36),
            SizedBox(height: 8),
            Text('Añadir'),
          ],
        ),
      ),
    );
  }
}
