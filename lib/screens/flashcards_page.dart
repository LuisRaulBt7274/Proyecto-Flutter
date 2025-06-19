import 'dart:math';
import 'package:flutter/material.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({Key? key}) : super(key: key);

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  final List<Map<String, String>> flashcards = [
    {'question': '¿Qué es la física?', 'answer': 'La física estudia las propiedades del espacio, tiempo, materia y energía.'},
    {'question': '¿Cuál es la diferencia entre masa y peso?', 'answer': 'La masa es cantidad de materia, el peso es la fuerza con que la gravedad atrae esa masa.'},
    {'question': '¿Qué es la inercia?', 'answer': 'Es la propiedad de los cuerpos de resistirse al cambio de su estado de movimiento.'},
    {'question': '¿En qué consiste la primera ley de Newton?', 'answer': 'Todo cuerpo permanece en reposo o MRU a menos que una fuerza lo modifique.'},
    {'question': '¿Qué es la aceleración?', 'answer': 'Es el cambio de velocidad respecto al tiempo.'},
    {'question': '¿Cuál es la fórmula para calcular la velocidad?', 'answer': 'Velocidad = desplazamiento / tiempo.'},
    {'question': '¿Qué es la energía cinética?', 'answer': 'Energía asociada al movimiento de un objeto.'},
    {'question': '¿Qué es la energía potencial gravitatoria?', 'answer': 'Energía debida a la posición de un objeto en un campo gravitacional.'},
    {'question': '¿Qué es el trabajo y cómo se calcula?', 'answer': 'Trabajo = fuerza × desplazamiento en dirección de la fuerza.'},
    {'question': '¿Qué es un vector?', 'answer': 'Cantidad con magnitud y dirección.'},
    {'question': '¿Qué es un escalar?', 'answer': 'Cantidad que solo tiene magnitud.'},
    {'question': '¿Qué es la fuerza y su unidad en SI?', 'answer': 'Es una interacción que cambia el movimiento, se mide en newtons (N).'},
    {'question': '¿Qué dice la ley de conservación de la energía?', 'answer': 'La energía no se crea ni se destruye, solo se transforma.'},
    {'question': '¿Qué es velocidad promedio?', 'answer': 'Es desplazamiento total dividido entre el tiempo total.'},
    {'question': '¿Qué es la ley de Hooke?', 'answer': 'F = -k·x, donde F es fuerza, k es constante, x es elongación.'},
    {'question': '¿Qué es una onda?', 'answer': 'Perturbación que transporta energía sin transportar materia.'},
    {'question': '¿Qué es el momento lineal?', 'answer': 'Cantidad de movimiento: masa × velocidad.'},
    {'question': '¿Qué dice el principio de Arquímedes?', 'answer': 'Un cuerpo en un fluido recibe un empuje igual al peso del fluido desplazado.'},
    {'question': '¿Qué es un circuito en serie?', 'answer': 'Circuito donde la corriente pasa por un solo camino.'},
    {'question': '¿Qué es resistencia eléctrica?', 'answer': 'Oposición al paso de la corriente en un conductor.'},
    {'question': '¿Qué es la ley de Ohm?', 'answer': 'V = I·R, voltaje es corriente por resistencia.'},
    {'question': '¿Qué son los conductores?', 'answer': 'Materiales que permiten el paso fácil de corriente eléctrica.'},
    {'question': '¿Qué es la temperatura?', 'answer': 'Medida de la energía cinética promedio de las partículas.'},
    {'question': '¿Qué es el calor?', 'answer': 'Transferencia de energía térmica de un cuerpo a otro.'},
    {'question': '¿Qué es un sistema termodinámico?', 'answer': 'Conjunto de cuerpos que interactúan térmicamente.'},
    {'question': '¿Qué es una colisión elástica?', 'answer': 'Choque donde se conserva la energía cinética total.'},
    {'question': '¿Qué es una palanca?', 'answer': 'Máquina simple que amplifica fuerza usando un punto de apoyo.'},
    {'question': '¿Qué es una máquina simple?', 'answer': 'Dispositivo que cambia la magnitud o dirección de una fuerza.'},
    {'question': '¿Qué es la frecuencia?', 'answer': 'Número de ciclos por segundo, se mide en Hz.'},
    {'question': '¿Qué es la longitud de onda?', 'answer': 'Distancia entre dos crestas consecutivas de una onda.'},
    {'question': '¿Qué es el periodo?', 'answer': 'Tiempo que tarda un ciclo completo de una onda.'},
    {'question': '¿Qué es el sonido?', 'answer': 'Onda mecánica longitudinal que se propaga por un medio.'},
    {'question': '¿Qué es la refracción?', 'answer': 'Cambio de dirección de una onda al cambiar de medio.'},
    {'question': '¿Qué es la presión?', 'answer': 'Es la fuerza aplicada por unidad de área.'},
    {'question': '¿Qué es el principio de Pascal?', 'answer': 'Un cambio de presión aplicado a un fluido se transmite uniformemente en todas direcciones.'},
    {'question': '¿Qué es la ley de Boyle?', 'answer': 'Para una masa fija de gas a temperatura constante, presión y volumen son inversamente proporcionales.'},
    {'question': '¿Qué es la ley de Charles?', 'answer': 'El volumen de un gas es directamente proporcional a su temperatura absoluta a presión constante.'},
    {'question': '¿Qué es la densidad?', 'answer': 'Masa por unidad de volumen de una sustancia.'},
    {'question': '¿Qué es la electricidad?', 'answer': 'Fenómeno físico asociado al movimiento y acumulación de cargas eléctricas.'},
    {'question': '¿Qué es un conductor eléctrico?', 'answer': 'Material que permite el flujo fácil de electrones.'},
    {'question': '¿Qué es un aislante eléctrico?', 'answer': 'Material que dificulta el paso de la corriente eléctrica.'},
    {'question': '¿Qué es el campo eléctrico?', 'answer': 'Región del espacio donde una carga eléctrica experimenta una fuerza.'},
    {'question': '¿Qué es la intensidad de corriente?', 'answer': 'Cantidad de carga que pasa por un punto en un segundo.'},
    {'question': '¿Qué es la energía mecánica?', 'answer': 'Suma de energía cinética y potencial de un sistema.'},
    {'question': '¿Qué es un movimiento acelerado?', 'answer': 'Movimiento con cambio de velocidad en magnitud o dirección.'},
    {'question': '¿Qué es la fricción?', 'answer': 'Fuerza que se opone al movimiento relativo entre dos superficies en contacto.'},
    {'question': '¿Qué es el calor específico?', 'answer': 'Cantidad de calor necesaria para elevar la temperatura de un gramo de sustancia en un grado Celsius.'},
    {'question': '¿Qué es el principio de conservación del momento?', 'answer': 'El momento lineal total de un sistema aislado se conserva.'},
    {'question': '¿Qué es un campo magnético?', 'answer': 'Zona en la que una carga en movimiento experimenta una fuerza magnética.'},
    {'question': '¿Qué es la inducción electromagnética?', 'answer': 'Generación de una corriente eléctrica en un conductor debido a un cambio en el flujo magnético.'},
    {'question': '¿Qué es la energía térmica?', 'answer': 'Energía asociada al movimiento microscópico de las partículas de un cuerpo.'},
    {'question': '¿Qué es un isotopo?', 'answer': 'Átomos del mismo elemento con diferente número de neutrones.'},
    {'question': '¿Qué es la radiación?', 'answer': 'Emisión de energía en forma de ondas o partículas.'},
    {'question': '¿Qué es el principio de Arquímedes?', 'answer': 'Un cuerpo sumergido en un fluido recibe un empuje igual al peso del fluido desplazado.'},
    {'question': '¿Qué es la velocidad angular?', 'answer': 'Tasa de cambio del ángulo por unidad de tiempo en un movimiento circular.'},
    {'question': '¿Qué es un sistema aislado?', 'answer': 'Sistema que no intercambia energía ni materia con el exterior.'},
    {'question': '¿Qué es el potencial eléctrico?', 'answer': 'Trabajo por unidad de carga para mover una carga desde un punto hasta otro.'},
    {'question': '¿Qué es la ley de Kirchhoff?', 'answer': 'En un nodo, la suma de corrientes entrantes es igual a la suma de corrientes salientes.'},
    {'question': '¿Qué es la frecuencia de resonancia?', 'answer': 'Frecuencia a la que un sistema oscila con máxima amplitud.'},
    {'question': '¿Qué es un espectro electromagnético?', 'answer': 'Conjunto de todas las frecuencias de radiación electromagnética.'},
    {'question': '¿Qué es el principio de incertidumbre?', 'answer': 'No se puede conocer simultáneamente con precisión la posición y el momento de una partícula.'},
    {'question': '¿Qué es el efecto fotoeléctrico?', 'answer': 'Emisión de electrones de un material cuando se ilumina con luz de cierta frecuencia.'},
    {'question': '¿Qué es el calor latente?', 'answer': 'Cantidad de calor necesario para cambiar el estado de una sustancia sin cambiar su temperatura.'},
    {'question': '¿Qué es la longitud focal de una lente?', 'answer': 'Distancia desde el centro de la lente hasta el foco donde convergen los rayos.'},
  ];

  List<Map<String, String>> selectedFlashcards = [];
  int currentIndex = 0;
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();
    pickRandomFlashcards();
  }

  void pickRandomFlashcards() {
    final random = Random();
    selectedFlashcards = List.from(flashcards)..shuffle(random);
    selectedFlashcards = selectedFlashcards.take(10).toList();
    currentIndex = 0;
    showAnswer = false;
  }

  void nextCard() {
    setState(() {
      currentIndex = (currentIndex + 1) % selectedFlashcards.length;
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
    final card = selectedFlashcards[currentIndex];
    final progress = (currentIndex + 1) / selectedFlashcards.length;

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
                        '${currentIndex + 1}/${selectedFlashcards.length}',
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
              // Botón siguiente
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
