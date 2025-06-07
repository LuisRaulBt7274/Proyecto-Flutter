import 'package:flutter/material.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  final List<Map<String, String>> flashcards = [
    {'question': '¿Qué es la física?', 'answer': 'La física es la rama de la ciencia que estudia las propiedades del espacio, tiempo, materia y energía, así como sus interacciones.'},
    {'question': '¿Cuál es la diferencia entre masa y peso?', 'answer': 'La masa es la cantidad de materia que tiene un cuerpo, mientras que el peso es la fuerza con que la gravedad atrae a ese cuerpo hacia la Tierra.'},
    {'question': '¿Qué es la inercia?', 'answer': 'Es la propiedad de los cuerpos de mantener su estado de reposo o movimiento rectilíneo uniforme a menos que una fuerza externa actúe sobre ellos.'},
    {'question': '¿En qué consiste la primera ley de Newton?', 'answer': 'Todo objeto permanece en estado de reposo o de movimiento rectilíneo uniforme a menos que una fuerza externa no equilibrada actúe sobre él.'},
    {'question': '¿Qué es la aceleración?', 'answer': 'La aceleración es la tasa de cambio de la velocidad con respecto al tiempo.'},
    {'question': '¿Cuál es la fórmula para calcular la velocidad?', 'answer': 'Velocidad es el desplazamiento dividido por el tiempo.'},
    {'question': '¿Qué es la energía cinética?', 'answer': 'Es la energía que posee un cuerpo debido a su movimiento.'},
    {'question': '¿Qué es la energía potencial gravitatoria?', 'answer': 'Es la energía almacenada en un cuerpo debido a su posición en un campo gravitacional.'},
    {'question': '¿Qué es el trabajo en física y cómo se calcula?', 'answer': 'Trabajo es la fuerza aplicada sobre un objeto multiplicada por el desplazamiento en la dirección de la fuerza: W=Fxd'},
    {'question': '¿Cuál es la diferencia entre un vector y un escalar?', 'answer': 'Un vector tiene magnitud, dirección y sentido; un escalar solo tiene magnitud.'},
    {'question': '¿Qué es la fuerza y cuál es su unidad en el Sistema Internacional?', 'answer': 'La fuerza es toda causa capaz de deformar un cuerpo o cambiar su estado de movimiento; su unidad es el newton (N).'},
    {'question': '¿Qué es la ley de la conservación de la energía?', 'answer': 'La energía no se crea ni se destruye, solo se transforma de una forma a otra.'},
  ];

  int currentIndex = 0;
  bool showAnswer = false;

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % flashcards.length;
      showAnswer = false;
    });
  }

  void toggleCard() {
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = flashcards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: toggleCard,
          child: Card(
            margin: const EdgeInsets.all(20),
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.all(30),
              width: double.infinity,
              height: 250,
              child: Center(
                child: Text(
                  showAnswer ? card['answer']! : card['question']!,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: nextCard,
        child: const Icon(Icons.navigate_next),
      ),
    );
  }
}
