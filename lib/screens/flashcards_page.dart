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
    final progress = (currentIndex + 1) / flashcards.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade400,
              Colors.indigo.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        ),
                        const Expanded(
                          child: Text(
                            'Flashcards de Física',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.white.withOpacity(0.5), Colors.transparent],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${currentIndex + 1}/${flashcards.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Tarjeta flashcard
              Expanded(
                child: GestureDetector(
                  onTap: toggleCard,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: showAnswer
                            ? [Colors.purple.shade400, Colors.purple.shade600]
                            : [Colors.blue.shade400, Colors.blue.shade600],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Text(
                          showAnswer ? card['answer']! : card['question']!,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Botón de siguiente
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: FloatingActionButton(
                  onPressed: nextCard,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurple,
                  elevation: 5,
                  child: const Icon(Icons.navigate_next, size: 32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
