import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exámenes de Física',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ExamenesPage(),
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;

  Question({required this.question, required this.options, required this.correctIndex});
}

class ExamManager {
  static final Map<String, List<Question>> _semesterQuestions = {
    'Física I': [
  Question(
      question: 'Una placa metálica se encuentra bajo la acción de una densidad de flujo magnético de 2 T y un flujo magnético de 15 weber, formando un ángulo de 40° con la línea normal de la placa. ¿Cuál es el valor del radio de la placa?',
      options: ['1.50 m', '2.00 m', '2.45 m', '2.80 m'],
      correctIndex: 2,
    ),
    Question(
      question: 'Una espira cuadrada de 12 cm de lado se encuentra bajo la influencia de un campo magnético de 4 mWb induciendo una densidad magnética de 1.8 T. ¿Qué ángulo forma la normal de la superficie de la espira con respecto a las líneas de campo magnético?',
      options: ['9.57°', '15.43°', '20.12°', '18.76°'],
      correctIndex: 1,
    ),
    Question(
      question: 'Un conductor recto transporta una corriente eléctrica de 1.2 A, generando un campo electromagnético de 0.6 T. ¿A qué distancia del conductor se genera este campo magnético?',
      options: ['1.8 × 10⁻³ m', '2.5 × 10⁻² m', '3.4 × 10⁻⁴ m', '5.0 × 10⁻³ m'],
      correctIndex: 3,
    ),
    Question(
      question: 'Una espira circular de radio 8 cm produce una inducción magnética de 0.03 T en un medio cuya permeabilidad relativa es de 8,000. ¿Cuál es el valor de la corriente que circula en la espira?',
      options: ['0.13 A', '0.18 A', '0.20 A', '0.15 A'],
      correctIndex: 1,
    ),
    Question(
      question: 'Una bobina de 250 espiras y 3 cm de diámetro es excitada por una corriente de 400 mA. ¿Qué valor tiene el campo electromagnético producido en el aire?',
      options: ['0.0085 T', '0.0092 T', '0.0100 T', '0.0113 T'],
      correctIndex: 1,
    ),
    Question(
      question: 'El solenoide de un dispositivo tiene un núcleo ferromagnético con permeabilidad relativa de 12,000 y 600 espiras, excitado por una corriente de 18 A. ¿Cuál es el valor del campo electromagnético producido?',
      options: ['1.40 T', '1.60 T', '2.00 T', '1.26 T'],
      correctIndex: 0,
    ),
    Question(
      question: 'Un toroide tiene un núcleo de ferrita con una permeabilidad relativa de 2,000, tiene 6,000 vueltas, y es excitado por una corriente de 2 A, produciendo una densidad de campo magnético de 3 T. ¿Cuál es el valor del radio externo si el interno es de 60 cm?',
      options: ['1.20 m', '1.50 m', '2.00 m', '2.45 m'],
      correctIndex: 1,
    ),
    Question(
      question: 'Una bobina de 450 espiras y 12 cm de radio se mueve dentro de un campo magnético cuya densidad magnética varía de 2 T a 3 T en un tiempo de 150 ms. ¿Qué voltaje se genera en las terminales de la bobina?',
      options: ['33.75 V', '35.00 V', '37.25 V', '39.50 V'],
      correctIndex: 0,
    ),
    Question(
      question: 'Un imán de barra se mueve dentro de una bobina de 250 espiras, desde un flujo magnético de 800 miliweber en 3 segundos. ¿Qué valor tiene el flujo magnético final?',
      options: ['0.650 Wb', '0.680 Wb', '0.600 Wb', '0.615 Wb'],
      correctIndex: 3,
    ),
    Question(
      question: 'Una bobina de 80 espiras pasa entre los polos de un imán, donde el flujo magnético inicial es de 3 × 10⁻⁴ Wb y final de 7 × 10⁻⁴ Wb en 5 × 10⁻² s. ¿Cuál es la FEM inducida?',
      options: ['-0.22 V', '-0.45 V', '-0.55 V', '-0.60 V'],
      correctIndex: 1,
    ),
    Question(
      question: 'Una espira rectangular de 10 cm por 15 cm se encuentra en un campo magnético uniforme de 0.5 T, formando un ángulo de 30° con la normal a la espira. ¿Cuál es el flujo magnético que atraviesa la espira?',
      options: ['3.9 × 10⁻³ Wb', '6.5 × 10⁻³ Wb', '7.5 × 10⁻³ Wb', '5.2 × 10⁻³ Wb'],
      correctIndex: 0,
),
Question(
  question: 'Un solenoide de 400 espiras tiene una longitud de 0.5 m y es recorrido por una corriente de 2 A. ¿Cuál es la intensidad del campo magnético dentro del solenoide?',
  options: ['2.0 × 10⁻³ T', '5.0 × 10⁻³ T', '1.0 × 10⁻² T', '3.2 × 10⁻² T'],
  correctIndex: 3,
),
Question(
  question: 'Un cable recto muy largo transporta una corriente de 3 A. ¿Cuál es la intensidad del campo magnético a una distancia de 0.1 m del cable?',
  options: ['6.0 × 10⁻⁶ T', '1.2 × 10⁻⁵ T', '2.4 × 10⁻⁵ T', '3.0 × 10⁻⁶ T'],
  correctIndex: 2,
),
Question(
  question: 'Una bobina con 300 espiras y radio de 5 cm genera una fuerza electromotriz cuando el flujo magnético cambia de 0.1 Wb a 0.25 Wb en 0.02 s. ¿Cuál es el voltaje inducido?',
  options: ['2.25 V', '2.75 V', '3.00 V', '3.75 V'],
  correctIndex: 3,
),
Question(
  question: 'Una barra conductora de 0.5 m se mueve perpendicularmente a un campo magnético de 0.8 T con una velocidad de 2 m/s. ¿Cuál es la fem inducida en la barra?',
  options: ['0.8 V', '1.2 V', '0.5 V', '0.6 V'],
  correctIndex: 0,
),
Question(
  question: 'Una espira cuadrada de 20 cm de lado está en un campo magnético que forma un ángulo de 45° con la normal a la espira. Si la densidad del flujo magnético es 0.3 T, ¿cuál es el flujo magnético que atraviesa la espira?',
  options: ['8.5 × 10⁻³ Wb', '1.2 × 10⁻² Wb', '9.0 × 10⁻³ Wb', '7.1 × 10⁻³ Wb'],
  correctIndex: 2,
),
Question(
  question: 'Un toroide tiene 1000 espiras, un radio medio de 20 cm y una corriente de 5 A. ¿Cuál es la intensidad del campo magnético en el toroide?',
  options: ['1.25 T', '1.59 T', '1.0 T', '1.05 T'],
  correctIndex: 1,
),
Question(
  question: 'Una bobina de 150 espiras con radio 10 cm está dentro de un campo magnético cuyo flujo cambia linealmente de 0.2 Wb a 0.5 Wb en 0.1 s. ¿Cuál es la fem inducida?',
  options: ['0.45 V', '0.75 V', '0.50 V', '0.60 V'],
  correctIndex: 1,
),
Question(
  question: 'Una espira circular de radio 7 cm se encuentra en un campo magnético que varía con el tiempo. Si el flujo magnético cambia en 0.01 Wb en 0.05 s, ¿cuál es la fem inducida?',
  options: ['0.15 V', '0.20 V', '0.18 V', '0.22 V'],
  correctIndex: 0,
),
Question(
  question: 'Una barra conductora de 0.3 m se mueve a una velocidad de 3 m/s en un campo magnético de 0.4 T, perpendicular al campo. ¿Cuál es la fem inducida?',
  options: ['0.36 V', '0.40 V', '0.25 V', '0.30 V'],
  correctIndex: 0,
),
Question(
  question: 'Una espira rectangular de 25 cm por 10 cm está en un campo magnético de 0.75 T formando un ángulo de 60° con la normal a la espira. ¿Cuál es el flujo magnético que atraviesa la espira?',
  options: ['0.0144 Wb', '0.0162 Wb', '0.0182 Wb', '0.0125 Wb'],
  correctIndex: 0,
),
Question(
  question: 'Un solenoide de 500 espiras, longitud 0.8 m, tiene una corriente de 3 A. ¿Cuál es el campo magnético dentro del solenoide?',
  options: ['2.35 × 10⁻² T', '4.71 × 10⁻² T', '5.00 × 10⁻² T', '3.75 × 10⁻² T'],
  correctIndex: 1,
),
Question(
  question: 'Un conductor recto muy largo transporta una corriente de 5 A. ¿Cuál es el campo magnético a 0.05 m del conductor?',
  options: ['4.00 × 10⁻⁵ T', '2.00 × 10⁻⁵ T', '1.00 × 10⁻⁴ T', '3.00 × 10⁻⁵ T'],
  correctIndex: 0,
),
Question(
  question: 'Una bobina con 250 espiras y radio de 8 cm tiene un flujo magnético que cambia de 0.12 Wb a 0.24 Wb en 0.03 s. ¿Cuál es la fem inducida?',
  options: ['1.00 V', '1.50 V', '2.00 V', '2.50 V'],
  correctIndex: 2,
),
Question(
  question: 'Una barra conductora de 0.6 m se mueve perpendicularmente a un campo magnético de 0.5 T con una velocidad de 4 m/s. ¿Cuál es la fem inducida?',
  options: ['1.2 V', '1.5 V', '2.0 V', '1.8 V'],
  correctIndex: 2,
),
Question(
  question: 'Una espira circular de radio 15 cm está en un campo magnético que forma un ángulo de 30° con la normal. Si el campo es de 0.4 T, ¿cuál es el flujo magnético?',
  options: ['2.4 × 10⁻² Wb', '2.6 × 10⁻² Wb', '2.1 × 10⁻² Wb', '2.0 × 10⁻² Wb'],
  correctIndex: 0,
),
Question(
  question: 'Un toroide con 1500 espiras, radio medio de 25 cm y corriente de 4 A, produce un campo magnético de:',
  options: ['3.02 T', '2.90 T', '3.15 T', '2.75 T'],
  correctIndex: 0,
),
Question(
  question: 'Una bobina de 300 espiras y radio 6 cm se encuentra en un campo magnético cuyo flujo cambia de 0.15 Wb a 0.3 Wb en 0.05 s. ¿Cuál es la fem inducida?',
  options: ['0.90 V', '1.20 V', '1.50 V', '1.80 V'],
  correctIndex: 1,
),
Question(
  question: 'Una espira rectangular de 18 cm por 12 cm está en un campo magnético de 0.35 T con un ángulo de 45° respecto a la normal. ¿Cuál es el flujo magnético?',
  options: ['5.3 × 10⁻³ Wb', '4.8 × 10⁻³ Wb', '5.0 × 10⁻³ Wb', '5.5 × 10⁻³ Wb'],
  correctIndex: 2,
),
Question(
  question: 'Una barra conductora de 0.4 m se mueve a 5 m/s en un campo magnético de 0.3 T, perpendicular al campo. ¿Cuál es la fem inducida?',
  options: ['0.45 V', '0.60 V', '0.75 V', '0.50 V'],
  correctIndex: 0,
),

],

    'Física II': [
Question(
  question: '¿Cuál es la resistencia equivalente de dos resistencias de 6 Ω y 3 Ω conectadas en paralelo?',
  options: ['2 Ω', '4.5 Ω', '9 Ω', '1.5 Ω'],
  correctIndex: 1,  // Original: 0 (2 Ω)
),
Question(
  question: 'Un capacitor de 10 μF está conectado a una batería de 12 V. ¿Cuál es la carga almacenada en el capacitor?',
  options: ['1.2 × 10⁻⁴ C', '8.3 × 10⁻⁵ C', '1.0 × 10⁻³ C', '1.2 × 10⁻³ C'],
  correctIndex: 0,  // Original: 3 (1.2 × 10⁻⁴ C)
),
Question(
  question: '¿Qué energía se almacena en un capacitor de 5 μF cargado a 100 V?',
  options: ['0.025 J', '0.05 J', '0.10 J', '0.20 J'],
  correctIndex: 1,  // Original: 0 (0.025 J)
),
Question(
  question: 'Un inductor de 2 H está conectado a una fuente que varía la corriente a razón de 3 A/s. ¿Cuál es el voltaje inducido en el inductor?',
  options: ['6 V', '1.5 V', '3 V', '2 V'],
  correctIndex: 2,  // Original: 0 (6 V)
),
Question(
  question: '¿Cuál es la intensidad del campo eléctrico a una distancia de 0.5 m de una carga puntual de 2 μC en el vacío?',
  options: ['7.2 × 10⁴ N/C', '1.4 × 10⁵ N/C', '3.6 × 10⁴ N/C', '2.9 × 10⁴ N/C'],
  correctIndex: 2,  // Original: 0 (7.2 × 10⁴ N/C)
),
Question(
  question: 'Una resistencia de 10 Ω tiene una caída de voltaje de 5 V. ¿Cuál es la corriente que pasa por ella?',
  options: ['0.5 A', '2 A', '5 A', '0.2 A'],
  correctIndex: 1,  // Original: 0 (0.5 A)
),
Question(
  question: 'La ley de Faraday establece que la fem inducida en un circuito es proporcional a:',
  options: ['La resistencia del circuito', 'El cambio del flujo magnético con el tiempo', 'La corriente en el circuito', 'El voltaje aplicado'],
  correctIndex: 0,  // Original: 1 (Cambio flujo magnético)
),
Question(
  question: '¿Cuál es la inductancia de una bobina que produce un voltaje inducido de 10 V cuando la corriente cambia a razón de 5 A/s?',
  options: ['0.5 H', '2 H', '50 H', '0.2 H'],
  correctIndex: 0,  // Original: 1 (2 H)
),
Question(
  question: 'Dos capacitores de 4 μF y 6 μF están conectados en serie. ¿Cuál es la capacitancia equivalente?',
  options: ['2.4 μF', '10 μF', '1.5 μF', '5 μF'],
  correctIndex: 1,  // Original: 0 (2.4 μF)
),
Question(
  question: 'La fórmula para la energía almacenada en un inductor es:',
  options: ['(1/2) L I²', 'Q V', '(1/2) C V²', 'V I'],
  correctIndex: 2,  // Original: 0 ((1/2) L I²)
),
Question(
  question: '¿Cuál es la capacitancia equivalente de dos capacitores de 8 μF y 12 μF conectados en paralelo?',
  options: ['20 μF', '4.8 μF', '9.6 μF', '0.53 μF'],
  correctIndex: 1,  // Original: 0 (20 μF)
),
Question(
  question: 'Un resistor de 15 Ω tiene una corriente de 0.5 A. ¿Cuál es la potencia disipada en el resistor?',
  options: ['3.75 W', '7.5 W', '1.25 W', '15 W'],
  correctIndex: 2,  // Original: 0 (3.75 W)
),
Question(
  question: '¿Cuál es la carga almacenada en un capacitor de 20 μF conectado a una batería de 9 V?',
  options: ['1.8 × 10⁻⁴ C', '2.0 × 10⁻³ C', '1.8 × 10⁻³ C', '9.0 × 10⁻⁴ C'],
  correctIndex: 1,  // Original: 2 (1.8 × 10⁻⁴ C)
),
Question(
  question: 'Un inductor de 5 H tiene una corriente que aumenta a 4 A/s. ¿Cuál es la fem inducida?',
  options: ['20 V', '5 V', '9 V', '25 V'],
  correctIndex: 3,  // Original: 0 (20 V)
),
Question(
  question: '¿Cuál es la fórmula correcta para la ley de Ohm?',
  options: ['V = IR', 'I = VR', 'R = IV', 'V = IR²'],
  correctIndex: 1,  // Original: 0 (V = IR)
),
Question(
  question: '¿Cuál es la unidad de la inductancia?',
  options: ['Henry', 'Faradio', 'Ohm', 'Voltio'],
  correctIndex: 3,  // Original: 0 (Henry)
),
Question(
  question: 'Una carga puntual de 5 μC está a 0.2 m de un punto en el espacio. ¿Cuál es la intensidad del campo eléctrico en ese punto? (k = 9 × 10⁹ N·m²/C²)',
  options: ['1.13 × 10⁶ N/C', '2.25 × 10⁵ N/C', '3.75 × 10⁵ N/C', '5.00 × 10⁵ N/C'],
  correctIndex: 3,  // Original: 0 (1.13 × 10⁶ N/C)
),
Question(
  question: 'Una resistencia de 20 Ω está conectada a una fuente de 24 V. ¿Cuál es la corriente que circula por ella?',
  options: ['1.5 A', '0.8 A', '2.4 A', '1.2 A'],
  correctIndex: 0,  // Original: 3 (1.2 A)
),
Question(
  question: '¿Cuál es la energía almacenada en un capacitor de 15 μF cargado a 20 V?',
  options: ['3.0 × 10⁻³ J', '6.0 × 10⁻³ J', '1.5 × 10⁻³ J', '4.5 × 10⁻³ J'],
  correctIndex: 3,  // Original: 0 (3.0 × 10⁻³ J)
),
Question(
  question: 'Un circuito LC tiene un capacitor de 10 μF y una inductancia de 2 H. ¿Cuál es la frecuencia angular de oscilación?',
  options: ['707 rad/s', '500 rad/s', '223 rad/s', '1000 rad/s'],
  correctIndex: 1,  // Original: 0 (707 rad/s)
),
Question(
  question: 'La corriente alterna en un circuito RLC tiene un valor máximo de 3 A y una frecuencia de 60 Hz. ¿Cuál es el valor eficaz de la corriente?',
  options: ['2.12 A', '3 A', '4.24 A', '1.5 A'],
  correctIndex: 3,  // Original: 0 (2.12 A)
),
Question(
  question: '¿Qué sucede con la reactancia inductiva al aumentar la frecuencia en un circuito RLC?',
  options: ['Aumenta', 'Disminuye', 'Permanece igual', 'Se anula'],
  correctIndex: 2,  // Original: 0 (Aumenta)
),
Question(
  question: 'Un capacitor de 25 μF tiene una diferencia de potencial de 10 V. ¿Cuál es la carga almacenada?',
  options: ['2.5 × 10⁻⁴ C', '4.0 × 10⁻⁴ C', '2.0 × 10⁻⁴ C', '1.5 × 10⁻⁴ C'],
  correctIndex: 3,  // Original: 0 (2.5 × 10⁻⁴ C)
),
Question(
  question: '¿Cuál es el efecto de un núcleo ferromagnético en una inductancia?',
  options: ['Aumenta la inductancia', 'Disminuye la inductancia', 'No cambia la inductancia', 'Elimina la inductancia'],
  correctIndex: 1,  // Original: 0 (Aumenta)
),
Question(
  question: 'Una bobina de 100 espiras y radio 0.1 m está en un campo magnético que cambia de 0.5 T a 0.1 T en 0.02 s. ¿Cuál es la fem inducida?',
  options: ['0.8 V', '1.6 V', '0.5 V', '0.9 V'],
  correctIndex: 2,  // Original: 0 (0.8 V)
),
Question(
  question: '¿Qué ley explica la relación entre campo eléctrico y campo magnético variables con el tiempo?',
  options: ['Ley de Faraday', 'Ley de Gauss', 'Ley de Ampère-Maxwell', 'Ley de Coulomb'],
  correctIndex: 0,  // Original: 2 (Ampère-Maxwell)
),
Question(
  question: 'En un circuito RLC en resonancia, ¿qué sucede con la impedancia?',
  options: ['Es mínima', 'Es máxima', 'Es infinita', 'Es cero'],
  correctIndex: 1,  // Original: 0 (Es mínima)
),
Question(
  question: '¿Cuál es la fórmula para la potencia en corriente alterna considerando resistencia y reactancia?',
  options: ['P = VI cos(θ)', 'P = VI sin(θ)', 'P = VI', 'P = V/R'],
  correctIndex: 2,  // Original: 0 (P = VI cos(θ))
),
Question(
  question: 'Un capacitor de 50 μF está conectado a una fuente de 120 V a 60 Hz. ¿Cuál es su reactancia capacitiva?',
  options: ['53 Ω', '26.5 Ω', '75 Ω', '100 Ω'],
  correctIndex: 3,  // Original: 0 (53 Ω)
),
Question(
  question: '¿Qué propiedad del inductor hace que se oponga a cambios en la corriente?',
  options: ['Inductancia', 'Capacitancia', 'Resistencia', 'Conductancia'],
  correctIndex: 2,  // Original: 0 (Inductancia)
),
Question(
  question: '¿Cómo cambia la energía almacenada en un inductor si se duplica la corriente?',
  options: ['Se cuadruplica', 'Se duplica', 'Permanece igual', 'Se reduce a la mitad'],
  correctIndex: 1,  // Original: 0 (Se cuadruplica)
),

],

    'Física III': [
Question(
  question: '¿Cuál es la velocidad de una onda si su frecuencia es 500 Hz y su longitud de onda es 0.6 m?',
  options: ['300 m/s', '833 m/s', '200 m/s', '500 m/s'],
  correctIndex: 1,
),
Question(
  question: 'La ley de Stefan-Boltzmann relaciona la potencia radiada con:',
  options: ['La temperatura a la cuarta potencia', 'La temperatura lineal', 'El volumen del cuerpo', 'La masa del cuerpo'],
  correctIndex: 1,
),
Question(
  question: '¿Qué fenómeno explica la dispersión de la luz blanca en un prisma?',
  options: ['Refracción', 'Difracción', 'Interferencia', 'Polarización'],
  correctIndex: 1,
),
Question(
  question: 'El principio de incertidumbre de Heisenberg establece que:',
  options: ['No se pueden conocer simultáneamente posición y momento con precisión absoluta', 'La energía se conserva siempre', 'Los electrones giran en órbitas fijas', 'La velocidad de la luz es variable'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es la energía de un fotón con frecuencia 6 × 10¹⁴ Hz? (h = 6.63 × 10⁻³⁴ J·s)',
  options: ['3.98 × 10⁻¹⁹ J', '4.00 × 10⁻¹⁹ J', '5.00 × 10⁻¹⁹ J', '2.98 × 10⁻¹⁹ J'],
  correctIndex: 2,
),
Question(
  question: 'En un espejo plano, la imagen formada es:',
  options: ['Virtual e invertida', 'Real y derecha', 'Virtual y derecha', 'Real e invertida'],
  correctIndex: 1,
),
Question(
  question: 'La fórmula para el calor específico es:',
  options: ['Q = mcΔT', 'Q = m/v', 'Q = mL', 'Q = VIt'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es la longitud de onda de un electrón cuya masa es 9.11 × 10⁻³¹ kg y velocidad 2 × 10⁶ m/s? (h=6.63 × 10⁻³⁴ Js)',
  options: ['3.63 × 10⁻¹⁰ m', '2.00 × 10⁻¹⁰ m', '5.00 × 10⁻¹¹ m', '1.82 × 10⁻¹⁰ m'],
  correctIndex: 1,
),
Question(
  question: '¿Qué ley describe la relación entre presión, volumen y temperatura de un gas ideal?',
  options: ['Ley de los gases ideales', 'Ley de Boyle', 'Ley de Charles', 'Ley de Gay-Lussac'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es la frecuencia de una onda con periodo 0.01 s?',
  options: ['10 Hz', '100 Hz', '0.1 Hz', '1 Hz'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es el índice de refracción si la velocidad de la luz en un medio es 2 × 10⁸ m/s?',
  options: ['1.5', '1.3', '2.0', '0.67'],
  correctIndex: 1,
),
Question(
  question: 'En el efecto fotoeléctrico, ¿qué propiedad de la luz determina la energía máxima de los electrones emitidos?',
  options: ['Frecuencia', 'Intensidad', 'Longitud de onda', 'Amplitud'],
  correctIndex: 1,
),
Question(
  question: '¿Qué cantidad física se conserva en una colisión perfectamente elástica?',
  options: ['Energía cinética', 'Cantidad de movimiento', 'Impulso', 'Velocidad'],
  correctIndex: 1,
),
Question(
  question: '¿Qué tipo de interferencia se produce cuando dos ondas se suman con fase opuesta?',
  options: ['Interferencia destructiva', 'Interferencia constructiva', 'Difracción', 'Reflexión'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es el valor de la constante de Planck (h)?',
  options: ['6.63 × 10⁻³⁴ J·s', '9.11 × 10⁻³¹ kg', '1.60 × 10⁻¹⁹ C', '3.00 × 10⁸ m/s'],
  correctIndex: 1,
),
Question(
  question: '¿Qué ocurre con la energía interna de un gas ideal cuando su temperatura aumenta a volumen constante?',
  options: ['Aumenta', 'Disminuye', 'Permanece constante', 'Se anula'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es la ecuación para la ley de Boyle?',
  options: ['P₁V₁ = P₂V₂', 'V = kT', 'P = kT', 'PV = nRT'],
  correctIndex: 1,
),
Question(
  question: '¿Qué ocurre con la longitud de onda cuando la frecuencia de una onda aumenta, manteniendo la velocidad constante?',
  options: ['Disminuye', 'Aumenta', 'Permanece igual', 'Se anula'],
  correctIndex: 1,
),
Question(
  question: '¿Qué representa la constante de Boltzmann?',
  options: ['Relación entre energía térmica y temperatura', 'Constante de gravedad', 'Constante de Planck', 'Constante eléctrica'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es el principio de superposición?',
  options: ['La suma de dos o más ondas es la suma algebraica de sus desplazamientos', 'Las ondas no se pueden sumar', 'La energía se conserva', 'Las ondas se cancelan siempre'],
  correctIndex: 1,
),
Question(
  question: '¿Qué sucede con la energía de un fotón cuando su frecuencia se duplica?',
  options: ['Se duplica', 'Se reduce a la mitad', 'Permanece igual', 'Se cuadruplica'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es el rango típico de frecuencias para la luz visible?',
  options: ['4 × 10¹⁴ Hz a 7.5 × 10¹⁴ Hz', '1 × 10¹² Hz a 3 × 10¹² Hz', '1 × 10⁸ Hz a 3 × 10⁸ Hz', '7 × 10¹⁴ Hz a 1 × 10¹⁵ Hz'],
  correctIndex: 1,
),
Question(
  question: '¿Qué es un condensado de Bose-Einstein?',
  options: ['Estado de la materia a temperaturas cercanas al cero absoluto', 'Gas ideal', 'Plasma', 'Sólido cristalino'],
  correctIndex: 1,
),
Question(
  question: '¿Qué característica define a un material superconductor?',
  options: ['Resistencia eléctrica nula', 'Alta resistencia eléctrica', 'Conductividad térmica baja', 'Alta densidad'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es la fórmula de la ley de Wien para la radiación de cuerpo negro?',
  options: ['λ_max T = constante', 'P = σT⁴', 'E = hf', 'Q = mcΔT'],
  correctIndex: 1,
),
Question(
  question: '¿Qué ocurre con el tiempo medido en un objeto que se mueve a velocidades cercanas a la luz, según la relatividad especial?',
  options: ['Se dilata', 'Se contrae', 'Permanece igual', 'Se anula'],
  correctIndex: 1,
),
Question(
  question: '¿Qué describe el modelo de Bohr del átomo?',
  options: ['Electrones en órbitas cuantizadas', 'Electrones fijos', 'Núcleo sin carga', 'Protones en órbitas'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es la relación entre energía y masa según Einstein?',
  options: ['E = mc²', 'E = mv²', 'E = mgh', 'E = 1/2 mv²'],
  correctIndex: 1,
),
Question(
  question: '¿Qué propiedad tiene un material dieléctrico?',
  options: ['No conduce electricidad', 'Conduce electricidad', 'Es un conductor perfecto', 'Tiene resistencia nula'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es la fórmula para la velocidad de una onda en una cuerda tensada?',
  options: ['v = √(T/μ)', 'v = fλ', 'v = λ/f', 'v = Tμ'],
  correctIndex: 1,
),
Question(
  question: '¿Qué es la difracción?',
  options: ['Desviación de una onda al pasar por una rendija o alrededor de un obstáculo', 'Reflexión de una onda', 'Interferencia constructiva', 'Absorción de una onda'],
  correctIndex: 1,
),

],

    'Física IV': [
  Question(
  question: '¿Cuál es la partícula responsable de la interacción electromagnética?',
  options: ['Fotón', 'Neutrón', 'Proton', 'Electrón'],
  correctIndex: 2,
),
Question(
  question: '¿Qué tipo de radiación es emitida en la desintegración beta?',
  options: ['Electrones o positrones', 'Neutrones', 'Fotones gamma', 'Protones'],
  correctIndex: 1,
),
Question(
  question: 'La ley de decaimiento radiactivo se expresa como:',
  options: ['N = N₀ e^(-λt)', 'E = mc²', 'F = ma', 'V = IR'],
  correctIndex: 3,
),
Question(
  question: '¿Qué unidad se usa para medir la actividad radiactiva?',
  options: ['Becquerel', 'Sievert', 'Gray', 'Curie'],
  correctIndex: 2,
),
Question(
  question: '¿Cuál es el proceso por el que un núcleo inestable emite una partícula alfa?',
  options: ['Emisión de He-4', 'Emisión de un electrón', 'Fisión nuclear', 'Fusión nuclear'],
  correctIndex: 1,
),
Question(
  question: '¿Qué describe la ley de Planck?',
  options: ['Distribución de energía de un cuerpo negro', 'Ley de gravitación universal', 'Ley de Coulomb', 'Ley de Boyle'],
  correctIndex: 3,
),
Question(
  question: '¿Qué es un bosón?',
  options: ['Partícula con spin entero', 'Partícula con spin medio entero', 'Partícula sin masa', 'Partícula con carga positiva'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es la partícula mediadora de la fuerza nuclear fuerte?',
  options: ['Gluón', 'Fotón', 'W bosón', 'Neutrino'],
  correctIndex: 3,
),
Question(
  question: '¿Cuál es el principio básico de la física estadística?',
  options: ['Estudio del comportamiento colectivo de partículas', 'Movimiento individual de partículas', 'Electromagnetismo', 'Mecánica clásica'],
  correctIndex: 2,
),
Question(
  question: '¿Qué propiedad caracteriza a un superfluido?',
  options: ['Fluye sin viscosidad', 'Conductividad eléctrica', 'Alta densidad', 'Alto punto de fusión'],
  correctIndex: 3,
),
Question(
  question: '¿Qué es la constante de Avogadro?',
  options: ['Número de partículas en un mol', 'Constante gravitacional', 'Constante de Planck', 'Carga elemental'],
  correctIndex: 1,
),
Question(
  question: '¿Qué describe la ecuación de Schrödinger?',
  options: ['Comportamiento cuántico de partículas', 'Ley de Newton', 'Ley de Faraday', 'Energía cinética'],
  correctIndex: 2,
),
Question(
  question: '¿Cuál es la partícula que tiene carga positiva y se encuentra en el núcleo?',
  options: ['Protón', 'Neutrón', 'Electrón', 'Positrón'],
  correctIndex: 3,
),
Question(
  question: '¿Qué ocurre durante la fusión nuclear?',
  options: ['Dos núcleos ligeros se combinan para formar uno más pesado', 'Un núcleo se divide en dos', 'Emisión de partículas alfa', 'Absorción de neutrones'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es la partícula mediadora de la fuerza débil?',
  options: ['Bosones W y Z', 'Fotón', 'Gluón', 'Gravitón'],
  correctIndex: 2,
),
Question(
  question: '¿Qué representa la constante de Boltzmann en física estadística?',
  options: ['Relación entre temperatura y energía', 'Constante eléctrica', 'Constante gravitacional', 'Constante de Planck'],
  correctIndex: 3,
),
Question(
  question: '¿Qué fenómeno físico explica la superconductividad?',
  options: ['Resistencia eléctrica nula a bajas temperaturas', 'Efecto fotoeléctrico', 'Difracción de rayos X', 'Polarización de la luz'],
  correctIndex: 1,
),
Question(
  question: '¿Qué es un fermión?',
  options: ['Partícula con spin semientero', 'Partícula con spin entero', 'Partícula sin masa', 'Partícula con carga neutra'],
  correctIndex: 2,
),
Question(
  question: '¿Cuál es la partícula fundamental asociada a la gravedad en teorías de gravedad cuántica?',
  options: ['Gravitón', 'Fotón', 'Bosón Z', 'Neutrino'],
  correctIndex: 1,
),
Question(
  question: '¿Qué es la radiación de cuerpo negro?',
  options: ['Radiación emitida por un objeto que absorbe toda la radiación incidente', 'Radiación electromagnética dispersada', 'Radiación emitida por partículas alfa', 'Radiación térmica de electrones libres'],
  correctIndex: 3,
),
Question(
  question: '¿Qué describe la función de onda en mecánica cuántica?',
  options: ['Probabilidad de encontrar una partícula en una posición', 'Trayectoria exacta de una partícula', 'Velocidad de la partícula', 'Energía total de un sistema'],
  correctIndex: 2,
),
Question(
  question: '¿Cuál es la ley que describe el comportamiento de los gases ideales?',
  options: ['PV = nRT', 'F = ma', 'E = mc²', 'Q = mcΔT'],
  correctIndex: 1,
),
Question(
  question: '¿Qué es la entropía en termodinámica?',
  options: ['Medida del desorden o aleatoriedad en un sistema', 'Cantidad de energía', 'Temperatura absoluta', 'Capacidad calorífica'],
  correctIndex: 3,
),
Question(
  question: '¿Qué es la desintegración gamma?',
  options: ['Emisión de rayos gamma desde un núcleo excitado', 'Emisión de electrones', 'Fusión de núcleos', 'Captura de neutrones'],
  correctIndex: 2,
),
Question(
  question: '¿Cuál es la función principal del acelerador de partículas?',
  options: ['Incrementar la energía de partículas para estudiar colisiones', 'Medir la masa de partículas', 'Crear campos magnéticos', 'Generar rayos X'],
  correctIndex: 1,
),
Question(
  question: '¿Cuál es la carga elemental en Coulombs?',
  options: ['1.6 × 10⁻¹⁹ C', '9.11 × 10⁻³¹ C', '6.63 × 10⁻³⁴ C', '3.0 × 10⁸ C'],
  correctIndex: 3,
),
Question(
  question: '¿Qué es un isotopo?',
  options: ['Átomos del mismo elemento con diferente número de neutrones', 'Átomos de diferentes elementos', 'Partículas subatómicas', 'Moléculas con la misma fórmula química'],
  correctIndex: 2,
),
Question(
  question: '¿Qué es la masa crítica en física nuclear?',
  options: ['Cantidad mínima de material fisible para mantener una reacción en cadena', 'Masa total del núcleo', 'Masa de electrones en un átomo', 'Masa de un neutrón'],
  correctIndex: 1,
),
Question(
  question: '¿Qué representa la constante de Planck reducida (ħ)?',
  options: ['h/2π', 'h', '2πh', 'h²'],
  correctIndex: 2,
),
Question(
  question: '¿Qué es el efecto Doppler en ondas electromagnéticas?',
  options: ['Cambio en la frecuencia percibida debido al movimiento relativo', 'Reflexión de ondas', 'Difracción de ondas', 'Interferencia de ondas'],
  correctIndex: 3,
),
Question(
  question: '¿Cuál es el principio de exclusión de Pauli?',
  options: ['No dos fermiones pueden ocupar el mismo estado cuántico simultáneamente', 'Dos bosones pueden ocupar el mismo estado', 'Los protones son neutrales', 'Los electrones giran en órbitas fijas'],
  correctIndex: 1,
),
Question(
  question: '¿Qué es el spin en partículas subatómicas?',
  options: ['Momento angular intrínseco', 'Carga eléctrica', 'Masa', 'Velocidad'],
  correctIndex: 3,
),

],

  };

  static List<Question> getRandomQuestions(String semester, int count) {
    final allQuestions = List<Question>.from(_semesterQuestions[semester]!);
    allQuestions.shuffle();
    return allQuestions.sublist(0, min(count, allQuestions.length));
  }

  static void addQuestionToSemester(String semester, Question question) {
    if (_semesterQuestions.containsKey(semester)) {
      _semesterQuestions[semester]!.add(question);
    }
  }
}

class ExamenesPage extends StatelessWidget {
  const ExamenesPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                            'Exámenes de Física',
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
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildModernCard(
                        context,
                        'Física I',
                        Icons.speed,
                        [Colors.blue.shade400, Colors.blue.shade600],
                        () => Navigator.push(context, _createRoute(Fisica1ExamPage())),
                      ),
                      _buildModernCard(
                        context,
                        'Física II',
                        Icons.scatter_plot,
                        [Colors.green.shade400, Colors.green.shade600],
                        () => Navigator.push(context, _createRoute(Fisica2ExamPage())),
                      ),
                      _buildModernCard(
                        context,
                        'Física III',
                        Icons.electric_bolt,
                        [Colors.orange.shade400, Colors.orange.shade600],
                        () => Navigator.push(context, _createRoute(Fisica3ExamPage())),
                      ),
                      _buildModernCard(
                        context,
                        'Física IV',
                        Icons.waves,
                        [Colors.purple.shade400, Colors.purple.shade600],
                        () => Navigator.push(context, _createRoute(Fisica4ExamPage())),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernCard(BuildContext context, String title, IconData icon, List<Color> gradientColors, VoidCallback onTap) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (title.hashCode % 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[1].withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              icon,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 2,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

class ExamPage extends StatefulWidget {
  final String semester;

  const ExamPage({super.key, required this.semester});

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with TickerProviderStateMixin {
  late List<Question> _questions;
  int _currentQuestionIndex = 0;
  List<int?> _answers = [];
  int _score = 0;
  bool _submitted = false;
  late AnimationController _progressController;
  late AnimationController _slideController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _questions = ExamManager.getRandomQuestions(widget.semester, 10);
    _answers = List.filled(_questions.length, null);
    
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _slideController.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateProgress();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    double progress = (_currentQuestionIndex + 1) / _questions.length;
    _progressController.animateTo(progress);
  }

  void _nextQuestion() {
    if (_answers[_currentQuestionIndex] == null) {
      _showSnackbar('Por favor, selecciona una respuesta antes de continuar', Colors.orange);
      return;
    }
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
      _slideController.reset();
      _slideController.forward();
      _updateProgress();
    }
  }

  void _submitExam() {
    if (_answers[_currentQuestionIndex] == null) {
      _showSnackbar('Por favor, selecciona una respuesta antes de enviar', Colors.orange);
      return;
    }
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctIndex) score++;
    }
    setState(() {
      _score = score;
      _submitted = true;
    });
    _progressController.animateTo(1.0);
  }

  void _restartExam() {
    setState(() {
      _questions = ExamManager.getRandomQuestions(widget.semester, 10);
      _currentQuestionIndex = 0;
      _answers = List.filled(_questions.length, null);
      _score = 0;
      _submitted = false;
    });
    _progressController.reset();
    _slideController.reset();
    _slideController.forward();
    _updateProgress();
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return _buildResultsPage();
    }

    final question = _questions[_currentQuestionIndex];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade700, Colors.purple.shade400, Colors.white],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
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
                        Expanded(
                          child: Text(
                            'Examen de ${widget.semester}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '${_currentQuestionIndex + 1}/${_questions.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: _progressAnimation.value,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.cyan, Colors.blue],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.purple.shade50, Colors.purple.shade100],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.purple.shade200),
                            ),
                            child: Text(
                              question.question,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: ListView.builder(
                              itemCount: question.options.length,
                              itemBuilder: (context, index) {
                                bool isSelected = _answers[_currentQuestionIndex] == index;
                                return TweenAnimationBuilder<double>(
                                  duration: Duration(milliseconds: 200 + (index * 100)),
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  builder: (context, value, child) {
                                    return Transform.translate(
                                      offset: Offset(50 * (1 - value), 0),
                                      child: Opacity(
                                        opacity: value,
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 12),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _answers[_currentQuestionIndex] = index;
                                                });
                                              },
                                              borderRadius: BorderRadius.circular(15),
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 200),
                                                padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? Colors.purple.shade100
                                                      : Colors.grey.shade50,
                                                  borderRadius: BorderRadius.circular(15),
                                                  border: Border.all(
                                                    color: isSelected
                                                        ? Colors.purple.shade400
                                                        : Colors.grey.shade300,
                                                    width: isSelected ? 2 : 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    AnimatedContainer(
                                                      duration: const Duration(milliseconds: 200),
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: isSelected
                                                            ? Colors.purple.shade400
                                                            : Colors.transparent,
                                                        border: Border.all(
                                                          color: isSelected
                                                              ? Colors.purple.shade400
                                                              : Colors.grey.shade400,
                                                          width: 2,
                                                        ),
                                                      ),
                                                      child: isSelected
                                                          ? const Icon(
                                                        Icons.check,
                                                        size: 16,
                                                        color: Colors.white,
                                                      )
                                                          : null,
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Text(
                                                        question.options[index],
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: isSelected
                                                              ? FontWeight.w600
                                                              : FontWeight.normal,
                                                          color: isSelected
                                                              ? Colors.purple.shade700
                                                              : Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _currentQuestionIndex == _questions.length - 1
                                  ? _submitExam
                                  : _nextQuestion,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade600,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 3,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _currentQuestionIndex == _questions.length - 1
                                        ? 'Enviar Examen'
                                        : 'Siguiente Pregunta',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    _currentQuestionIndex == _questions.length - 1
                                        ? Icons.send
                                        : Icons.arrow_forward,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsPage() {
    double percentage = (_score / _questions.length) * 100;
    Color scoreColor = percentage >= 70 ? Colors.green : percentage >= 50 ? Colors.orange : Colors.red;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade700, Colors.purple.shade400],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
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
                            'Resultados del Examen',
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
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            percentage >= 70 ? Icons.emoji_events : percentage >= 50 ? Icons.thumb_up : Icons.refresh,
                            size: 48,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '$_score / ${_questions.length}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _questions.length,
                          itemBuilder: (context, index) {
                            final question = _questions[index];
                            final userAnswer = _answers[index];
                            final isCorrect = userAnswer == question.correctIndex;

                            return TweenAnimationBuilder<double>(
                              duration: Duration(milliseconds: 300 + (index * 100)),
                              tween: Tween(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(0, 20 * (1 - value)),
                                  child: Opacity(
                                    opacity: value,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: isCorrect
                                                  ? [Colors.green.shade50, Colors.green.shade100]
                                                  : [Colors.red.shade50, Colors.red.shade100],
                                            ),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: isCorrect ? Colors.green : Colors.red,
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Text(
                                                        '${index + 1}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Text(
                                                        'Pregunta ${index + 1}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    Icon(
                                                      isCorrect ? Icons.check_circle : Icons.cancel,
                                                      color: isCorrect ? Colors.green : Colors.red,
                                                      size: 28,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  question.question,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    height: 1.3,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 12),
                                                if (userAnswer != null) ...[
                                                  Container(
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: isCorrect
                                                          ? Colors.green.withOpacity(0.2)
                                                          : Colors.red.withOpacity(0.2),
                                                      borderRadius: BorderRadius.circular(8),
                                                      border: Border.all(
                                                        color: isCorrect ? Colors.green : Colors.red,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Tu respuesta: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.w500,
                                                            color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            question.options[userAnswer],
                                                            style: TextStyle(
                                                              color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (!isCorrect) ...[
                                                    const SizedBox(height: 8),
                                                    Container(
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green.withOpacity(0.2),
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(
                                                          color: Colors.green,
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          const Text(
                                                            'Respuesta correcta: ',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              color: Colors.green,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              question.options[question.correctIndex],
                                                              style: const TextStyle(
                                                                color: Colors.green,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _restartExam,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.refresh),
                                    SizedBox(width: 8),
                                    Text(
                                      'Reintentar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.home),
                                    SizedBox(width: 8),
                                    Text(
                                      'Volver',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Fisica1ExamPage extends StatelessWidget {
  const Fisica1ExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamPage(semester: 'Física I');
  }
}

class Fisica2ExamPage extends StatelessWidget {
  const Fisica2ExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamPage(semester: 'Física II');
  }
}

class Fisica3ExamPage extends StatelessWidget {
  const Fisica3ExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamPage(semester: 'Física III');
  }
}

class Fisica4ExamPage extends StatelessWidget {
  const Fisica4ExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ExamPage(semester: 'Física IV');
  }
}
