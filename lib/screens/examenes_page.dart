import 'package:flutter/material.dart';

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
              // Header personalizado
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
              // Grid de tarjetas
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
                            () => Navigator.push(context, _createRoute(ExamPage())),
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

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;

  Question({required this.question, required this.options, required this.correctIndex});
}

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> with TickerProviderStateMixin {
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
  late AnimationController _progressController;
  late AnimationController _slideController;
  late Animation<double> _progressAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
            Icon(Icons.info_outline, color: Colors.white),
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
              // Header con progreso
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
                            'Examen de Electromagnetismo',
                            style: TextStyle(
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
              // Contenido del examen
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

        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header de resultados
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
              // Lista de resultados
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
                      // Botones de acción
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

// Clases de páginas faltantes para evitar errores
class Fisica1ExamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ExamPage(); // Reutiliza la misma página de examen
  }
}

class Fisica2ExamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ExamPage(); // Reutiliza la misma página de examen
  }
}

class Fisica3ExamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ExamPage(); // Reutiliza la misma página de examen
  }
}