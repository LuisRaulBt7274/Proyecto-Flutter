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

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Container(
        color: const Color(0xFF1A1A2E),
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
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
          selectedItemColor: const Color(0xFF64B5F6),
          unselectedItemColor: const Color(0xFFB0BEC5),
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

class _HomeContent extends StatelessWidget {
  const _HomeContent();

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
            const Color(0xFF0F1419),
            const Color(0xFF16213E),
            const Color(0xFF1A1A2E),
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

                  // Header
                  Column(
                    children: [
                      // Título principal con gradiente mejorado
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            const Color(0xFF81C784),
                            const Color(0xFF64B5F6),
                            const Color(0xFFBA68C8),
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

                  const SizedBox(height: 40),

                  // Icono principal
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF64B5F6).withOpacity(0.8),
                          const Color(0xFF81C784).withOpacity(0.6),
                          const Color(0xFF1A1A2E).withOpacity(0.4),
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
                          color: const Color(0xFFF5F5F5).withOpacity(0.95),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.atom,
                          size: 65,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Tarjetas de estadísticas
                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF263238),
                          const Color(0xFF37474F),
                          const Color(0xFF455A64),
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
                              const Color(0xFFE0E0E0),
                              const Color(0xFFF5F5F5),
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
                              child: _StatCard(
                                count: '',
                                label: 'EXAMENES',
                                icon: Icons.quiz_outlined,
                                color: const Color(0xFF81C784),
                                page: const ExamenesPage(),
                              ),
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child: _StatCard(
                                count: '',
                                label: 'FLASHCARDS',
                                icon: Icons.style_outlined,
                                color: const Color(0xFF64B5F6),
                                page: const FlashcardsPage(),
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: _StatCard(
                                count: '',
                                label: 'EJERCICIOS',
                                icon: Icons.assignment_outlined,
                                color: const Color(0xFFBA68C8),
                                page: const EjerciciosPage(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF263238).withOpacity(0.8),
                          const Color(0xFF37474F).withOpacity(0.6),
                          const Color(0xFF455A64).withOpacity(0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFF64B5F6).withOpacity(0.3),
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
                          color: const Color(0xFF81C784),
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
                          color: const Color(0xFF64B5F6),
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

class _StatCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF546E7A),
              const Color(0xFF455A64),
              const Color(0xFF37474F),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
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
                    color.withOpacity(0.3),
                    color.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: color,
                size: 26,
              ),
            ),
            const SizedBox(height: 14),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  color,
                  color.withOpacity(0.8),
                ],
              ).createShader(bounds),
              child: Text(
                count,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE0E0E0),
                letterSpacing: 0.6,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF546E7A),
                  const Color(0xFF455A64),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
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
                color: color.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE0E0E0),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
