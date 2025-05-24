import 'package:flutter/material.dart';

class CounterButton extends StatelessWidget {
  final String count;
  final String label;
  final Widget page;

  const CounterButton({
    super.key,
    required this.count,
    required this.label,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.black),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(label),
        ),
      ],
    );
  }
}
