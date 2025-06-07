import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EjerciciosPage(),
    );
  }
}

class EjerciciosPage extends StatelessWidget {
  const EjerciciosPage({super.key});

  void _mostrarDetalle(BuildContext context, String titulo) {
    if (titulo == 'FÍSICA I' || titulo == 'FÍSICA II' || titulo == 'FÍSICA III' || titulo == 'FÍSICA IV') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubtemasPage(titulo: titulo),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contenido no disponible para $titulo')),
      );
    }
  }

  Widget _crearCaja(BuildContext context, String titulo) {
    return InkWell(
      onTap: () => _mostrarDetalle(context, titulo),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            titulo,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apartado de Ejercicios')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _crearCaja(context, 'FÍSICA I'),
            _crearCaja(context, 'FÍSICA II'),
            _crearCaja(context, 'FÍSICA III'),
            _crearCaja(context, 'FÍSICA IV'),
          ],
        ),
      ),
    );
  }
}

class SubtemasPage extends StatelessWidget {
  final String titulo;

  const SubtemasPage({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> subtemasPorMateria = {
      'FÍSICA I': [
        'Primera Condición de Equilibrio (Equilibrio Traslacional)',
        'Segunda Condición de Equilibrio (Equilibrio Rotacional)',
        'Centroide',
        'Movimiento Rectilíneo Uniforme (MRU)',
        'Movimiento Rectilíneo Uniformemente Variado (MRUV)',
        'Caída Libre',
        'Tiro Vertical',
        'Tiro Horizontal',
        'Movimiento Circular Uniforme (MCU) y Movimiento Circular Uniformemente Variado (MCUV)',
      ],
      'FÍSICA II': [
        'Leyes de Newton',
        'Ley de Gravitación Universal',
        'Leyes de Kepler',
        'Trabajo Mecánico',
        'Energía Mecánica',
        'Cantidad de Movimiento e Impulso',
      ],
      'FÍSICA III': [
        'Ley de Coulomb',
        'Ley de Gauss',
        'Potencial Eléctrico',
        'Resistividad, Resistencia Eléctrica y Ley de Ohm',
        'Potencia Eléctrica y Pérdida de Calor',
        'Resistencia con Temperatura',
        'Leyes de Kirchhoff',
      ],
      'FÍSICA IV': [
        'Flujo Magnético y Densidad de Flujo Magnético',
        'Campo Magnético',
        'Ley de Faraday y FEM Inducida',
        'Instrumentos de Medición: Amperímetro y Voltímetro',
        'Momento Magnético y Torque Magnético',
        'Ley de Lorentz',
      ],
    };
final subtemas = subtemasPorMateria[titulo] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('$titulo - Temas')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: subtemas.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(subtemas[index]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EjerciciosPorTemaPage(subtema: subtemas[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
class EjerciciosPorTemaPage extends StatelessWidget {
  final String subtema;

  const EjerciciosPorTemaPage({super.key, required this.subtema});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> ejercicios = {
  'Primera Condición de Equilibrio (Equilibrio Traslacional)': [
    {
      'ejercicio': 'Un semáforo de 15 kg está suspendido por dos cables que forman ángulos de 30° y 45° con la horizontal. ¿Cuáles son las tensiones en los cables?',
      'resultado': 'T1 = 402.02 N y T2 = 492.37 N',
    },
    {
      'ejercicio': 'Una caja de 80 kg está en reposo sobre un plano inclinado de 25° con la horizontal. Si el coeficiente de fricción estática es de 0.4, ¿cuál es la fuerza de fricción que actúa sobre la caja?',
      'resultado': '284.51 N',
    },
    {
      'ejercicio': 'Una persona de 60 kg se cuelga de una barra horizontal. Si los brazos forman un ángulo de 60° con la vertical, ¿cuál es la tensión en cada brazo?',
      'resultado': '588.6 N',
    },
    {
      'ejercicio': 'Un objeto de 5 kg está colgando del techo por una cuerda. Si se aplica una fuerza horizontal de 30 N, ¿cuál es la tensión en la cuerda y el ángulo que forma con la vertical cuando está en equilibrio?',
      'resultado': 'Tensión ≈ 57.5 N y Ángulo ≈ 31.45°',
    },
  ],
  'Segunda Condición de Equilibrio (Equilibrio Rotacional)': [
    {
      'ejercicio': 'Una viga uniforme de 5 m de longitud y 100 kg de masa está pivoteada en un extremo. ¿Qué fuerza vertical hacia arriba se debe aplicar en el otro extremo para mantenerla en equilibrio horizontal?',
      'resultado': '490.5 N',
    },
    {
      'ejercicio': 'Una tabla de 6 m y 40 kg está sostenida por dos soportes, uno en el extremo izquierdo y otro a 1.5 m del extremo derecho. Una persona de 70 kg se para a 1 m del extremo izquierdo. ¿Qué fuerzas ejercen los soportes?',
      'resultado': 'Izquierdo: 664.9 N, Derecho: 414.2 N',
    },
    {
      'ejercicio': 'Una escalera de 8 m y 20 kg se apoya contra una pared sin fricción, formando un ángulo de 60° con el suelo. Si μ = 0.5, ¿qué tan lejos puede subir una persona de 70 kg antes de que la escalera resbale?',
      'resultado': '9.14 m',
    },
  ],
'Centroide': [
    {
      'ejercicio': 'Determina las coordenadas del centroide de una lámina en forma de L, formada por un rectángulo de 6×2 cm y otro de 2×4 cm.',
      'resultado': '(3.8 cm, 2.2 cm)',
    },
    {
      'ejercicio': 'Calcula el centroide de tres masas: m1=2 kg en (1,0), m2=3 kg en (3,0), m3=1 kg en (2,4).',
      'resultado': '(2.17 m, 0.67 m)',
    },
    {
      'ejercicio': 'Una placa de 10×5 cm tiene un agujero circular de radio 2 cm centrado en (2.5, 2.5). ¿Dónde está el nuevo centroide?',
      'resultado': '(5.84 cm, 2.5 cm)',
    },
  ],
  'Movimiento Rectilíneo Uniforme (MRU)': [
    {
      'ejercicio': 'Un automóvil viaja a una velocidad constante de 90 km/h. ¿Qué distancia recorre en 2.5 horas?',
      'resultado': '225 km',
    },
    {
      'ejercicio': 'Un corredor completa una carrera de 100 m en 10.5 s. ¿Cuál fue su velocidad promedio?',
      'resultado': '9.52 m/s',
    },
    {
      'ejercicio': 'Dos trenes parten desde estaciones separadas 300 km. Uno viaja a 70 km/h, el otro a 80 km/h. ¿Cuándo se cruzan?',
      'resultado': '2 horas',
    },
  ],
  'Movimiento Rectilíneo Uniformemente Variado (MRUV)': [
    {
      'ejercicio': 'Un objeto parte del reposo y acelera a 4 m/s² durante 6 s. ¿Qué distancia recorre?',
      'resultado': '72 m',
    },
    {
      'ejercicio': 'Un coche viaja a 20 m/s y frena hasta detenerse en 4 s. ¿Cuál es la aceleración y distancia de frenado?',
      'resultado': 'a = -5 m/s², d = 40 m',
    },
    {
      'ejercicio': 'Un avión parte del reposo y necesita alcanzar 80 m/s en 1200 m de pista. ¿Qué aceleración requiere?',
      'resultado': '2.67 m/s²',
    },
  ],
'Caída Libre': [
    {
      'ejercicio': 'Se deja caer una piedra y tarda 3 s en llegar al suelo. ¿Cuál es la altura del edificio?',
      'resultado': '44.1 m',
    },
    {
      'ejercicio': 'Un objeto cae desde 70 m. ¿Con qué velocidad golpea el suelo?',
      'resultado': '37.04 m/s',
    },
  ],
  'Tiro Vertical': [
    {
      'ejercicio': 'Se lanza una pelota hacia arriba a 25 m/s. ¿Tiempo para altura máxima y altura máxima alcanzada?',
      'resultado': 'Tiempo ≈ 2.55 s, Altura ≈ 31.89 m',
    },
    {
      'ejercicio': 'Un objeto alcanza una altura máxima de 45 m. ¿Cuál fue su velocidad inicial?',
      'resultado': '29.7 m/s',
    },
  ],
  'Tiro Horizontal': [
    {
      'ejercicio': 'Una pelota es lanzada horizontalmente desde 45 m de altura a 15 m/s. ¿Tiempo de caída y distancia horizontal?',
      'resultado': 'Tiempo ≈ 3.03 s, Distancia ≈ 45.45 m',
    },
    {
      'ejercicio': 'Un proyectil disparado horizontalmente desde 1.2 m llega a 20 m. ¿Velocidad inicial?',
      'resultado': '40.4 m/s',
    },
  ],
  'Movimiento Circular Uniforme (MCU) y Movimiento Circular Uniformemente Variado (MCUV)': [
    {
      'ejercicio': 'Una partícula se mueve en un círculo de 0.5 m de radio a 3 m/s. Calcula aceleración centrípeta y periodo.',
      'resultado': 'a = 18 m/s², T ≈ 1.05 s',
    },
    {
      'ejercicio': 'Una centrífuga gira a 1200 rpm con radio de 0.15 m. ¿Cuál es su velocidad tangencial?',
      'resultado': '18.85 m/s',
    },
    {
      'ejercicio': 'Un disco gira a 10 rad/s y acelera 2 rad/s² durante 4 s. ¿Velocidad angular final y número de revoluciones?',
      'resultado': 'ωf = 18 rad/s, 8.91 revoluciones',
    },
  ],
'Leyes de Newton': [
    {
      'ejercicio':
          'Un automóvil de 1200 kg acelera desde el reposo hasta 20 m/s en 5 s. Calcula la fuerza neta promedio que actúa sobre el automóvil.',
      'resultado': '4800 N',
    },
    {
      'ejercicio':
          'Una caja de 50 kg es empujada horizontalmente sobre una superficie con fricción. Si el coeficiente de fricción cinética es de 0.3 y se aplica una fuerza de 200 N, ¿cuál es la aceleración de la caja?',
      'resultado': '1.06 m/s²',
    },
    {
      'ejercicio':
          'Una persona de 70 kg está de pie en una báscula dentro de un ascensor. Si el ascensor acelera hacia arriba a 2 m/s², ¿cuál es la lectura de la báscula (fuerza normal)?',
      'resultado': '826 N',
    },
    {
      'ejercicio':
          'Un bloque de 10 kg está en reposo sobre un plano inclinado sin fricción que forma un ángulo de 30° con la horizontal. Calcula la magnitud de la fuerza normal sobre el bloque.',
      'resultado': '84.87 N',
    },
    {
      'ejercicio':
          'Dos bloques de masas m1=3 kg y m2=5 kg están conectados por una cuerda ligera que pasa por una polea sin fricción. Calcula la aceleración del sistema y la tensión en la cuerda (Máquina de Atwood).',
      'resultado': '2.45 m/s²',
    },
  ],
  'Ley de Gravitación Universal': [
    {
      'ejercicio':
          'Calcula la fuerza gravitacional entre la Tierra (masa 5.97×10²⁴ kg) y la Luna (masa 7.35×10²² kg) si la distancia promedio entre sus centros es de 3.84×10⁸ m.',
      'resultado': '1.99×10²⁰ N',
    },
    {
      'ejercicio':
          '¿A qué altura sobre la superficie de la Tierra el peso de un objeto se reduce a la mitad de su valor en la superficie? (Radio de la Tierra RT = 6.37×10⁶ m).',
      'resultado': '2.64×10⁶ m',
    },
    {
      'ejercicio':
          'Determina la masa de un planeta si un satélite orbita a su alrededor a una distancia de 1.2×10⁷ m del centro del planeta con un periodo de 2.5×10⁴ s.',
      'resultado': '1.64×10²⁴ kg',
    },
  ],
'Leyes de Kepler': [
    {
      'ejercicio':
          'La Tierra orbita alrededor del Sol con un radio orbital promedio de 1.50×10¹¹ m y un periodo de 365.25 días. Si un nuevo planeta es descubierto con un radio orbital promedio de 4.50×10¹¹ m, ¿cuál sería su periodo orbital en días?',
      'resultado': '1898 días',
    },
    {
      'ejercicio':
          'Un cometa tiene una órbita elíptica alrededor del Sol. Su distancia más cercana al Sol (perihelio) es 0.5 UA y su distancia más lejana (afelio) es 3.5 UA. Calcula la longitud del semieje mayor de su órbita en UA.',
      'resultado': '2.0 UA',
    },
  ],
  'Trabajo Mecánico': [
    {
      'ejercicio':
          'Una fuerza constante de 50 N empuja una caja a lo largo de 10 m en la misma dirección de la fuerza. ¿Cuál es el trabajo realizado por esta fuerza?',
      'resultado': '500 J',
    },
    {
      'ejercicio':
          'Un levantador de pesas levanta una barra de 150 kg verticalmente 2.2 m. ¿Cuál es el trabajo realizado por el levantador contra la gravedad?',
      'resultado': '3234 J',
    },
    {
      'ejercicio':
          'Un resorte con una constante elástica de k = 400 N/m se comprime 0.15 m desde su posición de equilibrio. ¿Cuál es el trabajo realizado para comprimir el resorte?',
      'resultado': '4.5 J',
    },
  ],
  'Energía Mecánica': [
    {
      'ejercicio':
          'Un objeto de 2 kg se suelta desde el reposo desde una altura de 10 m. Utilizando la conservación de la energía mecánica, calcula la velocidad del objeto justo antes de golpear el suelo.',
      'resultado': '14.0 m/s',
    },
    {
      'ejercicio':
          'Un péndulo de 0.5 kg se suelta desde el reposo en un punto donde está a 0.3 m por encima de su punto más bajo. ¿Cuál es la velocidad del péndulo en su punto más bajo?',
      'resultado': '2.42 m/s',
    },
    {
      'ejercicio':
          'Una pelota de 0.2 kg se lanza verticalmente hacia arriba con una velocidad inicial de 15 m/s. ¿Cuál es la altura máxima que alcanza? (Desprecia la resistencia del aire).',
      'resultado': '11.48 m',
    },
  ],
  'Cantidad de Movimiento e Impulso': [
    {
      'ejercicio':
          'Un jugador de béisbol golpea una pelota de 0.15 kg que venía hacia él a 30 m/s. La pelota sale con una velocidad de 40 m/s en la dirección opuesta. Calcula el impulso impartido a la pelota.',
      'resultado': '10.5 N·s',
    },
    {
      'ejercicio':
          'Un vagón de ferrocarril de 10,000 kg que se mueve a 2 m/s choca y se acopla con otro vagón idéntico en reposo. ¿Cuál es la velocidad de los dos vagones unidos después de la colisión?',
      'resultado': '1.0 m/s',
    },
    {
      'ejercicio':
          'Una fuerza de 100 N actúa sobre un objeto durante 0.5 s. Si el objeto inicialmente estaba en reposo y tiene una masa de 2 kg, ¿cuál es su velocidad final?',
      'resultado': '25.0 m/s',
    },
  ],
'Ley de Hooke': [
    {
      'ejercicio':
          'Un resorte se estira 0.08 m cuando se le aplica una fuerza de 20 N. ¿Cuál es la constante elástica del resorte?',
      'resultado': '250 N/m',
    },
    {
      'ejercicio':
          'Un resorte con una constante elástica de 120 N/m se comprime 0.1 m. ¿Cuál es la fuerza restauradora ejercida por el resorte?',
      'resultado': '-12.0 N',
    },
    {
      'ejercicio':
          '¿Cuánta energía potencial elástica se almacena en un resorte con una constante elástica de 250 N/m que se estira 0.2 m?',
      'resultado': '5.0 J',
    },
  ],
  'Principio de Pascal y Arquímedes': [
    {
      'ejercicio':
          'Un elevador hidráulico tiene un émbolo pequeño con un área de 5 cm² y un émbolo grande con un área de 200 cm². Si se aplica una fuerza de 100 N al émbolo pequeño, ¿cuál es la fuerza que puede levantar el émbolo grande?',
      'resultado': '4000 N',
    },
    {
      'ejercicio':
          'Un objeto de 0.8 kg se sumerge completamente en agua y desplaza 500 cm³ de agua. Calcula el peso aparente del objeto cuando está sumergido. (Densidad del agua = 1000 kg/m³).',
      'resultado': '2.94 N',
    },
  ],
  'Ley de Coulomb': [
    {
      'ejercicio':
          'Dos cargas puntuales, q1=+5 μC y q2=−3 μC, están separadas por una distancia de 15 cm. Calcula la magnitud de la fuerza electrostática entre ellas y determina si es de atracción o repulsión.',
      'resultado': '600 N (atracción)',
    },
    {
      'ejercicio':
          'Tres cargas puntuales se colocan en las esquinas de un triángulo equilátero de 10 cm de lado. Las cargas son q1=+2 μC, q2=+2 μC y q3=−4 μC. Calcula la fuerza eléctrica neta sobre la carga q3.',
      'resultado': '3.11 N (aproximadamente)',
    },
    {
      'ejercicio':
          'Determina la distancia a la que deben colocarse dos esferas pequeñas, cada una con una carga de −1.0×10⁻⁶ C, para que la fuerza de repulsión entre ellas sea de 0.5 N.',
      'resultado': '0.134 m',
    },
  ],
  'Ley de Gauss': [
    {
      'ejercicio':
          'Una esfera conductora hueca con un radio de 20 cm tiene una carga neta de +6 μC. Calcula el flujo eléctrico a través de una superficie esférica concéntrica de 10 cm de radio y el flujo eléctrico a través de una superficie esférica concéntrica de 30 cm de radio.',
      'resultado': 'a) 0 N·m²/C, b) 6.78 × 10⁵ N·m²/C',
    },
    {
      'ejercicio':
          'Un cilindro de radio R y longitud L tiene una densidad de carga uniforme ρ. Utiliza la Ley de Gauss para encontrar la magnitud del campo eléctrico a una distancia r<R del eje del cilindro.',
      'resultado': '(ρ·r)/(2ε₀)',
    },
    {
      'ejercicio':
          'Un campo eléctrico uniforme de 250 N/C atraviesa una superficie cuadrada de 0.5 m de lado. El campo eléctrico forma un ángulo de 60° con la normal a la superficie. Calcula el flujo eléctrico a través de la superficie.',
      'resultado': '31.25 N·m²/C',
    },
  ],
'Potencial Eléctrico': [
    {
      'ejercicio':
          'Calcula el potencial eléctrico a una distancia de 5 cm de una carga puntual de +8 nC.',
      'resultado': '1.44 × 10³ V',
    },
    {
      'ejercicio':
          'Se tienen dos cargas puntuales: q1=+4 μC en el origen y q2=−6 μC en (3,0) m. Calcula el potencial eléctrico en el punto (0,4) m.',
      'resultado': '-9 × 10³ V',
    },
    {
      'ejercicio':
          '¿Cuánto trabajo se requiere para mover una carga de +3 μC desde un punto con un potencial de 50 V a un punto con un potencial de −20 V?',
      'resultado': '-0.21 J',
    },
  ],
  'Arreglo de Capacitores': [
    {
      'ejercicio':
          'Se conectan tres capacitores de 10 μF, 20 μF y 30 μF en serie. Calcula la capacitancia equivalente del arreglo.',
      'resultado': '4.29 μF',
    },
    {
      'ejercicio':
          'Los mismos tres capacitores del problema anterior se conectan ahora en paralelo. Calcula la capacitancia equivalente del arreglo.',
      'resultado': '60 μF',
    },
    {
      'ejercicio':
          'Un capacitor de 12 pF y otro de 8 pF se conectan en paralelo a una fuente de 12 V. Calcula la carga total almacenada en el arreglo y la energía total almacenada.',
      'resultado': '2.4 × 10⁻¹⁰ C, 1.44 × 10⁻⁸ J',
    },
  ],
  'Resistividad, Resistencia Eléctrica y Ley de Ohm': [
    {
      'ejercicio':
          'Un alambre de cobre tiene una resistividad de 1.72×10⁻⁸ Ω·m, una longitud de 20 m y un diámetro de 1.0 mm. Calcula su resistencia eléctrica.',
      'resultado': '0.437 Ω',
    },
    {
      'ejercicio':
          'Un resistor tiene una resistencia de 150 Ω. Si se le aplica una diferencia de potencial de 9 V, ¿cuál es la corriente que circula por él?',
      'resultado': '0.06 A',
    },
    {
      'ejercicio':
          '¿Qué longitud debe tener un alambre de aluminio (resistividad 2.82×10⁻⁸ Ω·m) con un diámetro de 0.5 mm para que tenga una resistencia de 2.0 Ω?',
      'resultado': '11.24 m',
    },
  ],
'Potencia Eléctrica y Pérdida de Calor': [
    {
      'ejercicio':
          'Un calentador eléctrico consume 1500 W de potencia cuando se conecta a un voltaje de 120 V. Calcula la corriente que fluye por el calentador y su resistencia.',
      'resultado': '12.5 A, 9.6 Ω',
    },
    {
      'ejercicio':
          'Una plancha eléctrica tiene una resistencia de 20 Ω y una corriente de 6 A fluye a través de ella. Calcula la potencia disipada por la plancha y la energía en calorías que se genera en 10 minutos. (Considera 1 cal = 4.184 J).',
      'resultado': '720 W, 103,144 cal',
    },
    {
      'ejercicio':
          'Un foco tiene una potencia nominal de 60 W cuando se conecta a 120 V. Si el voltaje disminuye a 110 V, ¿cuál será la potencia real disipada por el foco, suponiendo que su resistencia es constante?',
      'resultado': '50.42 W',
    },
  ],
  'Resistencia con Temperatura': [
    {
      'ejercicio':
          'Un alambre de cobre tiene una resistencia de 10 Ω a 20 °C. Si el coeficiente de temperatura de la resistividad del cobre es 0.00393 (°C)⁻¹, ¿cuál será su resistencia a 80 °C?',
      'resultado': '12.36 Ω',
    },
    {
      'ejercicio':
          'La resistencia de un termistor a 0 °C es de 1000 Ω. Si su coeficiente de temperatura es de −0.06 (°C)⁻¹, ¿cuál será su resistencia a 25 °C?',
      'resultado': '250 Ω',
    },
  ],
  'Fuerza Electromotriz y Resistencia Interna': [
    {
      'ejercicio':
          'Una batería tiene una fuerza electromotriz (FEM) de 12 V y una resistencia interna de 0.5 Ω. Si se conecta a un resistor externo de 5.5 Ω, ¿cuál es la corriente que circula por el circuito y el voltaje terminal de la batería?',
      'resultado': '2 A, 11 V',
    },
    {
      'ejercicio':
          'Una fuente de poder de 6 V suministra 1.5 A a una carga. Si el voltaje terminal medido es de 5.8 V, calcula la resistencia interna de la fuente.',
      'resultado': '0.13 Ω',
    },
  ],
  'Leyes de Kirchhoff': [
    {
      'ejercicio':
          'Un nodo con tres ramas. La corriente I1=2 A entra al nodo, la corriente I2=1.5 A sale del nodo, y la corriente I3 también sale del nodo. Aplica la Ley de Kirchhoff de los Nodos para determinar la corriente desconocida I3.',
      'resultado': '0.5 A (sale del nodo)',
    },
    {
      'ejercicio':
          'Una malla con una batería de 10 V y dos resistores en serie de 2 Ω y 3 Ω. Utiliza la Ley de Kirchhoff de las Mallas para encontrar la corriente en cada rama del circuito.',
      'resultado': '2 A',
    },
    {
      'ejercicio':
          'Malla 1: Una fuente de 6 V, un resistor de 2 Ω, y un resistor de 4 Ω. Malla 2: Una fuente de 9 V, el resistor de 4 Ω (compartido con la Malla 1), y un resistor de 3 Ω. Aplica las Leyes de Kirchhoff para encontrar las corrientes en cada rama del circuito.',
      'resultado': 'I₁ = 1 A, I₂ = 1 A (método de mallas)',
    },
  ],
'Flujo Magnético y Densidad de Flujo Magnético': [
    {
      'ejercicio':
          'Una placa metálica se encuentra bajo la acción de una densidad de flujo magnético de 1.5 T y un flujo magnético de 10 weber formando un ángulo de 30° con la línea normal de la placa. Determinar el valor del radio de la placa.',
      'resultado': '2.06 m',
    },
    {
      'ejercicio':
          'Una espira cuadrada de 10 cm de lado se encuentra bajo la influencia de un campo magnético de 3 mWb induciendo una densidad magnética de 1.5 T. Determina el valor del ángulo que forma la normal de la superficie de la lámina con respecto a las líneas de campo magnético.',
      'resultado': '11.53°',
    },
  ],
  'Campo Magnético': [
    {
      'ejercicio':
          'Un conductor recto transporta una corriente eléctrica de 800 mA, el cual genera un campo electromagnético de 0.5 T en el aire. ¿A qué distancia del conductor se genera el campo magnético?',
      'resultado': '3.2 × 10⁻⁷ m',
    },
    {
      'ejercicio':
          'Una espira circular de radio 5 cm produce una inducción magnética de 0.02 T en un medio cuya permeabilidad relativa es de 10,000. Determinar el valor de la corriente que está circulando en la espira.',
      'resultado': '0.159 A',
    },
    {
      'ejercicio':
          'Una bobina de 300 espiras y 2 cm de diámetro es excitada por una corriente eléctrica de 500 mA. Determinar el valor del campo electromagnético producido por este elemento en el aire.',
      'resultado': '0.0094 T',
    },
    {
      'ejercicio':
          'El solenoide de una marcha de automóvil tiene un núcleo de material ferromagnético con una permeabilidad relativa de 10,000 y 500 espiras, el cual al ser excitado por una corriente de 20 A, provoca un torque en el embrague del auto, para su arranque. El solenoide tiene una longitud axial de 10 cm, determinar el valor del campo electromagnético resultante.',
      'resultado': '1.26 T',
    },
    {
      'ejercicio':
          'Calcular la intensidad de corriente que debe circular por una bobina de 500 espiras de alambre en el aire, cuyo radio es de 5 cm, para que produzca una inducción magnética en su centro de 7 × 10⁻³ T.',
      'resultado': '1.11 A',
    },
    {
      'ejercicio':
          'Calcular la longitud que debe tener un solenoide para que al ser devanado con 600 espiras de alambre sobre un núcleo de hierro, con una permeabilidad relativa de 1.25×10⁴, produzca una inducción magnética de 0.5 T en su centro. Una corriente de 10 mA circula por el alambre.',
      'resultado': '0.189 m',
    },
  ],
  'Ley de Faraday y FEM Inducida': [
    {
      'ejercicio':
          'Una bobina de 500 espiras y 10 cm de radio se mueve dentro de un campo magnético cuya densidad magnética inicial es de 1.5 T hasta un campo cuya densidad magnética final es de 2 T, en un tiempo de 200 ms. Determina el valor del voltaje generado.',
      'resultado': '39.25 V',
    },
    {
      'ejercicio':
          'Un imán de barra se mueve dentro de una bobina con 200 espiras, desde un punto con flujo de 600 mWb en 2 segundos, produciendo 1.5 V. Determina el flujo magnético final.',
      'resultado': '0.615 Wb',
    },
    {
      'ejercicio':
          'Una bobina de 60 espiras emplea 4 × 10⁻² s en pasar entre polos de un imán, cambiando el flujo de 2 × 10⁻⁴ Wb a 5 × 10⁻⁴ Wb. ¿Cuál es la FEM inducida?',
      'resultado': '-0.45 V',
    },
    {
      'ejercicio':
          'Un conductor rectilíneo de 10 cm se mueve perpendicularmente a un campo magnético de 0.4 T, a 3 m/s. ¿Cuál es la FEM inducida?',
      'resultado': '0.12 V',
    },
    {
      'ejercicio':
          'El flujo magnético que cruza una espira varía de 2 × 10⁻² a 4 × 10⁻² Wb en 3 × 10⁻² s. ¿Qué FEM media se induce?',
      'resultado': '-0.666 V',
    },
  ],
'Instrumentos Eléctricos: Amperímetro y Voltímetro': [
    {
      'ejercicio':
          'Un amperímetro tiene 0.006 Ω y cada división mide 1 A. ¿Qué resistencia debe conectarse en paralelo para que mida hasta 5 A por división?',
      'resultado': '1.5 mΩ',
    },
    {
      'ejercicio':
          'Un voltímetro de 4000 Ω mide 1 V por división. ¿Qué resistencia se debe conectar en serie para que mida 10 V por división?',
      'resultado': '36,000 Ω',
    },
  ],
  'Momento Magnético y Torque Magnético': [
    {
      'ejercicio':
          'Determinar el momento magnético de una bobina circular de 5 cm de radio y 300 espiras con corriente de 700 mA, en un campo de 0.5 T.',
      'resultado': '1.649 A·m²',
    },
    {
      'ejercicio':
          'Determinar el torque sobre un imán rectangular de 10 A·m de intensidad y 5 cm de longitud en un campo de 0.5 T.',
      'resultado': '0.25 N·m',
    },
    {
      'ejercicio':
          'Determinar el momento magnético de un imán rectangular de 18 A·m y 10 cm de longitud en un campo magnético de 1.5 T.',
      'resultado': '1.8 A·m²',
    },
  ],
  'Ley de Lorentz': [
    {
      'ejercicio':
          'Un protón de carga 1.6 × 10⁻¹⁹ C entra perpendicularmente a un campo magnético de 0.3 T con velocidad de 5 × 10⁵ m/s. ¿Qué fuerza recibe?',
      'resultado': '2.4 × 10⁻¹⁴ N',
    },
    {
      'ejercicio':
          'Una carga de 6 μC se mueve perpendicularmente a un campo magnético a 4 × 10⁴ m/s y recibe una fuerza de 3 × 10⁻³ N. ¿Cuál es la inducción magnética?',
      'resultado': '0.0125 T',
    },
  ],
};
final ejerciciosDelTema = ejercicios[subtema] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('Ejercicios - $subtema')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: ejerciciosDelTema.length,
          itemBuilder: (context, index) {
            final ejercicio = ejerciciosDelTema[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: EjercicioWidget(
                ejercicio: ejercicio['ejercicio']!,
                resultado: ejercicio['resultado']!,
              ),
            );
          },
        ),
      ),
    );
  }
}

class EjercicioWidget extends StatefulWidget {
  final String ejercicio;
  final String resultado;

  const EjercicioWidget({
    super.key,
    required this.ejercicio,
    required this.resultado,
  });

  @override
  _EjercicioWidgetState createState() => _EjercicioWidgetState();
}

class _EjercicioWidgetState extends State<EjercicioWidget> {
  bool _mostrarResultado = false;

  void _toggleResultado() {
    setState(() {
      _mostrarResultado = !_mostrarResultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.ejercicio),
      subtitle: _mostrarResultado
          ? Text('Resultado: ${widget.resultado}')
          : null,
      trailing: ElevatedButton(
        onPressed: _toggleResultado,
        child: Text(_mostrarResultado ? 'Ocultar Resultado' : 'Mostrar Resultado'),
      ),
    );
  }
}
