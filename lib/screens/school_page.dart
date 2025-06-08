import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({super.key});

  @override
  State<SchoolPage> createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> with TickerProviderStateMixin {
  final _supabase = Supabase.instance.client;

  // IDs importantes
  String? _roomId;
  String? _playerId;

  // Suscripciones de tiempo real
  RealtimeChannel? _roomChannel;
  RealtimeChannel? _playersChannel;
  RealtimeChannel? _answersChannel;

  // Controladores de animación (mantener los existentes)
  late AnimationController _mainAnimationController;
  late AnimationController _questionAnimationController;
  late AnimationController _pulseController;
  late AnimationController _countdownController;

  // Animaciones (mantener las existentes)
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _countdownScaleAnimation;

  // Estado del juego
  String _gameState = 'waiting';
  List<Map<String, dynamic>> _players = [];
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _hasAnswered = false;
  Timer? _questionTimer;
  int _timeRemaining = 15;
  DateTime? _questionStartTime;

  // Colores del tema (mantener los existentes)
  static const List<Color> _primaryGradient = [
    Color.fromARGB(255, 87, 113, 230),
    Color(0xFF764ba2),
  ];

  static const List<Color> _successGradient = [
    Color(0xFF11998e),
    Color(0xFF38ef7d),
  ];

  static const List<Color> _errorGradient = [
    Color(0xFFff5f6d),
    Color(0xFFffc371),
  ];

  static const List<Color> _accentGradient = [
    Color(0xFF4facfe),
    Color(0xFF00f2fe),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeGame();
  }

  void _setupAnimations() {
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _questionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _countdownController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: Curves.easeOutBack),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _countdownScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _countdownController, curve: Curves.easeInOut),
    );

    _mainAnimationController.forward();
    _pulseController.repeat(reverse: true);
  }

  Future<void> _initializeGame() async {
    try {
      // Verificar si el usuario está autenticado
      final user = _supabase.auth.currentUser;
      if (user == null) {
        _showSnackBar('Usuario no autenticado. Por favor inicia sesión.', _errorGradient[0]);
        return;
      }

      print('Iniciando juego para usuario: ${user.id}');

      // Crear o unirse a una sala
      await _createOrJoinRoom();

      if (_roomId == null) {
        _showSnackBar('No se pudo crear o unirse a una sala', _errorGradient[0]);
        return;
      }

      print('Sala creada/encontrada: $_roomId');

      // Configurar suscripciones de tiempo real
      _setupRealtimeSubscriptions();

      // Cargar datos iniciales
      await _loadRoomData();

      print('Juego inicializado correctamente');

    } catch (e) {
      print('Error inicializando juego: $e');
      String errorMessage = 'Error al conectar con el servidor';

      // Mensajes de error más específicos
      if (e.toString().contains('JWT')) {
        errorMessage = 'Error de autenticación. Por favor inicia sesión nuevamente.';
      } else if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorMessage = 'Error de conexión. Verifica tu conexión a internet.';
      } else if (e.toString().contains('permission') || e.toString().contains('access')) {
        errorMessage = 'Error de permisos. Contacta al administrador.';
      }

      _showSnackBar(errorMessage, _errorGradient[0]);
    }
  }

  Future<void> _createOrJoinRoom() async {
    try {
      print('Buscando salas disponibles...');

      // Buscar una sala disponible con una consulta más específica
      final response = await _supabase
          .from('game_rooms')
          .select('id, name, status, created_at')
          .eq('status', 'waiting')
          .order('created_at', ascending: false)
          .limit(1);

      print('Respuesta de salas: $response');

      if (response.isNotEmpty) {
        // Verificar cuántos jugadores hay en la sala
        final roomId = response.first['id'];
        final playersCount = await _supabase
            .from('players')
            .select('id')
            .eq('room_id', roomId)
            .eq('is_connected', true);

        print('Jugadores en sala $roomId: ${playersCount.length}');

        if (playersCount.length < 10) {
          // Unirse a sala existente
          _roomId = roomId;
          print('Uniéndose a sala existente: $_roomId');
        } else {
          // Crear nueva sala si la existente está llena
          await _createNewRoom();
        }
      } else {
        // Crear nueva sala
        await _createNewRoom();
      }

      // Unirse como jugador
      await _joinAsPlayer();

    } catch (e) {
      print('Error en _createOrJoinRoom: $e');
      throw e;
    }
  }

  Future<void> _createNewRoom() async {
    try {
      print('Creando nueva sala...');

      final newRoom = await _supabase
          .from('game_rooms')
          .insert({
        'name': 'Sala ${DateTime.now().millisecondsSinceEpoch}',
        'status': 'waiting',
        'created_at': DateTime.now().toIso8601String(),
      })
          .select()
          .single();

      _roomId = newRoom['id'];
      print('Nueva sala creada: $_roomId');

    } catch (e) {
      print('Error creando nueva sala: $e');
      throw e;
    }
  }

  Future<void> _joinAsPlayer() async {
    final user = _supabase.auth.currentUser;
    if (user == null || _roomId == null) {
      throw Exception('Usuario o sala no válidos');
    }

    try {
      print('Uniéndose como jugador a sala: $_roomId');

      // Verificar si el jugador ya existe en esta sala
      final existingPlayer = await _supabase
          .from('players')
          .select('id')
          .eq('user_id', user.id)
          .eq('room_id', _roomId!)
          .maybeSingle();

      if (existingPlayer != null) {
        // Jugador ya existe, actualizar su estado
        _playerId = existingPlayer['id'];
        await _supabase
            .from('players')
            .update({
          'is_connected': true,
          'is_ready': false,
        })
            .eq('id', _playerId!);

        print('Jugador reconectado: $_playerId');
      } else {
        // Crear nuevo jugador
        final playerData = await _supabase
            .from('players')
            .insert({
          'user_id': user.id,
          'room_id': _roomId!,
          'name': user.userMetadata?['name'] ?? 'Jugador ${Random().nextInt(1000)}',
          'is_ready': false,
          'score': 0,
          'is_connected': true,
          'joined_at': DateTime.now().toIso8601String(),
        })
            .select()
            .single();

        _playerId = playerData['id'];
        print('Nuevo jugador creado: $_playerId');
      }

    } catch (e) {
      print('Error uniéndose como jugador: $e');
      throw e;
    }
  }

  void _setupRealtimeSubscriptions() {
    if (_roomId == null) return;

    try {
      print('Configurando suscripciones de tiempo real...');

      // Suscripción a cambios en la sala
      _roomChannel = _supabase
          .channel('room_$_roomId')
          .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'game_rooms',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'id',
          value: _roomId!,
        ),
        callback: _handleRoomChange,
      )
          .subscribe();

      // Suscripción a cambios en jugadores
      _playersChannel = _supabase
          .channel('players_$_roomId')
          .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'players',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'room_id',
          value: _roomId!,
        ),
        callback: _handlePlayersChange,
      )
          .subscribe();

      // Suscripción a respuestas
      _answersChannel = _supabase
          .channel('answers_$_roomId')
          .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'player_answers',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'room_id',
          value: _roomId!,
        ),
        callback: _handleAnswersChange,
      )
          .subscribe();

      print('Suscripciones configuradas correctamente');

    } catch (e) {
      print('Error configurando suscripciones: $e');
      _showSnackBar('Error configurando conexión en tiempo real', _errorGradient[0]);
    }
  }

  void _handleRoomChange(PostgresChangePayload payload) {
    if (!mounted) return;

    try {
      final newData = payload.newRecord;
      if (newData['status'] != _gameState) {
        setState(() {
          _gameState = newData['status'];
          _currentQuestionIndex = newData['current_question_index'] ?? 0;
        });

        // Manejar cambios de estado
        switch (_gameState) {
          case 'ready_check':
            _startCountdown();
            break;
          case 'playing':
            _loadCurrentQuestion();
            break;
          case 'finished':
            _showFinalResults();
            break;
        }
      }

      // Actualizar tiempo de pregunta si cambió
      if (newData['question_start_time'] != null) {
        _questionStartTime = DateTime.parse(newData['question_start_time']);
        _startQuestionTimer();
      }
    } catch (e) {
      print('Error manejando cambio de sala: $e');
    }
  }

  void _handlePlayersChange(PostgresChangePayload payload) {
    if (!mounted) return;
    _loadPlayers();
  }

  void _handleAnswersChange(PostgresChangePayload payload) {
    if (!mounted) return;
    _loadPlayers(); // Recargar para actualizar puntuaciones
  }

  Future<void> _loadRoomData() async {
    try {
      await Future.wait([
        _loadPlayers(),
        _loadQuestions(),
      ]);
    } catch (e) {
      print('Error cargando datos de la sala: $e');
      throw e;
    }
  }

  Future<void> _loadPlayers() async {
    if (_roomId == null) return;

    try {
      final response = await _supabase
          .from('players')
          .select('*')
          .eq('room_id', _roomId!)
          .eq('is_connected', true)
          .order('joined_at');

      if (mounted) {
        setState(() {
          _players = List<Map<String, dynamic>>.from(response);
        });
      }

      _checkAllPlayersReady();

    } catch (e) {
      print('Error cargando jugadores: $e');
      // No lanzar error aquí para no interrumpir el flujo
    }
  }

  Future<void> _loadQuestions() async {
    if (_roomId == null) return;

    try {
      // Intentar cargar preguntas usando RPC
      final response = await _supabase
          .rpc('get_random_questions_for_room', params: {
        'room_uuid': _roomId!,
        'question_count': 10
      });

      if (mounted) {
        setState(() {
          _questions = List<Map<String, dynamic>>.from(response);
        });
      }

    } catch (e) {
      print('Error cargando preguntas con RPC: $e');

      // Fallback: cargar preguntas directamente
      try {
        final fallbackResponse = await _supabase
            .from('questions')
            .select('*')
            .limit(10);

        if (mounted) {
          setState(() {
            _questions = List<Map<String, dynamic>>.from(fallbackResponse);
          });
        }
      } catch (fallbackError) {
        print('Error en fallback de preguntas: $fallbackError');
        _showSnackBar('Error cargando preguntas', _errorGradient[0]);
      }
    }
  }

  Future<void> _loadCurrentQuestion() async {
    if (_questions.isEmpty) {
      await _loadQuestions();
    }
    _startQuestionTimer();
  }

  Future<void> _toggleReady() async {
    if (_playerId == null) return;

    try {
      final currentPlayer = _players.firstWhereOrNull((p) => p['id'] == _playerId);
      if (currentPlayer == null) return;

      final newReadyState = !currentPlayer['is_ready'];

      await _supabase
          .from('players')
          .update({'is_ready': newReadyState})
          .eq('id', _playerId!);

      // Los cambios se reflejarán automáticamente via realtime

    } catch (e) {
      print('Error actualizando estado: $e');
      _showSnackBar('Error al actualizar estado', _errorGradient[0]);
    }
  }

  void _checkAllPlayersReady() {
    if (_players.length < 2) return; // Cambiar a 2 para testing

    final readyPlayers = _players.where((p) => p['is_ready'] == true).length;

    if (readyPlayers >= 2 && _gameState == 'waiting') { // Cambiar a 2 para testing
      _startGameIfEnoughPlayers();
    }
  }

  Future<void> _startGameIfEnoughPlayers() async {
    if (_roomId == null) return;

    try {
      await _supabase
          .from('game_rooms')
          .update({
        'status': 'ready_check',
        'started_at': DateTime.now().toIso8601String(),
      })
          .eq('id', _roomId!);

    } catch (e) {
      print('Error iniciando juego: $e');
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

  Future<void> _startGame() async {
    if (_roomId == null) return;

    try {
      await _supabase
          .from('game_rooms')
          .update({
        'status': 'playing',
        'current_question_index': 0,
        'question_start_time': DateTime.now().toIso8601String(),
      })
          .eq('id', _roomId!);

    } catch (e) {
      print('Error iniciando juego: $e');
    }
  }

  void _startQuestionTimer() {
    if (_questionStartTime == null) return;

    _questionTimer?.cancel();
    _questionAnimationController.reset();
    _questionAnimationController.forward();

    // Reset answer state for new question
    setState(() {
      _hasAnswered = false;
      _selectedAnswer = null;
    });

    _questionTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final elapsed = DateTime.now().difference(_questionStartTime!).inSeconds;
      final remaining = 15 - elapsed;

      if (remaining > 0) {
        setState(() {
          _timeRemaining = remaining;
        });

        if (remaining <= 3) {
          _countdownController.forward().then((_) {
            _countdownController.reverse();
          });
        }
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
    if (_hasAnswered || _playerId == null || _roomId == null) return;

    setState(() {
      _hasAnswered = true;
    });

    _questionTimer?.cancel();

    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      print('No hay pregunta actual válida');
      return;
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = answer == currentQuestion['correct_answer'];
    final timeToAnswer = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inSeconds
        : 15;

    try {
      // Calcular puntos usando la función de la base de datos
      int points = 0;
      try {
        final scoreResponse = await _supabase
            .rpc('calculate_score', params: {
          'time_remaining': _timeRemaining,
          'is_correct': isCorrect
        });

        points = scoreResponse as int;
      } catch (scoreError) {
        print('Error calculando puntos, usando fallback: $scoreError');
        // Fallback: calcular puntos localmente
        points = isCorrect ? (100 + _timeRemaining * 10) : 0;
      }

      // Guardar respuesta
      await _supabase
          .from('player_answers')
          .insert({
        'player_id': _playerId!,
        'room_id': _roomId!,
        'question_id': currentQuestion['id'] ?? currentQuestion['question_id'],
        'selected_answer': answer,
        'is_correct': isCorrect,
        'points_earned': points,
        'answer_time': timeToAnswer,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Actualizar puntuación del jugador
      final currentScore = _players.firstWhereOrNull((p) => p['id'] == _playerId)?['score'] ?? 0;
      await _supabase
          .from('players')
          .update({'score': currentScore + points})
          .eq('id', _playerId!);

      // Mostrar resultado
      await _showAnswerResult(isCorrect, points);

      // El host avanza a la siguiente pregunta
      if (_isHost()) {
        await _nextQuestion();
      }

    } catch (e) {
      print('Error enviando respuesta: $e');
      _showSnackBar('Error al enviar respuesta', _errorGradient[0]);
    }
  }

  bool _isHost() {
    if (_players.isEmpty) return false;
    final sortedPlayers = List<Map<String, dynamic>>.from(_players);
    sortedPlayers.sort((a, b) => a['joined_at'].compareTo(b['joined_at']));
    return sortedPlayers.first['id'] == _playerId;
  }

  Future<void> _nextQuestion() async {
    if (_roomId == null) return;

    try {
      if (_currentQuestionIndex < _questions.length - 1) {
        await _supabase
            .from('game_rooms')
            .update({
          'current_question_index': _currentQuestionIndex + 1,
          'question_start_time': DateTime.now().add(Duration(seconds: 3)).toIso8601String(),
        })
            .eq('id', _roomId!);
      } else {
        await _supabase
            .from('game_rooms')
            .update({
          'status': 'finished',
          'finished_at': DateTime.now().toIso8601String(),
        })
            .eq('id', _roomId!);
      }
    } catch (e) {
      print('Error avanzando pregunta: $e');
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
                // Mostrar código de sala
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Se necesitan mínimo 2 jugadores para comenzar', // Cambiar para testing
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _players.length,
                            itemBuilder: (context, index) {
                              final player = _players[index];
                              final isCurrentPlayer = player['id'] == _playerId;
                              final isReady = player['is_ready'] ?? false;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isCurrentPlayer
                                        ? _accentGradient
                                        : [Colors.grey.shade50, Colors.grey.shade100],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isReady ? Colors.green : Colors.grey.shade300,
                                    width: isReady ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: isCurrentPlayer
                                          ? Colors.white
                                          : _primaryGradient[0],
                                      child: Text(
                                        (player['name'] ?? 'J')[0].toUpperCase(),
                                        style: TextStyle(
                                          color: isCurrentPlayer
                                              ? _primaryGradient[0]
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            player['name'] ?? 'Jugador',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isCurrentPlayer
                                                  ? Colors.white
                                                  : const Color(0xFF2D3748),
                                            ),
                                          ),
                                          Text(
                                            isCurrentPlayer ? 'Tú' : 'Jugador',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isCurrentPlayer
                                                  ? Colors.white70
                                                  : Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isReady ? Colors.green : Colors.orange,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        isReady ? 'LISTO' : 'ESPERANDO',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botón de listo
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    final currentPlayer = _players.firstWhereOrNull((p) => p['id'] == _playerId);
                    final isReady = currentPlayer?['is_ready'] ?? false;

                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isReady ? _successGradient : _primaryGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: (isReady ? _successGradient[0] : _primaryGradient[0])
                                  .withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _toggleReady,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            isReady ? '✓ ESTOY LISTO' : 'MARCAR COMO LISTO',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionScreen() {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      return const Center(child: CircularProgressIndicator());
    }

    final question = _questions[_currentQuestionIndex];
    final options = List<String>.from(question['options']);

    return Column(
      children: [
        _buildHeader(
          'PREGUNTA ${_currentQuestionIndex + 1}',
          'de ${_questions.length}',
        ),

        // Timer circular
        Container(
          padding: const EdgeInsets.all(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: _timeRemaining / 15,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _timeRemaining > 5 ? Colors.green : Colors.red,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _countdownScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _timeRemaining <= 3 ? _countdownScaleAnimation.value : 1.0,
                    child: Text(
                      '$_timeRemaining',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _timeRemaining > 5 ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Pregunta
                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
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
                          child: Text(
                            question['question_text'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Opciones
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = _selectedAnswer == option;
                      final colors = [
                        [const Color(0xFFe74c3c), const Color(0xFFc0392b)], // Rojo
                        [const Color(0xFF3498db), const Color(0xFF2980b9)], // Azul
                        [const Color(0xFFf39c12), const Color(0xFFe67e22)], // Naranja
                        [const Color(0xFF27ae60), const Color(0xFF229954)], // Verde
                      ];

                      return AnimatedBuilder(
                        animation: _questionAnimationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _questionAnimationController.value,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: colors[index % colors.length],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                border: isSelected
                                    ? Border.all(color: Colors.white, width: 3)
                                    : null,
                                boxShadow: [
                                  BoxShadow(
                                    color: colors[index % colors.length][0].withOpacity(0.3),
                                    blurRadius: isSelected ? 20 : 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _hasAnswered ? null : () => _selectAnswer(option),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        },
                      );
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

  Widget _buildResultsScreen() {
    // Ordenar jugadores por puntuación
    final sortedPlayers = List<Map<String, dynamic>>.from(_players);
    sortedPlayers.sort((a, b) => (b['score'] ?? 0).compareTo(a['score'] ?? 0));

    return Column(
      children: [
        _buildHeader('RESULTADOS', 'Puntuaciones finales'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Podio
                if (sortedPlayers.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          size: 40,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '🏆 ${sortedPlayers.first['name']}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${sortedPlayers.first['score']} puntos',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Lista completa de resultados
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedPlayers.length,
                    itemBuilder: (context, index) {
                      final player = sortedPlayers[index];
                      final isCurrentPlayer = player['id'] == _playerId;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isCurrentPlayer
                                ? _accentGradient
                                : [Colors.white, Colors.grey.shade50],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: _getRankColor(index),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    player['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: isCurrentPlayer
                                          ? Colors.white
                                          : const Color(0xFF2D3748),
                                    ),
                                  ),
                                  if (isCurrentPlayer)
                                    Text(
                                      'Tú',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              '${player['score']} pts',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: isCurrentPlayer
                                    ? Colors.white
                                    : _primaryGradient[0],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Botón para jugar de nuevo
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: _primaryGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: _playAgain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'JUGAR DE NUEVO',
                      style: TextStyle(
                        fontSize: 18,
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
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: _primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
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
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_gameState) {
      case 'waiting':
      case 'ready_check':
        return _buildWaitingScreen();
      case 'playing':
        return _buildQuestionScreen();
      case 'finished':
        return _buildResultsScreen();
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // Oro
      case 1:
        return const Color(0xFFC0C0C0); // Plata
      case 2:
        return const Color(0xFFCD7F32); // Bronce
      default:
        return Colors.grey;
    }
  }

  Future<void> _showAnswerResult(bool isCorrect, int points) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isCorrect ? _successGradient : _errorGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                size: 60,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                isCorrect ? '¡CORRECTO!' : '¡INCORRECTO!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isCorrect ? '+$points puntos' : '0 puntos',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Cerrar el diálogo después de 2 segundos
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showCountdownOverlay(int countdown) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: _primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$countdown',
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void _showFinalResults() {
    setState(() {
      _gameState = 'finished';
    });
  }

  Future<void> _playAgain() async {
    // Reiniciar el juego
    await _initializeGame();
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFC), Color(0xFFEDF2F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildCurrentScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _questionAnimationController.dispose();
    _pulseController.dispose();
    _countdownController.dispose();
    _questionTimer?.cancel();

    // Cancelar suscripciones de tiempo real
    _roomChannel?.unsubscribe();
    _playersChannel?.unsubscribe();
    _answersChannel?.unsubscribe();

    // Marcar jugador como desconectado
    if (_playerId != null) {
      _supabase
          .from('players')
          .update({'is_connected': false})
          .eq('id', _playerId!);
    }

    super.dispose();
  }
}

// Extensión helper para firstWhereOrNull
extension ListExtensions<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (T element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}