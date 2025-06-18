import 'package:flutter/material.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> with TickerProviderStateMixin {
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
  late AnimationController _flipController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _flipAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  // Colores gradientes para las tarjetas (versión oscura)
  final List<List<Color>> cardGradients = [
    [Color(0xFF434343), Color(0xFF000000)], // Gris oscuro a negro
    [Color(0xFF2c3e50), Color(0xFF4ca1af)], // Azul oscuro a turquesa
    [Color(0xFF8e0e00), Color(0xFF1f1c18)], // Rojo oscuro a negro
    [Color(0xFF1a2980), Color(0xFF26d0ce)], // Azul marino a cyan
    [Color(0xFF614385), Color(0xFF516395)], // Púrpura a azul
    [Color(0xFF16222A), Color(0xFF3A6073)], // Azul muy oscuro a azul
    [Color(0xFF200122), Color(0xFF6f0000)], // Púrpura oscuro a rojo oscuro
    [Color(0xFF0f2027), Color(0xFF203a43)], // Azul oscuro a azul grisáceo
    [Color(0xFF283048), Color(0xFF859398)], // Azul oscuro a gris
    [Color(0xFF232526), Color(0xFF414345)], // Gris oscuro a gris más oscuro
    [Color(0xFF1D4350), Color(0xFFA43931)], // Azul verdoso a rojo oscuro
    [Color(0xFF3a7bd5), Color(0xFF00d2ff)], // Azul a cyan (único más claro)
  ];

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward(); // Iniciar la animación al comenzar

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _flipController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % flashcards.length;
      showAnswer = false;
    });

    _slideController.forward(from: 0.0);
    _flipController.reset();
  }

  void toggleCard() {
    setState(() {
      showAnswer = !showAnswer;
    });

    if (showAnswer) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final card = flashcards[currentIndex];
    final gradient = cardGradients[currentIndex % cardGradients.length];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF434343), Color(0xFF000000)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1a1a1a),
              Color(0xFF0d0d0d),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Contador de tarjetas con animación
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradient),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: gradient[0].withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        '${currentIndex + 1} / ${flashcards.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Tarjeta principal con animaciones
              SlideTransition(
                position: _slideAnimation,
                child: GestureDetector(
                  onTap: toggleCard,
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      final isShowingFront = _flipAnimation.value < 0.5;
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(_flipAnimation.value * 3.14159),
                        child: Card(
                          margin: const EdgeInsets.all(20),
                          elevation: 15,
                          shadowColor: gradient[0].withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: gradient[1].withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icono animado
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    showAnswer ? Icons.lightbulb : Icons.help_outline,
                                    key: ValueKey(showAnswer),
                                    size: 40,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Texto de la tarjeta (con transformación para compensar el giro)
                                Expanded(
                                  child: Center(
                                    child: Transform(
                                      transform: Matrix4.identity()
                                        ..rotateY(_flipAnimation.value * 3.14159),
                                      alignment: Alignment.center,
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 300),
                                        child: Text(
                                          isShowingFront || !showAnswer
                                              ? card['question']!
                                              : card['answer']!,
                                          key: ValueKey('${currentIndex}_${showAnswer}'),
                                          style: const TextStyle(
                                            fontSize: 22,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            height: 1.4,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Indicador de acción
                                AnimatedOpacity(
                                  opacity: showAnswer ? 0.7 : 1.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Transform(
                                    transform: Matrix4.identity()
                                      ..rotateY(_flipAnimation.value * 3.14159),
                                    alignment: Alignment.center,
                                    child: Text(
                                      showAnswer ? 'Toca para ver pregunta' : 'Toca para ver respuesta',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.8),
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Botón de progreso
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / flashcards.length,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(gradient[0]),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value * 0.9 + 0.1,
            child: FloatingActionButton.extended(
              onPressed: nextCard,
              backgroundColor: gradient[0],
              icon: const Icon(Icons.navigate_next, color: Colors.white),
              label: const Text(
                'Siguiente',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              elevation: 8,
            ),
          );
        },
      ),
    );
  }
}