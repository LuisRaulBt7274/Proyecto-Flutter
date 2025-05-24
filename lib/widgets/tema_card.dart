import 'package:flutter/material.dart';

class TemaCard extends StatelessWidget {
  final Map<String, dynamic> tema;

  const TemaCard({super.key, required this.tema});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(tema['icono'], size: 36),
          const SizedBox(height: 8),
          Text(tema['titulo']),
        ],
      ),
    );
  }
}
