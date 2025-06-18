import 'package:flutter/material.dart';
import 'ia_page.dart';
import 'school_page.dart';
import 'chat_page.dart';
import 'profile_page.dart';
import 'examenes_page.dart';
import 'ejercicios_page.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'help_page.dart';
import 'flashcards_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Envuelve cada página en un Builder para manejar errores
  final List<Widget> _pages = [
    Builder(
      builder: (context) {
        try {
          return const _HomeContent();
        } catch (e) {
          return Container(
            color: const Color(0xFF1A1A2E),
            child: const Center(
              child: Text(
                'Error cargando inicio',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
    ),
    Builder(
      builder: (context) {
        try {
          return const SimpleChatScreen();
        } catch (e) {
          return Container(
            color: const Color(0xFF1A1A2E),
            child: const Center(
              child: Text(
                'Error cargando chat',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
    ),
    Builder(
      builder: (context) {
        try {
          return const SchoolPage();
        } catch (e) {
          return Container(
            color: const Color(0xFF1A1A2E),
            child: const Center(
              child: Text(
                'Error cargando temas',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
    ),
    Builder(
      builder: (context) {
        try {
          return const UsersTab();
        } catch (e) {
          return Container(
            color: const Color(0xFF1A1A2E),
            child: const Center(
              child: Text(
                'Error cargando perfil',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
      // Reinicia la animación más suavemente
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // Fondo oscuro principal
      body: Container(
        color: const Color(0xFF1A1A2E), // Fondo adicional para evitar pantallazos
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF16213E),
              const Color(0xFF16213E).withOpacity(0.95),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF64B5F6), // Azul claro para seleccionado
          unselectedItemColor: const Color(0xFFB0BEC5), // Gris claro para no seleccionado
          selectedFontSize: 12,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none),
              activeIcon: Icon(Icons.notifications),
              label: 'Chat Grupal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Temas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
    ));

    _animationController.forward();
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0F1419), // Azul muy oscuro arriba
            const Color(0xFF16213E), // Azul oscuro medio
            const Color(0xFF1A1A2E), // Azul oscuro abajo
          ],
        ),
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height - kBottomNavigationBarHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Header animado
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - _fadeAnimation.value)),
                          child: Column(
                            children: [
                              // Título principal con gradiente mejorado
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    const Color(0xFF81C784), // Verde claro
                                    const Color(0xFF64B5F6), // Azul claro
                                    const Color(0xFFBA68C8), // Púrpura claro
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ).createShader(bounds),
                                child: const Text(
                                  'FISICA',
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 3,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 10,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Icono principal animado con múltiples efectos
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _pulseAnimation,
                        child: RotationTransition(
                          turns: _rotationAnimation,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF64B5F6).withOpacity(0.8), // Azul claro centro
                                  const Color(0xFF81C784).withOpacity(0.6), // Verde claro medio
                                  const Color(0xFF1A1A2E).withOpacity(0.4), // Oscuro borde
                                ],
                                stops: const [0.2, 0.6, 1.0],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF64B5F6).withOpacity(0.5),
                                  blurRadius: 25,
                                  offset: const Offset(0, 12),
                                  spreadRadius: 3,
                                ),
                                BoxShadow(
                                  color: const Color(0xFF81C784).withOpacity(0.3),
                                  blurRadius: 40,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5).withOpacity(0.95), // Blanco muy claro
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  LucideIcons.atom,
                                  size: 65,
                                  color: const Color(0xFF1A1A2E), // Oscuro para contraste
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Tarjetas de estadísticas
                  SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(26),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF263238), // Gris azulado oscuro
                                const Color(0xFF37474F), // Gris azulado medio
                                const Color(0xFF455A64), // Gris azulado claro
                              ],
                            ),
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 25,
                                offset: const Offset(0, 12),
                                spreadRadius: 2,
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    const Color(0xFFE0E0E0), // Gris muy claro
                                    const Color(0xFFF5F5F5), // Blanco casi puro
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Tu Progreso',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 26),

                              Row(
                                children: [
                                  Expanded(
                                    child: AnimatedBuilder(
                                      animation: _animationController,
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(
                                            0,
                                            30 * (1 - _scaleAnimation.value),
                                          ),
                                          child: Opacity(
                                            opacity: _scaleAnimation.value,
                                            child: _StatCard(
                                              count: '',
                                              label: 'EXAMENES',
                                              icon: Icons.quiz_outlined,
                                              color: const Color(0xFF81C784), // Verde claro
                                              page: const ExamenesPage(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 18),

                                  Expanded(
                                    child: _StatCard(
                                      count: '',
                                      label: 'FLASHCARDS',
                                      icon: Icons.style_outlined,
                                      color: const Color(0xFF64B5F6), // Azul claro
                                      page: const FlashcardsPage(),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: AnimatedBuilder(
                                      animation: _animationController,
                                      builder: (context, child) {
                                        return Transform.translate(
                                          offset: Offset(
                                            0,
                                            30 * (1 - _scaleAnimation.value),
                                          ),
                                          child: Opacity(
                                            opacity: _scaleAnimation.value,
                                            child: _StatCard(
                                              count: '',
                                              label: 'EJERCICIOS',
                                              icon: Icons.assignment_outlined,
                                              color: const Color(0xFFBA68C8), // Púrpura claro
                                              page: const EjerciciosPage(),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - _scaleAnimation.value)),
                            child: Opacity(
                              opacity: _scaleAnimation.value,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(22),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF263238).withOpacity(0.8), // Gris azulado oscuro
                                      const Color(0xFF37474F).withOpacity(0.6), // Gris azulado medio
                                      const Color(0xFF455A64).withOpacity(0.4), // Gris azulado claro
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                    color: const Color(0xFF64B5F6).withOpacity(0.3), // Borde azul claro
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _QuickAction(
                                      icon: LucideIcons.bot,
                                      label: 'Asistente AI',
                                      color: const Color(0xFF81C784), // Verde claro
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const ChatPage()),
                                        );
                                      },
                                    ),

                                    _QuickAction(
                                      icon: Icons.help_outline,
                                      label: 'Ayuda',
                                      color: const Color(0xFF64B5F6), // Azul claro
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const HelpPage()),
                                        );
                                      },
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

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  final String count;
  final String label;
  final IconData icon;
  final Color color;
  final Widget page;

  const _StatCard({
    required this.count,
    required this.label,
    required this.icon,
    required this.color,
    required this.page,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _hoverController.forward(),
      onTapUp: (_) => _hoverController.reverse(),
      onTapCancel: () => _hoverController.reverse(),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => widget.page),
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF546E7A), // Gris azulado claro
                    const Color(0xFF455A64), // Gris azulado medio
                    const Color(0xFF37474F), // Gris azulado oscuro
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: widget.color.withOpacity(0.5), // Borde más visible
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(_glowAnimation.value),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          widget.color.withOpacity(0.3),
                          widget.color.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        widget.color,
                        widget.color.withOpacity(0.8),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      widget.count,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE0E0E0), // Gris muy claro para legibilidad
                      letterSpacing: 0.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction> with SingleTickerProviderStateMixin {
  late AnimationController _tapController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _tapController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _tapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _tapController.forward(),
      onTapUp: (_) => _tapController.reverse(),
      onTapCancel: () => _tapController.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF546E7A), // Gris azulado claro
                        const Color(0xFF455A64), // Gris azulado medio
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: widget.color.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE0E0E0), // Gris muy claro para legibilidad
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}