import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({super.key});

  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  final _supabase = Supabase.instance.client;

  // Estado del juego
  String _gameState = 'waiting'; // waiting, ready_check, playing, finished, results
  List<Map<String, dynamic>> _players = [];
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _hasAnswered = false;
  Timer? _questionTimer;
  int _timeRemaining = 15;
  Map<String, dynamic> _currentScores = {};

  // Colores del tema
  static const List<Color> _primaryGradient = [
    Color.fromRGBO(144, 233, 255, 1),
    Color.fromARGB(255, 104, 1, 99),
  ];

  static const List<Color> _successGradient = [
    Color.fromARGB(255, 16, 199, 184),
    Color(0xFF38ef7d),
  ];

  static const List<Color> _errorGradient = [
    Color.fromARGB(255, 255, 0, 21),
    Color.fromARGB(255, 248, 50, 0),
  ];

  static const List<Color> _accentGradient = [
    Color.fromARGB(255, 175, 14, 238),
    Color.fromARGB(255, 14, 236, 81)];

  // Preguntas predefinidas
  final List<Map<String, dynamic>> _defaultQuestions = [
    {
      'pregunta': '¿Cuál es la unidad básica de masa en el Sistema Internacional?',
      'opciones': ['Gramo', 'Libra', 'Kilogramo', 'Newton'],
      'respuesta_correcta': 'Kilogramo'
    },
    {
      'pregunta': '¿Qué ley física establece que F = m·a?',
      'opciones': ['Ley de Ohm', 'Ley de Hooke', 'Segunda ley de Newton', 'Ley de Faraday'],
      'respuesta_correcta': 'Segunda ley de Newton'
    },
    {
      'pregunta': '¿Qué rama de la física estudia los cuerpos en equilibrio?',
      'opciones': ['Dinámica', 'Cinemática', 'Estática', 'Termodinámica'],
      'respuesta_correcta': 'Estática'
    },
    {
      'pregunta': '¿Qué propiedad del sonido está relacionada con su frecuencia?',
      'opciones': ['Intensidad', 'Tono', 'Timbre', 'Amplitud'],
      'respuesta_correcta': 'Tono'
    },
    {
      'pregunta': '¿Qué mide la unidad llamada Amperio?',
      'opciones': ['Resistencia eléctrica', 'Tensión eléctrica', 'Intensidad de corriente', 'Potencia eléctrica'],
      'respuesta_correcta': 'Intensidad de corriente'
    },
    {
      'pregunta': '¿Qué fenómeno describe la ley de Faraday?',
      'opciones': ['Reflexión de la luz', 'Inducción electromagnética', 'Conducción eléctrica', 'Polarización de ondas'],
      'respuesta_correcta': 'Inducción electromagnética'
    },
    {
      'pregunta': '¿Qué tipo de ondas son las de radio?',
      'opciones': ['Ondas mecánicas', 'Ondas sonoras', 'Ondas electromagnéticas', 'Ondas de presión'],
      'respuesta_correcta': 'Ondas electromagnéticas'
    },
    {
      'pregunta': '¿Qué fenómeno óptico explica el arcoíris?',
      'opciones': ['Reflexión', 'Difracción', 'Dispersión', 'Polarización'],
      'respuesta_correcta': 'Dispersión'
    },
    {
      'pregunta': '¿Qué instrumento mide la diferencia de potencial eléctrico?',
      'opciones': ['Amperímetro', 'Ohmímetro', 'Voltímetro', 'Galvanómetro'],
      'respuesta_correcta': 'Voltímetro'
    },
    {
      'pregunta': '¿Qué magnitud física se mide en Pascales?',
      'opciones': ['Fuerza', 'Presión', 'Energía', 'Potencia'],
      'respuesta_correcta': 'Presión'
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _listenToGameUpdates();
  }

  Future<void> _initializeGame() async {
    // Simular inicialización del juego
    _questions = List.from(_defaultQuestions)..shuffle();
    _questions = _questions.take(10).toList();

    // Simular algunos jugadores
    _players = [
      {
        'id': _supabase.auth.currentUser?.id ?? 'player1',
        'nombre': 'Tú',
        'listo': false,
        'puntuacion': 0,
        'estado': 'conectado'
      },
      {
        'id': 'player2',
        'nombre': 'Mel',
        'listo': true,
        'puntuacion': 0,
        'estado': 'conectado'
      },
      {
        'id': 'player3',
        'nombre': 'Fer',
        'listo': true,
        'puntuacion': 0,
        'estado': 'conectado'
      }
    ];

    setState(() {});
  }

  void _listenToGameUpdates() {
    // Aquí iría la lógica para escuchar cambios en tiempo real de Supabase
    // Por ahora simularemos con timers locales
  }

  Future<void> _joinGame() async {
    // Lógica para unirse al juego
    _showSnackBar('Te has unido al juego', _successGradient[0]);
  }

  Future<void> _toggleReady() async {
    final currentPlayer = _players.firstWhere(
          (p) => p['id'] == (_supabase.auth.currentUser?.id ?? 'player1'),
    );

    setState(() {
      currentPlayer['listo'] = !currentPlayer['listo'];
    });

    // Simular que otros jugadores también se marcan como listos
    if (currentPlayer['listo']) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            for (var player in _players) {
              if (player['id'] != currentPlayer['id']) {
                player['listo'] = true;
              }
            }
          });
          _checkAllPlayersReady();
        }
      });
    }
  }

  void _checkAllPlayersReady() {
    final allReady = _players.every((player) => player['listo'] == true);
    if (allReady && _gameState == 'waiting') {
      setState(() {
        _gameState = 'ready_check';
      });
      _startCountdown();
    }
  }

  void _startCountdown() {
    int countdown = 3;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        _showCountdownOverlay(countdown);
        countdown--;
      } else {
        timer.cancel();
        _startGame();
      }
    });
  }

  void _showCountdownOverlay(int number) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _accentGradient),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _accentGradient[0].withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 90, 9, 9),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  void _startGame() {
    setState(() {
      _gameState = 'playing';
      _currentQuestionIndex = 0;
      _hasAnswered = false;
      _selectedAnswer = null;
    });
    _startQuestionTimer();
  }

  void _startQuestionTimer() {
    _timeRemaining = 15;
    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        timer.cancel();
        if (!_hasAnswered) {
          _submitAnswer(null);
        }
      }
    });
  }

  void _selectAnswer(String answer) {
    if (_hasAnswered) return;

    setState(() {
      _selectedAnswer = answer;
    });
    _submitAnswer(answer);
  }

  Future<void> _submitAnswer(String? answer) async {
    if (_hasAnswered) return;

    setState(() {
      _hasAnswered = true;
    });

    _questionTimer?.cancel();

    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = answer == currentQuestion['respuesta_correcta'];

    // Calcular puntuación basada en tiempo restante
    int points = 0;
    if (isCorrect) {
      points = ((_timeRemaining / 15) * 1000).round() + 100;
    }

    // Actualizar puntuación del jugador actual
    final currentPlayer = _players.firstWhere(
          (p) => p['id'] == (_supabase.auth.currentUser?.id ?? 'player1'),
    );
    currentPlayer['puntuacion'] += points;

    // Simular respuestas de otros jugadores
    _simulateOtherPlayersAnswers();

    // Mostrar resultado
    await _showAnswerResult(isCorrect, points);

    // Continuar al siguiente pregunta o mostrar resultados finales
    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestionIndex < _questions.length - 1) {
        _nextQuestion();
      } else {
        _showFinalResults();
      }
    });
  }

  void _simulateOtherPlayersAnswers() {
    final random = Random();
    for (var player in _players) {
      if (player['id'] != (_supabase.auth.currentUser?.id ?? 'player1')) {
        // 70% de probabilidad de respuesta correcta
        final isCorrect = random.nextBool() && random.nextBool() && random.nextBool();
        final basePoints = isCorrect ? random.nextInt(800) + 200 : 0;
        player['puntuacion'] += basePoints;
      }
    }
  }

  Future<void> _showAnswerResult(bool isCorrect, int points) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Material(
        color: Colors.black54,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCorrect ? _successGradient : _errorGradient,
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: (isCorrect ? _successGradient[0] : _errorGradient[0])
                      .withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  isCorrect ? '¡Correcto!' : '¡Incorrecto!',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (points > 0) ...[
                  const SizedBox(height: 10),
                  Text(
                    '+$points puntos',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (!isCorrect) ...[
                  const SizedBox(height: 15),
                  Text(
                    'Respuesta correcta: ${_questions[_currentQuestionIndex]['respuesta_correcta']}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _hasAnswered = false;
      _selectedAnswer = null;
    });
    _startQuestionTimer();
  }

  void _showFinalResults() {
    setState(() {
      _gameState = 'results';
    });

    // Ordenar jugadores por puntuación
    _players.sort((a, b) => b['puntuacion'].compareTo(a['puntuacion']));
  }

  void _resetGame() {
    setState(() {
      _gameState = 'waiting';
      _currentQuestionIndex = 0;
      _hasAnswered = false;
      _selectedAnswer = null;

      for (var player in _players) {
        player['listo'] = false;
        player['puntuacion'] = 0;
      }
    });

    _questions.shuffle();
    _questionTimer?.cancel();
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
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
              _primaryGradient[0].withOpacity(0.1),
              _accentGradient[1].withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: _buildCurrentScreen(),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_gameState) {
      case 'waiting':
        return _buildWaitingScreen();
      case 'ready_check':
        return _buildReadyCheckScreen();
      case 'playing':
        return _buildGameScreen();
      case 'results':
        return _buildResultsScreen();
      default:
        return _buildWaitingScreen();
    }
  }

  Widget _buildWaitingScreen() {
    return Column(
      children: [
        _buildHeader('MINI KAHOOT', 'Sala de espera'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Lista de jugadores
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jugadores (${_players.length})',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _players.length,
                            itemBuilder: (context, index) {
                              final player = _players[index];
                              return _buildPlayerCard(player);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botón de listo
                _buildActionButton(
                  text: _players.firstWhere(
                        (p) => p['id'] == (_supabase.auth.currentUser?.id ?? 'player1'),
                  )['listo'] ? 'Cancelar' : 'Estoy Listo!',
                  gradient: _players.firstWhere(
                        (p) => p['id'] == (_supabase.auth.currentUser?.id ?? 'player1'),
                  )['listo'] ? _errorGradient : _successGradient,
                  onPressed: _toggleReady,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadyCheckScreen() {
    return Column(
      children: [
        _buildHeader('MINI KAHOOT', 'Todos listos!'),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _accentGradient),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _accentGradient[0].withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.rocket_launch,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'El juego comenzará pronto...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '10 preguntas te esperan',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameScreen() {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      return const Center(child: CircularProgressIndicator());
    }

    final question = _questions[_currentQuestionIndex];

    return Column(
      children: [
        _buildGameHeader(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Pregunta
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _primaryGradient),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryGradient[0].withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    question['pregunta'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                // Opciones
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 2,
                    ),
                    itemCount: question['opciones'].length,
                    itemBuilder: (context, index) {
                      final option = question['opciones'][index];
                      final colors = [_accentGradient, _successGradient, _errorGradient, _primaryGradient];
                      final gradient = colors[index % colors.length];
                      return _buildAnswerOption(option, gradient, index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerOption(String option, List<Color> gradient, int index) {
    final isSelected = _selectedAnswer == option;

    return GestureDetector(
      onTap: () => _selectAnswer(option),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: gradient)
              : LinearGradient(colors: gradient.map((c) => c.withOpacity(0.2)).toList()),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? gradient[0] : gradient[0].withOpacity(0.3),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ] : null,
        ),
        child: Center(
          child: Text(
            option,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : gradient[0],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildGameHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _primaryGradient),
        boxShadow: [
          BoxShadow(
            color: _primaryGradient[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pregunta ${_currentQuestionIndex + 1}/10',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: _timeRemaining <= 5 ? Colors.red : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_timeRemaining s',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / 10,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen() {
    return Column(
      children: [
        _buildHeader('RESULTADOS', 'Juego terminado'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Podium del ganador
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _successGradient),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _successGradient[0].withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        size: 60,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '🏆 ${_players.first['nombre']}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${_players.first['puntuacion']} puntos',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Lista de resultados
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Clasificación Final',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _players.length,
                            itemBuilder: (context, index) {
                              final player = _players[index];
                              return _buildResultCard(player, index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botón de jugar otra vez
                _buildActionButton(
                  text: 'Jugar Otra Vez',
                  gradient: _accentGradient,
                  onPressed: _resetGame,
                ),

                const SizedBox(height: 10),

                // Botón de salir
                _buildActionButton(
                  text: 'Salir',
                  gradient: _errorGradient,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _primaryGradient),
        boxShadow: [
          BoxShadow(
            color: _primaryGradient[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> player) {
    final isCurrentPlayer = player['id'] == (_supabase.auth.currentUser?.id ?? 'player1');
    final isReady = player['listo'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isCurrentPlayer
            ? LinearGradient(colors: _accentGradient.map((c) => c.withOpacity(0.1)).toList())
            : null,
        color: isCurrentPlayer ? null : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isCurrentPlayer ? _accentGradient[0] : Colors.grey.shade300,
          width: isCurrentPlayer ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isReady ? _successGradient[0] : Colors.grey.shade400,
            child: Text(
              player['nombre'][0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player['nombre'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCurrentPlayer ? _accentGradient[0] : Colors.black87,
                  ),
                ),
                Text(
                  player['estado'] ?? 'Conectado',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isReady ? _successGradient[0] : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isReady ? 'Listo' : 'Esperando',
              style: TextStyle(
                fontSize: 12,
                color: isReady ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> player, int position) {
    final isCurrentPlayer = player['id'] == (_supabase.auth.currentUser?.id ?? 'player1');
    final medal = position == 0 ? '🏆' : position == 1 ? '🥈' : position == 2 ? '🥉' : '${position + 1}°';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isCurrentPlayer
            ? LinearGradient(colors: _accentGradient.map((c) => c.withOpacity(0.1)).toList())
            : null,
        color: isCurrentPlayer ? null : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isCurrentPlayer ? _accentGradient[0] : Colors.grey.shade300,
          width: isCurrentPlayer ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: position < 3 ? _successGradient[0] : Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                medal,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player['nombre'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCurrentPlayer ? _accentGradient[0] : Colors.black87,
                  ),
                ),
                Text(
                  'Posición ${position + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _primaryGradient),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${player['puntuacion']} pts',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required List<Color> gradient,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          shadowColor: gradient[0].withOpacity(0.3),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _questionTimer?.cancel();
    super.dispose();
  }
}
