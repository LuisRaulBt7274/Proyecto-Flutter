import 'package:flutter/material.dart';

class ExamenesPage extends StatelessWidget {
  const ExamenesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exámenes')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildCard(context, 'Física 1', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Fisica1ExamPage()),
              );
          }),
          _buildCard(context, 'Física 2', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Fisica2ExamPage()),
              );
            }),
          _buildCard(context, 'Física 3', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Fisica3ExamPage()),
              );
            }),
          _buildCard(context, 'Física 4', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExamPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;

  Question({required this.question, required this.options, required this.correctIndex});
}

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  final List<Question> _questions = [
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
  ];

  int _currentQuestionIndex = 0;
  List<int?> _answers = List.filled(10, null);
  int _score = 0;
  bool _submitted = false;

  void _nextQuestion() {
    if (_answers[_currentQuestionIndex] == null) return;
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
    }
  }

  void _submitExam() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctIndex) score++;
    }
    setState(() {
      _score = score;
      _submitted = true;
    });
  }

  void _restartExam() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers = List.filled(_questions.length, null);
      _score = 0;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        appBar: AppBar(title: Text('Resultado del Examen')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text('Puntaje final: $_score / ${_questions.length}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ...List.generate(_questions.length, (index) {
                final question = _questions[index];
                final userAnswer = _answers[index];
                final isCorrect = userAnswer == question.correctIndex;
                return Card(
                  color: isCorrect ? Colors.green[100] : Colors.red[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pregunta ${index + 1}:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                        Text(question.question,
                            style:TextStyle(color: Colors.black)),
                        SizedBox(height: 8),
                        Text('Tu respuesta: ${userAnswer != null ? question.options[userAnswer] : 'No respondida'}',
                            style:TextStyle(color: Colors.black)),
                        Text('Respuesta correcta: ${question.options[question.correctIndex]}',
                            style:TextStyle(color: Colors.black)),
                        if (!isCorrect) Text('✗ Incorrecta', style: TextStyle(color: Colors.red)),
                        if (isCorrect) Text('✓ Correcta', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _restartExam, child: Text('Reiniciar Examen')),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: Text('Examen de Electromagnetismo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pregunta ${_currentQuestionIndex + 1}/${_questions.length}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(question.question, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            ...List.generate(question.options.length, (index) {
              return RadioListTile<int>(
                title: Text(question.options[index]),
                value: index,
                groupValue: _answers[_currentQuestionIndex],
                onChanged: (value) {
                  setState(() {
                    _answers[_currentQuestionIndex] = value;
                  });
                },
              );
            }),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _currentQuestionIndex == _questions.length - 1
                      ? _submitExam
                      : _nextQuestion,
                  child: Text(_currentQuestionIndex == _questions.length - 1 ? 'Enviar' : 'Siguiente'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class Fisica2ExamPage extends StatefulWidget {
  @override
  _Fisica2ExamPageState createState() => _Fisica2ExamPageState();
}

class _Fisica2ExamPageState extends State<Fisica2ExamPage> {
  final List<Question> _questions = [
    Question(
      question: 'Una fuerza neta de 150 N actúa sobre un objeto, provocando que este acelere a 3 m/s². ¿Cuál es la masa del objeto?',
      options: ['450 kg', '50 kg', '0.02 kg', '153 kg'],
      correctIndex: 1,
    ),
    Question(
      question: 'Si la distancia entre dos masas se duplica, ¿qué sucede con la fuerza de atracción gravitacional entre ellas?',
      options: ['Se duplica.', 'Se reduce a la mitad.', 'Se cuadruplica.', 'Se reduce a la cuarta parte.'],
      correctIndex: 3,
    ),
    Question(
      question: 'Un planeta completa una órbita en 8 años con un radio de 2 UA. ¿Cuál es el radio orbital promedio de un planeta que tarda 27 años?',
      options: ['3 UA', '4.5 UA', '6 UA', '9 UA'],
      correctIndex: 1,
    ),
    Question(
      question: 'Una persona arrastra una caja de 20 kg con una fuerza de 60 N a 30° sobre 5 m. ¿Cuál es el trabajo realizado?',
      options: ['300 J', '259.8 J', '150 J', '600 J'],
      correctIndex: 1,
    ),
    Question(
      question: 'Un esquiador de 70 kg desciende por una pendiente con v = 10 m/s y h = 20 m. ¿Cuál es su energía mecánica total?',
      options: ['10,500 J', '13,720 J', '24,220 J', '7,000 J'],
      correctIndex: 2,
    ),
    Question(
      question: 'Una pelota de 0.6 kg golpea el suelo a 8 m/s y rebota a 6 m/s. ¿Cuál es el impulso impartido?',
      options: ['1.2 N·s', '4.8 N·s', '8.4 N·s', '14 N·s'],
      correctIndex: 2,
    ),
    Question(
      question: 'Un resorte se alarga 0.05 m con una masa de 0.5 kg. ¿Cuál es la constante elástica?',
      options: ['9.8 N/m', '19.6 N/m', '98 N/m', '245 N/m'],
      correctIndex: 2,
    ),
    Question(
      question: 'Un sistema hidráulico aplica 20 N sobre un pistón de 4 cm² y genera 500 N. ¿Área del pistón mayor?',
      options: ['100 cm²', '250 cm²', '400 cm²', '1000 cm²'],
      correctIndex: 0,
    ),
    Question(
      question: 'Un bloque de 0.02 m³ flota en agua con 60% sumergido. ¿Masa del bloque?',
      options: ['12 kg', '20 kg', '1.2 kg', '0.6 kg'],
      correctIndex: 0,
    ),
    Question(
      question: 'Un objeto de 0.1 kg cae desde 5 m con v₀ = 3 m/s. ¿Velocidad justo antes de golpear el suelo?',
      options: ['9.8 m/s', '10.3 m/s', '9.9 m/s', '10.5 m/s'],
      correctIndex: 1,
    ),
  ];

  int _currentQuestionIndex = 0;
  List<int?> _answers = List.filled(10, null);
  int _score = 0;
  bool _submitted = false;

  void _nextQuestion() {
    if (_answers[_currentQuestionIndex] == null) return;
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
    }
  }

  void _submitExam() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctIndex) score++;
    }
    setState(() {
      _score = score;
      _submitted = true;
    });
  }

  void _restartExam() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers = List.filled(_questions.length, null);
      _score = 0;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        appBar: AppBar(title: Text('Resultado del Examen')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text('Puntaje final: $_score / ${_questions.length}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ...List.generate(_questions.length, (index) {
                final question = _questions[index];
                final userAnswer = _answers[index];
                final isCorrect = userAnswer == question.correctIndex;
                return Card(
                  color: isCorrect ? Colors.green[100] : Colors.red[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pregunta ${index + 1}:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                        Text(question.question, style: TextStyle(color: Colors.black)),
                        SizedBox(height: 8),
                        Text('Tu respuesta: ${userAnswer != null ? question.options[userAnswer] : 'No respondida'}',
                            style: TextStyle(color: Colors.black)),
                        Text('Respuesta correcta: ${question.options[question.correctIndex]}',
                            style: TextStyle(color: Colors.black)),
                        if (!isCorrect) Text('✗ Incorrecta', style: TextStyle(color: Colors.red)),
                        if (isCorrect) Text('✓ Correcta', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _restartExam, child: Text('Reiniciar Examen')),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: Text('Examen de Física II')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pregunta ${_currentQuestionIndex + 1}/${_questions.length}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(question.question, style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            ...List.generate(question.options.length, (index) {
              return RadioListTile<int>(
                title: Text(question.options[index]),
                value: index,
                groupValue: _answers[_currentQuestionIndex],
                onChanged: (value) {
                  setState(() {
                    _answers[_currentQuestionIndex] = value;
                  });
                },
              );
            }),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _currentQuestionIndex == _questions.length - 1
                      ? _submitExam
                      : _nextQuestion,
                  child: Text(_currentQuestionIndex == _questions.length - 1 ? 'Enviar' : 'Siguiente'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Fisica3ExamPage extends StatefulWidget {
  @override
  _Fisica3ExamPageState createState() => _Fisica3ExamPageState();
}

class _Fisica3ExamPageState extends State<Fisica3ExamPage> {
  final List<Question> _questions = [
    Question(
      question: 'Dos cargas puntuales idénticas de +2 μC cada una se repelen con una fuerza de 0.9 N. ¿Cuál es la distancia entre ellas?',
      options: ['0.1 m', '0.2 m', '0.3 m', '0.4 m'],
      correctIndex: 1,
    ),
    Question(
      question: 'Una esfera conductora sólida de 5 cm de radio tiene una carga total de +8 nC distribuida uniformemente en su volumen. ¿Cuál es la magnitud del flujo eléctrico a través de una superficie esférica concéntrica de 10 cm de radio?',
      options: ['0 N·m²/C', '904 N·m²/C', '90.4 N·m²/C', '9.04×10⁵ N·m²/C'],
      correctIndex: 1,
    ),
    Question(
      question: 'Se requiere un trabajo de 1.2 J para mover una carga de 4 C desde el punto A al punto B. Si el potencial en el punto A es de 10 V, ¿cuál es el potencial en el punto B?',
      options: ['10.3 V', '9.7 V', '0.3 V', '10.6 V'],
      correctIndex: 0,
    ),
    Question(
      question: 'Tienes un capacitor de 5 μF y otro de 15 μF. Si los conectas en serie y luego a una fuente de 100 V, ¿cuál es la carga total almacenada en el arreglo?',
      options: ['500 μC', '750 μC', '375 μC', '2000 μC'],
      correctIndex: 2,
    ),
    Question(
      question: 'Un electrodoméstico tiene una resistencia de 24 Ω. Si funciona con una corriente de 5 A, ¿cuál es el voltaje al que está conectado?',
      options: ['4.8 V', '240 V', '0.208 V', '120 V'],
      correctIndex: 3,
    ),
    Question(
      question: 'Un motor eléctrico disipa 750 W de potencia cuando una corriente de 6 A lo atraviesa. ¿Cuál es la resistencia del motor?',
      options: ['125 Ω', '20.83 Ω', '20.83 V', '125 A'],
      correctIndex: 1,
    ),
    Question(
      question: 'Un filamento de tungsteno (coeficiente de temperatura α=0.0045 (∘C)-1) tiene una resistencia de 80 Ω a 20∘C. ¿Cuál es su resistencia a 120∘C?',
      options: ['83.6 Ω', '108 Ω', '116 Ω', '91.2 Ω'],
      correctIndex: 3,
    ),
    Question(
      question: 'Una batería con una FEM de 9 V y una resistencia interna de 0.2 Ω entrega una corriente de 3 A a una carga. ¿Cuál es el voltaje terminal de la batería?',
      options: ['9.6 V', '8.4 V', '9.2 V', '8.8 V'],
      correctIndex: 1,
    ),
    Question(
      question: 'El flujo magnético a través de una bobina de 150 espiras cambia de 0.05 Wb a 0.02 Wb en 0.1 s. ¿Cuál es la FEM media inducida en la bobina?',
      options: ['45 V', '-45 V', '-0.45 V', '0.45 V'],
      correctIndex: 0,
    ),
    Question(
      question: 'En un nodo de un circuito, entran 5 A por un cable y 3 A por otro. Si salen 4 A por un tercer cable, ¿cuánta corriente debe salir por un cuarto cable para que se cumpla la Ley de Kirchhoff de los Nodos?',
      options: ['12 A', '4 A', '8 A', '6 A'],
      correctIndex: 1,
    ),
  ];

  int _currentQuestionIndex = 0;
  late List<int?> _answers;
  int _score = 0;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _answers = List.filled(_questions.length, null);
  }

  void _nextQuestion() {
    if (_answers[_currentQuestionIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una respuesta antes de continuar')),
      );
      return;
    }
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
    }
  }

  void _submitExam() {
    if (_answers[_currentQuestionIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una respuesta antes de enviar')),
      );
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
  }

  void _restartExam() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers = List.filled(_questions.length, null);
      _score = 0;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultado del Examen')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                'Puntaje final: $_score / ${_questions.length}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...List.generate(_questions.length, (index) {
                final question = _questions[index];
                final userAnswer = _answers[index];
                final isCorrect = userAnswer == question.correctIndex;
                return Card(
                  color: isCorrect ? Colors.green[100] : Colors.red[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pregunta ${index + 1}:',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(question.question, style: const TextStyle(color: Colors.black)),
                        const SizedBox(height: 8),
                        Text(
                          'Tu respuesta: ${userAnswer != null ? question.options[userAnswer] : 'No respondida'}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Respuesta correcta: ${question.options[question.correctIndex]}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        if (!isCorrect) const Text('✗ Incorrecta', style: TextStyle(color: Colors.red)),
                        if (isCorrect) const Text('✓ Correcta', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _restartExam, child: const Text('Reiniciar Examen')),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: const Text('Examen de Física III')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pregunta ${_currentQuestionIndex + 1} / ${_questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(question.question, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ...List.generate(question.options.length, (index) {
              return RadioListTile<int>(
                title: Text(question.options[index]),
                value: index,
                groupValue: _answers[_currentQuestionIndex],
                onChanged: (value) {
                  setState(() {
                    _answers[_currentQuestionIndex] = value;
                  });
                },
              );
            }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _currentQuestionIndex == _questions.length - 1 ? _submitExam : _nextQuestion,
                  child: Text(_currentQuestionIndex == _questions.length - 1 ? 'Enviar' : 'Siguiente'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class Fisica1ExamPage extends StatefulWidget {
  @override
  _Fisica1ExamPageState createState() => _Fisica1ExamPageState();
}

class _Fisica1ExamPageState extends State<Fisica1ExamPage> {
  final List<Question> _questions = [
  Question(
    question: 'Un cuadro de 5 kg está colgado de un clavo en la pared mediante dos alambres. Cada alambre forma un ángulo de 45∘ con la horizontal. ¿Cuál es la tensión en cada alambre?',
    options: ['24.5 N', '34.6 N', '49 N', '69.3 N'],
    correctIndex: 1,
  ),
  Question(
    question: 'Una barra uniforme de 4 m de longitud y 30 kg de masa está pivoteada en su centro. Una masa de 5 kg se cuelga a 1.5 m a la izquierda del pivote. ¿A qué distancia a la derecha del pivote se debe colgar una masa de 10 kg para que la barra permanezca en equilibrio horizontal?',
    options: ['0.5 m', '0.75 m', '1.0 m', '1.5 m'],
    correctIndex: 1,
  ),
  Question(
    question: 'Determina la coordenada X del centroide de un sistema de dos masas puntuales: m1=4 kg en (2,0) m y m2=6 kg en (5,0) m.',
    options: ['3.2 m', '3.5 m', '3.8 m', '4.0 m'],
    correctIndex: 2,
  ),
  Question(
    question: 'Un tren viaja a una velocidad constante de 108 km/h. ¿Cuánto tiempo (en segundos) tardará en recorrer una distancia de 3600 m?',
    options: ['10 s', '30 s', '60 s', '120 s'],
    correctIndex: 3,
  ),
  Question(
    question: 'Un automóvil parte del reposo y alcanza una velocidad de 72 km/h en 8 s. ¿Cuál es la distancia que recorrió durante ese tiempo?',
    options: ['80 m', '120 m', '160 m', '200 m'],
    correctIndex: 0,
  ),
  Question(
    question: 'Una pelota se deja caer desde la parte superior de un edificio. Si llega al suelo con una velocidad de 29.4 m/s, ¿cuál es la altura del edificio? (Desprecia la resistencia del aire)',
    options: ['14.7 m', '29.4 m', '44.1 m', '58.8 m'],
    correctIndex: 2,
  ),
  Question(
    question: 'Un cohete se lanza verticalmente hacia arriba con una velocidad inicial de 39.2 m/s. ¿Cuál es la altura máxima que alcanza? (Desprecia la resistencia del aire)',
    options: ['39.2 m', '78.4 m', '98 m', '196 m'],
    correctIndex: 1,
  ),
  Question(
    question: 'Una roca se lanza horizontalmente desde un acantilado de 20 m de altura. Si golpea el suelo a una distancia horizontal de 30 m de la base del acantilado, ¿cuál fue su velocidad inicial de lanzamiento?',
    options: ['15 m/s', '20 m/s', '25 m/s', '30 m/s'],
    correctIndex: 0,
  ),
  Question(
    question: 'Una rueda de bicicleta gira a 120 rpm (revoluciones por minuto). Si su radio es de 0.3 m, ¿cuál es la velocidad tangencial de un punto en el borde de la rueda?',
    options: ['3.77 m/s', '7.54 m/s', '18.85 m/s', '37.7 m/s'],
    correctIndex: 0,
  ),
  Question(
    question: 'Un ventilador que inicialmente está en reposo acelera uniformemente hasta alcanzar una velocidad angular de 60 rad/s en 5 s. ¿Cuál es su aceleración angular?',
    options: ['5 rad/s²', '10 rad/s²', '12 rad/s²', '300 rad/s²'],
    correctIndex: 2,
  ),
];


  int _currentQuestionIndex = 0;
  late List<int?> _answers;
  int _score = 0;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _answers = List.filled(_questions.length, null);
  }

  void _nextQuestion() {
    if (_answers[_currentQuestionIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una respuesta antes de continuar')),
      );
      return;
    }
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() => _currentQuestionIndex++);
    }
  }

  void _submitExam() {
    if (_answers[_currentQuestionIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una respuesta antes de enviar')),
      );
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
  }

  void _restartExam() {
    setState(() {
      _currentQuestionIndex = 0;
      _answers = List.filled(_questions.length, null);
      _score = 0;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultado del Examen')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                'Puntaje final: $_score / ${_questions.length}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...List.generate(_questions.length, (index) {
                final question = _questions[index];
                final userAnswer = _answers[index];
                final isCorrect = userAnswer == question.correctIndex;
                return Card(
                  color: isCorrect ? Colors.green[100] : Colors.red[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pregunta ${index + 1}:',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(question.question, style: const TextStyle(color: Colors.black)),
                        const SizedBox(height: 8),
                        Text(
                          'Tu respuesta: ${userAnswer != null ? question.options[userAnswer] : 'No respondida'}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Respuesta correcta: ${question.options[question.correctIndex]}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        if (!isCorrect) const Text('✗ Incorrecta', style: TextStyle(color: Colors.red)),
                        if (isCorrect) const Text('✓ Correcta', style: TextStyle(color: Colors.green)),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _restartExam, child: const Text('Reiniciar Examen')),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: const Text('Examen de Física III')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pregunta ${_currentQuestionIndex + 1} / ${_questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(question.question, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ...List.generate(question.options.length, (index) {
              return RadioListTile<int>(
                title: Text(question.options[index]),
                value: index,
                groupValue: _answers[_currentQuestionIndex],
                onChanged: (value) {
                  setState(() {
                    _answers[_currentQuestionIndex] = value;
                  });
                },
              );
            }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _currentQuestionIndex == _questions.length - 1 ? _submitExam : _nextQuestion,
                  child: Text(_currentQuestionIndex == _questions.length - 1 ? 'Enviar' : 'Siguiente'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
