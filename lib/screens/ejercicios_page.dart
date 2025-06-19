import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const EjerciciosPage(),
    );
  }
}

class EjerciciosPage extends StatelessWidget {
  const EjerciciosPage({super.key});

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
                    const Row(
                      children: [
                        SizedBox(width: 48),
                        Expanded(
                          child: Text(
                            'Ejercicios de Física',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 48),
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
                        'FÍSICA I',
                        Icons.speed,
                        [Colors.blue.shade400, Colors.blue.shade600],
                            () => Navigator.push(context, _createRoute(SubtemasPage(titulo: 'FÍSICA I'))),
                      ),
                      _buildModernCard(
                        context,
                        'FÍSICA II',
                        Icons.scatter_plot,
                        [Colors.green.shade400, Colors.green.shade600],
                            () => Navigator.push(context, _createRoute(SubtemasPage(titulo: 'FÍSICA II'))),
                      ),
                      _buildModernCard(
                        context,
                        'FÍSICA III',
                        Icons.electric_bolt,
                        [Colors.orange.shade400, Colors.orange.shade600],
                            () => Navigator.push(context, _createRoute(SubtemasPage(titulo: 'FÍSICA III'))),
                      ),
                      _buildModernCard(
                        context,
                        'FÍSICA IV',
                        Icons.waves,
                        [Colors.purple.shade400, Colors.purple.shade600],
                            () => Navigator.push(context, _createRoute(SubtemasPage(titulo: 'FÍSICA IV'))),
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
}

class SubtemasPage extends StatelessWidget {
  final String titulo;

  const SubtemasPage({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> subtemasPorMateria = {
      'FÍSICA I': [
        'Primera Condición de Equilibrio',
        'Segunda Condición de Equilibrio',
        'Centroide',
        'Movimiento Rectilíneo Uniforme',
        'Movimiento Rectilíneo Uniformemente Variado',
        'Caída Libre',
        'Tiro Vertical',
        'Tiro Horizontal',
        'Movimiento Circular',
      ],
      'FÍSICA II': [
        'Leyes de Newton',
        'Ley de Gravitación Universal',
        'Leyes de Kepler',
        'Trabajo Mecánico',
        'Energía Mecánica',
        'Cantidad de Movimiento',
      ],
      'FÍSICA III': [
        'Ley de Coulomb',
        'Ley de Gauss',
        'Potencial Eléctrico',
        'Resistencia y Ley de Ohm',
        'Potencia Eléctrica',
        'Leyes de Kirchhoff',
      ],
      'FÍSICA IV': [
        'Flujo Magnético',
        'Campo Magnético',
        'Ley de Faraday',
        'Instrumentos de Medición',
        'Momento Magnético',
        'Ley de Lorentz',
      ],
    };

    final subtemas = subtemasPorMateria[titulo] ?? [];
    final color = _getColorForTitle(titulo);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.shade800,
              color.shade400,
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
                        Expanded(
                          child: Text(
                            titulo,
                            style: const TextStyle(
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
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: subtemas.length,
                    itemBuilder: (context, index) {
                      return _buildSubtemasCard(
                        context,
                        subtemas[index],
                        _getIconForSubtemas(subtemas[index]),
                        [color.shade400, color.shade600],
                            () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EjerciciosPorTemaPage(
                              subtema: subtemas[index],
                              color: color,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtemasCard(BuildContext context, String title, IconData icon, List<Color> gradientColors, VoidCallback onTap) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (title.hashCode % 200)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.white),
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

  IconData _getIconForSubtemas(String subtema) {
    if (subtema.contains('Equilibrio')) return Icons.balance;
    if (subtema.contains('Movimiento')) return Icons.directions_run;
    if (subtema.contains('Leyes')) return Icons.gavel;
    if (subtema.contains('Energía')) return Icons.bolt;
    if (subtema.contains('Campo')) return Icons.explore;
    if (subtema.contains('Potencial')) return Icons.offline_bolt;
    return Icons.science;
  }

  MaterialColor _getColorForTitle(String title) {
    switch (title) {
      case 'FÍSICA I': return Colors.blue;
      case 'FÍSICA II': return Colors.green;
      case 'FÍSICA III': return Colors.orange;
      case 'FÍSICA IV': return Colors.purple;
      default: return Colors.deepPurple;
    }
  }
}

class EjerciciosPorTemaPage extends StatefulWidget {
  final String subtema;
  final MaterialColor color;

  const EjerciciosPorTemaPage({
    super.key,
    required this.subtema,
    required this.color,
  });

  @override
  _EjerciciosPorTemaPageState createState() => _EjerciciosPorTemaPageState();
}

class _EjerciciosPorTemaPageState extends State<EjerciciosPorTemaPage> {
  int _ejerciciosMostrados = 3; // Comienza mostrando 3 ejercicios
  late List<Map<String, dynamic>> _todosLosEjercicios;

  @override
  void initState() {
    super.initState();
    _todosLosEjercicios = _getEjerciciosForSubtemas(widget.subtema)
      ..sort((a, b) => b['dificultad'].compareTo(a['dificultad']));
  }

  void _cargarMasEjercicios() {
    setState(() {
      _ejerciciosMostrados += 3;
      if (_ejerciciosMostrados > _todosLosEjercicios.length) {
        _ejerciciosMostrados = _todosLosEjercicios.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ejerciciosMostrados = _todosLosEjercicios.take(_ejerciciosMostrados).toList();
    final hayMasEjercicios = _ejerciciosMostrados < _todosLosEjercicios.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.color.shade800,
              widget.color.shade400,
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
                        Expanded(
                          child: Text(
                            widget.subtema,
                            style: const TextStyle(
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
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: ejerciciosMostrados.length,
                          itemBuilder: (context, index) {
                            return _buildEjercicioCard(
                              context,
                              ejerciciosMostrados[index]['ejercicio']!,
                              ejerciciosMostrados[index]['resultado']!,
                              widget.color,
                              ejerciciosMostrados[index]['dificultad']!,
                            );
                          },
                        ),
                      ),
                      if (hayMasEjercicios)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                            onPressed: _cargarMasEjercicios,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.color,
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Cargar más',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
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

  Widget _buildEjercicioCard(BuildContext context, String ejercicio, String resultado, MaterialColor color, int dificultad) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ejercicio,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: List.generate(5, (i) => Icon(
                i < dificultad ? Icons.star : Icons.star_border,
                size: 16,
                color: Colors.amber,
              )),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Solución:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.shade100),
                  ),
                  child: Text(
                    resultado,
                    style: TextStyle(
                      color: color.shade800,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getEjerciciosForSubtemas(String subtema) {
    // Todos los ejercicios ahora incluyen un campo 'dificultad' (1-5)
    if (subtema == 'Primera Condición de Equilibrio') {
      return [
        {
          'ejercicio': 'Un semáforo de 15 kg está suspendido por dos cables que forman ángulos de 30° y 45° con la horizontal. ¿Cuáles son las tensiones en los cables?',
          'resultado': 'T1 = 402.02 N y T2 = 492.37 N',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Una caja de 80 kg está en reposo sobre un plano inclinado de 25° con la horizontal. Si el coeficiente de fricción estática es de 0.4, ¿cuál es la fuerza de fricción que actúa sobre la caja?',
          'resultado': '284.51 N',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Una persona de 60 kg se cuelga de una barra horizontal. Si los brazos forman un ángulo de 60° con la vertical, ¿cuál es la tensión en cada brazo?',
          'resultado': '588.6 N',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Un objeto de 5 kg está colgando del techo por una cuerda. Si se aplica una fuerza horizontal de 30 N, ¿cuál es la tensión en la cuerda y el ángulo que forma con la vertical cuando está en equilibrio?',
          'resultado': 'Tensión ≈ 57.5 N y Ángulo ≈ 31.45°',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un bloque de 10 kg descansa sobre una superficie horizontal. Se aplica una fuerza de 50 N formando un ángulo de 30° con la horizontal. Calcula la fuerza normal y la aceleración del bloque si el coeficiente de fricción cinética es 0.2.',
          'resultado': 'Fn ≈ 73.5 N, a ≈ 2.83 m/s²',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Dos cuerdas sostienen un objeto de 20 kg. La primera cuerda forma un ángulo de 40° con la vertical y la segunda de 25°. Calcula las tensiones en ambas cuerdas.',
          'resultado': 'T1 ≈ 147.2 N, T2 ≈ 178.5 N',
          'dificultad': 5,
        },
      ];
    } else if (subtema == 'Segunda Condición de Equilibrio') {
      return [
        {
          'ejercicio': 'Una viga uniforme de 5 m de longitud y 100 kg de masa está pivoteada en un extremo. ¿Qué fuerza vertical hacia arriba se debe aplicar en el otro extremo para mantenerla en equilibrio horizontal?',
          'resultado': '490.5 N',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Una tabla de 6 m y 40 kg está sostenida por dos soportes, uno en el extremo izquierdo y otro a 1.5 m del extremo derecho. Una persona de 70 kg se para a 1 m del extremo izquierdo. ¿Qué fuerzas ejercen los soportes?',
          'resultado': 'Izquierdo: 664.9 N, Derecho: 414.2 N',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Una escalera de 8 m y 20 kg se apoya contra una pared sin fricción, formando un ángulo de 60° con el suelo. Si μ = 0.5, ¿qué tan lejos puede subir una persona de 70 kg antes de que la escalera resbale?',
          'resultado': '9.14 m',
          'dificultad': 5,
        },
        {
          'ejercicio': 'Una puerta uniforme de 20 kg mide 1 m de ancho y 2 m de alto. Se aplica una fuerza horizontal de 50 N en el borde opuesto a las bisagras. Calcula la aceleración angular de la puerta.',
          'resultado': '1.5 rad/s²',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Un cilindro homogéneo de 10 kg y radio 0.5 m gira alrededor de un eje fijo. Se aplica una fuerza tangencial de 20 N. Calcula la aceleración angular.',
          'resultado': '8 rad/s²',
          'dificultad': 3,
        },
      ];
    } else if (subtema == 'Centroide') {
      return [
        {
          'ejercicio': 'Determina las coordenadas del centroide de una lámina en forma de L, formada por un rectángulo de 6×2 cm y otro de 2×4 cm.',
          'resultado': '(3.8 cm, 2.2 cm)',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Calcula el centroide de tres masas: m1=2 kg en (1,0), m2=3 kg en (3,0), m3=1 kg en (2,4).',
          'resultado': '(2.17 m, 0.67 m)',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Una placa de 10x5 cm tiene un agujero circular de radio 2 cm centrado en (2.5, 2.5). ¿Dónde está el nuevo centroide?',
          'resultado': '(5.84 cm, 2.5 cm)',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Calcula el centroide de un triángulo rectángulo con catetos de 6 cm y 8 cm.',
          'resultado': '(2.67 cm, 2.67 cm) desde el ángulo recto',
          'dificultad': 3,
        },
      ];
    } else if (subtema == 'Movimiento Rectilíneo Uniforme (MRU)') {
      return [
        {
          'ejercicio': 'Un automóvil viaja a una velocidad constante de 90 km/h. ¿Qué distancia recorre en 2.5 horas?',
          'resultado': '225 km',
          'dificultad': 1,
        },
        {
          'ejercicio': 'Un corredor completa una carrera de 100 m en 10.5 s. ¿Cuál fue su velocidad promedio?',
          'resultado': '9.52 m/s',
          'dificultad': 1,
        },
        {
          'ejercicio': 'Dos trenes parten desde estaciones separadas 300 km. Uno viaja a 70 km/h, el otro a 80 km/h. ¿Cuándo se cruzan?',
          'resultado': '2 horas',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Un avión vuela a 900 km/h durante 3 horas, luego reduce su velocidad a 700 km/h durante 2 horas. ¿Qué distancia total recorrió?',
          'resultado': '4100 km',
          'dificultad': 2,
        },
      ];
    } else if (subtema == 'Movimiento Rectilíneo Uniformemente Variado (MRUV)') {
      return [
        {
          'ejercicio': 'Un objeto parte del reposo y acelera a 4 m/s² durante 6 s. ¿Qué distancia recorre?',
          'resultado': '72 m',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Un coche viaja a 20 m/s y frena hasta detenerse en 4 s. ¿Cuál es la aceleración y distancia de frenado?',
          'resultado': 'a = -5 m/s², d = 40 m',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un avión parte del reposo y necesita alcanzar 80 m/s en 1200 m de pista. ¿Qué aceleración requiere?',
          'resultado': '2.67 m/s²',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Un tren que viaja a 72 km/h frena uniformemente hasta detenerse en 100 m. Calcula la aceleración y el tiempo que tarda en detenerse.',
          'resultado': 'a = -2 m/s², t = 10 s',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un objeto se deja caer desde un edificio y tarda 4 s en llegar al suelo. Calcula la altura del edificio y la velocidad con que impacta.',
          'resultado': 'h = 78.4 m, v = 39.2 m/s',
          'dificultad': 3,
        },
      ];
    } else if (subtema == 'Caída Libre') {
      return [
        {
          'ejercicio': 'Se deja caer una piedra y tarda 3 s en llegar al suelo. ¿Cuál es la altura del edificio?',
          'resultado': '44.1 m',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Un objeto cae desde 70 m. ¿Con qué velocidad golpea el suelo?',
          'resultado': '37.04 m/s',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Se lanza una pelota verticalmente hacia arriba con velocidad de 30 m/s. Calcula el tiempo que tarda en alcanzar su altura máxima y la altura máxima alcanzada.',
          'resultado': 't = 3.06 s, h = 45.9 m',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Desde un puente de 50 m de altura se lanza una piedra hacia abajo con velocidad inicial de 10 m/s. ¿Cuánto tarda en llegar al agua?',
          'resultado': '2.02 s',
          'dificultad': 3,
        },
      ];
    } else if (subtema == 'Tiro Vertical') {
      return [
        {
          'ejercicio': 'Se lanza una pelota hacia arriba a 25 m/s. ¿Tiempo para altura máxima y altura máxima alcanzada?',
          'resultado': 'Tiempo ≈ 2.55 s, Altura ≈ 31.89 m',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un objeto alcanza una altura máxima de 45 m. ¿Cuál fue su velocidad inicial?',
          'resultado': '29.7 m/s',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Desde el suelo se lanza un objeto hacia arriba. Pasa por un punto a 20 m de altura dos veces, con un intervalo de 4 s. ¿Cuál fue la velocidad inicial?',
          'resultado': '29.4 m/s',
          'dificultad': 4,
        },
      ];
    } else if (subtema == 'Tiro Horizontal') {
      return [
        {
          'ejercicio': 'Una pelota es lanzada horizontalmente desde 45 m de altura a 15 m/s. ¿Tiempo de caída y distancia horizontal?',
          'resultado': 'Tiempo ≈ 3.03 s, Distancia ≈ 45.45 m',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un proyectil disparado horizontalmente desde 1.2 m llega a 20 m. ¿Velocidad inicial?',
          'resultado': '40.4 m/s',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Desde un avión que vuela horizontalmente a 200 m/s y 500 m de altura se deja caer un paquete. ¿A qué distancia del objetivo debe soltarse?',
          'resultado': '2018.2 m',
          'dificultad': 4,
        },
      ];
    } else if (subtema == 'Movimiento Circular') {
      return [
        {
          'ejercicio': 'Una partícula se mueve en un círculo de 0.5 m de radio a 3 m/s. Calcula aceleración centrípeta y periodo.',
          'resultado': 'a = 18 m/s², T ≈ 1.05 s',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Una centrífuga gira a 1200 rpm con radio de 0.15 m. ¿Cuál es su velocidad tangencial?',
          'resultado': '18.85 m/s',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un disco gira a 10 rad/s y acelera 2 rad/s² durante 4 s. ¿Velocidad angular final y número de revoluciones?',
          'resultado': 'ωf = 18 rad/s, 8.91 revoluciones',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Una piedra atada a una cuerda de 1 m gira en un plano vertical. Si en el punto más alto la tensión es cero, ¿cuál es la velocidad en ese punto?',
          'resultado': '3.13 m/s',
          'dificultad': 4,
        },
      ];
    } else if (subtema == 'Leyes de Newton') {
      return [
        {
          'ejercicio': 'Un automóvil de 1200 kg acelera desde el reposo hasta 20 m/s en 5 s. Calcula la fuerza neta promedio que actúa sobre el automóvil.',
          'resultado': '4800 N',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Una caja de 50 kg es empujada horizontalmente sobre una superficie con fricción. Si el coeficiente de fricción cinética es de 0.3 y se aplica una fuerza de 200 N, ¿cuál es la aceleración de la caja?',
          'resultado': '1.06 m/s²',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Una persona de 70 kg está de pie en una báscula dentro de un ascensor. Si el ascensor acelera hacia arriba a 2 m/s², ¿cuál es la lectura de la báscula (fuerza normal)?',
          'resultado': '826 N',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un bloque de 10 kg está en reposo sobre un plano inclinado sin fricción que forma un ángulo de 30° con la horizontal. Calcula la magnitud de la fuerza normal sobre el bloque.',
          'resultado': '84.87 N',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Dos bloques de masas m1=3 kg y m2=5 kg están conectados por una cuerda ligera que pasa por una polea sin fricción. Calcula la aceleración del sistema y la tensión en la cuerda (Máquina de Atwood).',
          'resultado': '2.45 m/s²',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Un sistema de tres bloques (2 kg, 3 kg y 5 kg) conectados por cuerdas se acelera por una fuerza de 50 N aplicada al bloque de 2 kg. Calcula la aceleración del sistema y las tensiones en las cuerdas.',
          'resultado': 'a = 5 m/s², T1 = 40 N, T2 = 25 N',
          'dificultad': 5,
        },
      ];
    } else if (subtema == 'Ley de Gravitación Universal') {
      return [
        {
          'ejercicio': 'Calcula la fuerza gravitacional entre la Tierra (masa 5.97×10²⁴ kg) y la Luna (masa 7.35×10²² kg) si la distancia promedio entre sus centros es de 3.84×10⁸ m.',
          'resultado': '1.99×10²⁰ N',
          'dificultad': 4,
        },
        {
          'ejercicio': '¿A qué altura sobre la superficie de la Tierra el peso de un objeto se reduce a la mitad de su valor en la superficie? (Radio de la Tierra RT = 6.37×10⁶ m).',
          'resultado': '2.64×10⁶ m',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Determina la masa de un planeta si un satélite orbita a su alrededor a una distancia de 1.2×10⁷ m del centro del planeta con un periodo de 2.5×10⁴ s.',
          'resultado': '1.64×10²⁴ kg',
          'dificultad': 5,
        },
        {
          'ejercicio': 'Calcula la velocidad orbital de un satélite que gira a 400 km sobre la superficie terrestre. (Masa Tierra = 5.97×10²⁴ kg, RT = 6.37×10⁶ m).',
          'resultado': '7672 m/s',
          'dificultad': 4,
        },
      ];
    } else if (subtema == 'Leyes de Kepler') {
      return [
        {
          'ejercicio': 'La Tierra orbita alrededor del Sol con un radio orbital promedio de 1.50×10¹¹ m y un periodo de 365.25 días. Si un nuevo planeta es descubierto con un radio orbital promedio de 4.50×10¹¹ m, ¿cuál sería su periodo orbital en días?',
          'resultado': '1898 días',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Un cometa tiene una órbita elíptica alrededor del Sol. Su distancia más cercana al Sol (perihelio) es 0.5 UA y su distancia más lejana (afelio) es 3.5 UA. Calcula la longitud del semieje mayor de su órbita en UA.',
          'resultado': '2.0 UA',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un satélite artificial tiene un periodo de 90 minutos. ¿A qué altura sobre la superficie terrestre debe orbitar? (Masa Tierra = 5.97×10²⁴ kg, RT = 6.37×10⁶ m).',
          'resultado': '279 km',
          'dificultad': 5,
        },
      ];
    } else if (subtema == 'Trabajo Mecánico') {
      return [
        {
          'ejercicio': 'Una fuerza constante de 50 N empuja una caja a lo largo de 10 m en la misma dirección de la fuerza. ¿Cuál es el trabajo realizado por esta fuerza?',
          'resultado': '500 J',
          'dificultad': 1,
        },
        {
          'ejercicio': 'Un levantador de pesas levanta una barra de 150 kg verticalmente 2.2 m. ¿Cuál es el trabajo realizado por el levantador contra la gravedad?',
          'resultado': '3234 J',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Un resorte con una constante elástica de k = 400 N/m se comprime 0.15 m desde su posición de equilibrio. ¿Cuál es el trabajo realizado para comprimir el resorte?',
          'resultado': '4.5 J',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Una caja de 20 kg se arrastra 15 m por un piso horizontal con una fuerza de 100 N que forma un ángulo de 30° con la horizontal. Si μ = 0.2, calcula el trabajo realizado por la fuerza aplicada.',
          'resultado': '1299 J',
          'dificultad': 4,
        },
      ];
    } else if (subtema == 'Energía Mecánica') {
      return [
        {
          'ejercicio': 'Un objeto de 2 kg se suelta desde el reposo desde una altura de 10 m. Utilizando la conservación de la energía mecánica, calcula la velocidad del objeto justo antes de golpear el suelo.',
          'resultado': '14.0 m/s',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Un péndulo de 0.5 kg se suelta desde el reposo en un punto donde está a 0.3 m por encima de su punto más bajo. ¿Cuál es la velocidad del péndulo en su punto más bajo?',
          'resultado': '2.42 m/s',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Una pelota de 0.2 kg se lanza verticalmente hacia arriba con una velocidad inicial de 15 m/s. ¿Cuál es la altura máxima que alcanza? (Desprecia la resistencia del aire).',
          'resultado': '11.48 m',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Un bloque de 5 kg se desliza por una rampa sin fricción desde una altura de 3 m. Luego recorre 10 m sobre una superficie rugosa (μ = 0.4) antes de detenerse. ¿Qué velocidad tenía al pie de la rampa?',
          'resultado': '7.67 m/s',
          'dificultad': 4,
        },
      ];
    } else if (subtema == 'Cantidad de Movimiento') {
      return [
        {
          'ejercicio': 'Un jugador de béisbol golpea una pelota de 0.15 kg que venía hacia él a 30 m/s. La pelota sale con una velocidad de 40 m/s en la dirección opuesta. Calcula el impulso impartido a la pelota.',
          'resultado': '10.5 N·s',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un vagón de ferrocarril de 10,000 kg que se mueve a 2 m/s choca y se acopla con otro vagón idéntico en reposo. ¿Cuál es la velocidad de los dos vagones unidos después de la colisión?',
          'resultado': '1.0 m/s',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Una fuerza de 100 N actúa sobre un objeto durante 0.5 s. Si el objeto inicialmente estaba en reposo y tiene una masa de 2 kg, ¿cuál es su velocidad final?',
          'resultado': '25.0 m/s',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Un proyectil de 0.1 kg se dispara horizontalmente a 500 m/s contra un bloque de madera de 2 kg en reposo. Si el proyectil queda incrustado, ¿qué velocidad adquiere el bloque?',
          'resultado': '23.8 m/s',
          'dificultad': 4,
        },
      ];
    } else if (subtema == 'Ley de Coulomb') {
      return [
        {
          'ejercicio': 'Dos cargas puntuales, q1=+5 μC y q2=−3 μC, están separadas por una distancia de 15 cm. Calcula la magnitud de la fuerza electrostática entre ellas y determina si es de atracción o repulsión.',
          'resultado': '600 N (atracción)',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Tres cargas puntuales se colocan en las esquinas de un triángulo equilátero de 10 cm de lado. Las cargas son q1=+2 μC, q2=+2 μC y q3=−4 μC. Calcula la fuerza eléctrica neta sobre la carga q3.',
          'resultado': '3.11 N (aproximadamente)',
          'dificultad': 5,
        },
        {
          'ejercicio': 'Determina la distancia a la que deben colocarse dos esferas pequeñas, cada una con una carga de −1.0×10⁻⁶ C, para que la fuerza de repulsión entre ellas sea de 0.5 N.',
          'resultado': '0.134 m',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Cuatro cargas idénticas de +1 μC se colocan en las esquinas de un cuadrado de 0.1 m de lado. Calcula la fuerza neta sobre una carga de +2 μC colocada en el centro del cuadrado.',
          'resultado': '0 N',
          'dificultad': 4,
        },
      ];
    } else if (subtema == 'Ley de Gauss') {
      return [
        {
          'ejercicio': 'Una esfera conductora hueca con un radio de 20 cm tiene una carga neta de +6 μC. Calcula el flujo eléctrico a través de una superficie esférica concéntrica de 10 cm de radio y el flujo eléctrico a través de una superficie esférica concéntrica de 30 cm de radio.',
          'resultado': 'a) 0 N·m²/C, b) 6.78 × 10⁵ N·m²/C',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Un cilindro de radio R y longitud L tiene una densidad de carga uniforme ρ. Utiliza la Ley de Gauss para encontrar la magnitud del campo eléctrico a una distancia r<R del eje del cilindro.',
          'resultado': '(ρ·r)/(2ε₀)',
          'dificultad': 5,
        },
        {
          'ejercicio': 'Un campo eléctrico uniforme de 250 N/C atraviesa una superficie cuadrada de 0.5 m de lado. El campo eléctrico forma un ángulo de 60° con la normal a la superficie. Calcula el flujo eléctrico a través de la superficie.',
          'resultado': '31.25 N·m²/C',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Una lámina infinita tiene una densidad de carga superficial σ = 2×10⁻⁶ C/m². Calcula el campo eléctrico a 10 cm de la lámina.',
          'resultado': '1.13 × 10⁵ N/C',
          'dificultad': 4,
        },
      ];
    } else if (subtema == 'Potencial Eléctrico') {
      return [
        {
          'ejercicio': 'Calcula el potencial eléctrico a una distancia de 5 cm de una carga puntual de +8 nC.',
          'resultado': '1.44 × 10³ V',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Se tienen dos cargas puntuales: q1=+4 μC en el origen y q2=−6 μC en (3,0) m. Calcula el potencial eléctrico en el punto (0,4) m.',
          'resultado': '-9 × 10³ V',
          'dificultad': 4,
        },
        {
          'ejercicio': '¿Cuánto trabajo se requiere para mover una carga de +3 μC desde un punto con un potencial de 50 V a un punto con un potencial de −20 V?',
          'resultado': '-0.21 J',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Tres cargas de +2 μC, -3 μC y +4 μC están colocadas en los vértices de un triángulo equilátero de 10 cm de lado. Calcula la energía potencial del sistema.',
          'resultado': '-0.594 J',
          'dificultad': 5,
        },
      ];
    } else if (subtema == 'Resistencia y Ley de Ohm') {
      return [
        {
          'ejercicio': 'Un alambre de cobre tiene una resistividad de 1.72×10⁻⁸ Ω·m, una longitud de 20 m y un diámetro de 1.0 mm. Calcula su resistencia eléctrica.',
          'resultado': '0.437 Ω',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un resistor tiene una resistencia de 150 Ω. Si se le aplica una diferencia de potencial de 9 V, ¿cuál es la corriente que circula por él?',
          'resultado': '0.06 A',
          'dificultad': 1,
        },
        {
          'ejercicio': '¿Qué longitud debe tener un alambre de aluminio (resistividad 2.82×10⁻⁸ Ω·m) con un diámetro de 0.5 mm para que tenga una resistencia de 2.0 Ω?',
          'resultado': '11.24 m',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un termistor tiene una resistencia de 10 kΩ a 25°C y un coeficiente de temperatura de -0.05/°C. ¿Cuál será su resistencia a 50°C?',
          'resultado': '7.5 kΩ',
          'dificultad': 4,
        },
      ];
    } else if (subtema == 'Potencia Eléctrica') {
      return [
        {
          'ejercicio': 'Un calentador eléctrico consume 1500 W de potencia cuando se conecta a un voltaje de 120 V. Calcula la corriente que fluye por el calentador y su resistencia.',
          'resultado': '12.5 A, 9.6 Ω',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Una plancha eléctrica tiene una resistencia de 20 Ω y una corriente de 6 A fluye a través de ella. Calcula la potencia disipada por la plancha y la energía en calorías que se genera en 10 minutos. (Considera 1 cal = 4.184 J).',
          'resultado': '720 W, 103,144 cal',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un foco tiene una potencia nominal de 60 W cuando se conecta a 120 V. Si el voltaje disminuye a 110 V, ¿cuál será la potencia real disipada por el foco, suponiendo que su resistencia es constante?',
          'resultado': '50.42 W',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Una batería de 12 V suministra 5 A durante 2 horas. ¿Cuánta energía proporciona en kWh?',
          'resultado': '0.12 kWh',
          'dificultad': 3,
        },
      ];
    } else if (subtema == 'Leyes de Kirchhoff') {
      return [
        {
          'ejercicio': 'Un nodo con tres ramas. La corriente I1=2 A entra al nodo, la corriente I2=1.5 A sale del nodo, y la corriente I3 también sale del nodo. Aplica la Ley de Kirchhoff de los Nodos para determinar la corriente desconocida I3.',
          'resultado': '0.5 A (sale del nodo)',
          'dificultad': 2,
        },
        {
          'ejercicio': 'Una malla con una batería de 10 V y dos resistores en serie de 2 Ω y 3 Ω. Utiliza la Ley de Kirchhoff de las Mallas para encontrar la corriente en cada rama del circuito.',
          'resultado': '2 A',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Malla 1: Una fuente de 6 V, un resistor de 2 Ω, y un resistor de 4 Ω. Malla 2: Una fuente de 9 V, el resistor de 4 Ω (compartido con la Malla 1), y un resistor de 3 Ω. Aplica las Leyes de Kirchhoff para encontrar las corrientes en cada rama del circuito.',
          'resultado': 'I₁ = 1 A, I₂ = 1 A (método de mallas)',
          'dificultad': 5,
        },
        {
          'ejercicio': 'En el circuito, R1=2Ω, R2=4Ω, R3=6Ω, V1=12V, V2=6V. Calcula las corrientes en cada rama usando las leyes de Kirchhoff.',
          'resultado': 'I1=1.5A, I2=0.75A, I3=0.75A',
          'dificultad': 5,
        },
      ];
    } else if (subtema == 'Flujo Magnético') {
      return [
        {
          'ejercicio': 'Una placa metálica se encuentra bajo la acción de una densidad de flujo magnético de 1.5 T y un flujo magnético de 10 weber formando un ángulo de 30° con la línea normal de la placa. Determinar el valor del radio de la placa.',
          'resultado': '2.06 m',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Una espira cuadrada de 10 cm de lado se encuentra bajo la influencia de un campo magnético de 3 mWb induciendo una densidad magnética de 1.5 T. Determina el valor del ángulo que forma la normal de la superficie de la lámina con respecto a las líneas de campo magnético.',
          'resultado': '11.53°',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Un solenoide de 50 cm de largo y 2 cm de diámetro tiene 1000 vueltas y conduce una corriente de 5 A. Calcula el flujo magnético a través de una sección transversal del solenoide.',
          'resultado': '1.58 × 10⁻⁴ Wb',
          'dificultad': 5,
        },
      ];
    } else if (subtema == 'Campo Magnético') {
      return [
        {
          'ejercicio': 'Un conductor recto transporta una corriente eléctrica de 800 mA, el cual genera un campo electromagnético de 0.5 T en el aire. ¿A qué distancia del conductor se genera el campo magnético?',
          'resultado': '3.2 × 10⁻⁷ m',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Una espira circular de radio 5 cm produce una inducción magnética de 0.02 T en un medio cuya permeabilidad relativa es de 10,000. Determinar el valor de la corriente que está circulando en la espira.',
          'resultado': '0.159 A',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Una bobina de 300 espiras y 2 cm de diámetro es excitada por una corriente eléctrica de 500 mA. Determinar el valor del campo electromagnético producido por este elemento en el aire.',
          'resultado': '0.0094 T',
          'dificultad': 3,
        },
        {
          'ejercicio': 'El solenoide de una marcha de automóvil tiene un núcleo de material ferromagnético con una permeabilidad relativa de 10,000 y 500 espiras, el cual al ser excitado por una corriente de 20 A, provoca un torque en el embrague del auto, para su arranque. El solenoide tiene una longitud axial de 10 cm, determinar el valor del campo electromagnético resultante.',
          'resultado': '1.26 T',
          'dificultad': 5,
        },
      ];
    } else if (subtema == 'Ley de Faraday') {
      return [
        {
          'ejercicio': 'Una bobina de 500 espiras y 10 cm de radio se mueve dentro de un campo magnético cuya densidad magnética inicial es de 1.5 T hasta un campo cuya densidad magnética final es de 2 T, en un tiempo de 200 ms. Determina el valor del voltaje generado.',
          'resultado': '39.25 V',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Un imán de barra se mueve dentro de una bobina con 200 espiras, desde un punto con flujo de 600 mWb en 2 segundos, produciendo 1.5 V. Determina el flujo magnético final.',
          'resultado': '0.615 Wb',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Una bobina de 60 espiras emplea 4 × 10⁻² s en pasar entre polos de un imán, cambiando el flujo de 2 × 10⁻⁴ Wb a 5 × 10⁻⁴ Wb. ¿Cuál es la FEM inducida?',
          'resultado': '-0.45 V',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Una espira cuadrada de 10 cm de lado se mueve perpendicularmente a un campo magnético uniforme de 0.5 T a 2 m/s. Calcula la FEM inducida.',
          'resultado': '0.1 V',
          'dificultad': 4,
        },
      ];
    } else if (subtema == 'Instrumentos de Medición') {
      return [
        {
          'ejercicio': 'Un amperímetro tiene 0.006 Ω y cada división mide 1 A. ¿Qué resistencia debe conectarse en paralelo para que mida hasta 5 A por división?',
          'resultado': '1.5 mΩ',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Un voltímetro de 4000 Ω mide 1 V por división. ¿Qué resistencia se debe conectar en serie para que mida 10 V por división?',
          'resultado': '36,000 Ω',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Un galvanómetro con resistencia interna de 50 Ω y sensibilidad de 1 mA se usa para construir un voltímetro de 10 V. ¿Qué resistencia multiplicadora se necesita?',
          'resultado': '9950 Ω',
          'dificultad': 5,
        },
      ];
    } else if (subtema == 'Momento Magnético') {
      return [
        {
          'ejercicio': 'Determinar el momento magnético de una bobina circular de 5 cm de radio y 300 espiras con corriente de 700 mA, en un campo de 0.5 T.',
          'resultado': '1.649 A·m²',
          'dificultad': 4,
        },
        {
          'ejercicio': 'Determinar el torque sobre un imán rectangular de 10 A·m de intensidad y 5 cm de longitud en un campo de 0.5 T.',
          'resultado': '0.25 N·m',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un electrón en un átomo de hidrógeno tiene un momento magnético orbital de 9.27×10⁻²⁴ A·m². ¿Qué torque experimenta en un campo magnético de 2 T cuando el momento forma un ángulo de 30° con el campo?',
          'resultado': '9.27×10⁻²⁴ N·m',
          'dificultad': 5,
        },
      ];
    } else if (subtema == 'Ley de Lorentz') {
      return [
        {
          'ejercicio': 'Un protón de carga 1.6 × 10⁻¹⁹ C entra perpendicularmente a un campo magnético de 0.3 T con velocidad de 5 × 10⁵ m/s. ¿Qué fuerza recibe?',
          'resultado': '2.4 × 10⁻¹⁴ N',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Una carga de 6 μC se mueve perpendicularmente a un campo magnético a 4 × 10⁴ m/s y recibe una fuerza de 3 × 10⁻³ N. ¿Cuál es la inducción magnética?',
          'resultado': '0.0125 T',
          'dificultad': 3,
        },
        {
          'ejercicio': 'Un electrón se mueve a 2×10⁶ m/s en un campo magnético de 0.01 T formando un ángulo de 45°. Calcula la fuerza magnética sobre el electrón.',
          'resultado': '2.26×10⁻¹⁵ N',
          'dificultad': 4,
        },
      ];
    } else {
      return [
        {
          'ejercicio': 'Ejemplo de ejercicio para $subtema',
          'resultado': 'Solución del ejercicio',
          'dificultad': 1,
        },
      ];
    }
  }
}
