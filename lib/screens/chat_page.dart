import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class SimpleChatScreen extends StatefulWidget {
  const SimpleChatScreen({super.key});

  @override
  State<SimpleChatScreen> createState() => _SimpleChatScreenState();
}

class _SimpleChatScreenState extends State<SimpleChatScreen>
    with TickerProviderStateMixin {
  final _supabase = Supabase.instance.client;
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();

  late AnimationController _animationController;
  late AnimationController _sendButtonController;
  late AnimationController _messageBubbleController;
  late AnimationController _headerController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _sendButtonScaleAnimation;
  late Animation<double> _headerSlideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;

  bool _isLoading = false;
  bool _isUploadingImage = false;
  final bool _isConnected = true;

  // Gradientes y colores vibrantes
  static const List<Color> _primaryGradient = [
    Color(0xFF667eea),
    Color(0xFF764ba2),
  ];

  static const List<Color> _secondaryGradient = [
    Color(0xFFf093fb),
    Color(0xFFf5576c),
  ];

  static const List<Color> _accentGradient = [
    Color(0xFF4facfe),
    Color(0xFF00f2fe),
  ];

  // Stream en tiempo real
  Stream<List<Map<String, dynamic>>> get _messageStream => _supabase
      .from('mensajes')
      .select('id, contenido, creado_en, autor_id, tipo_mensaje, imagen_url, profiles(nombre)')
      .order('creado_en')
      .asStream();

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _scrollToBottom();
  }

  void _setupAnimations() {
    // Controlador principal
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Controlador del botón de envío
    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Controlador de burbujas de mensaje
    _messageBubbleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Controlador del header
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Controlador de pulso
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Animaciones
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _sendButtonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _sendButtonController,
      curve: Curves.easeInOut,
    ));

    _headerSlideAnimation = Tween<double>(
      begin: -100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.bounceOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: _primaryGradient[0],
      end: _secondaryGradient[0],
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Iniciar animaciones
    _animationController.forward();
    _headerController.forward();
    _pulseController.repeat(reverse: true);
  }

  // Enviar mensaje de texto con animación mejorada
  Future<void> _sendTextMessage() async {
    if (_msgController.text.trim().isEmpty || _isLoading) return;

    final content = _msgController.text.trim();
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      _showSnackBar('Usuario no autenticado', Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _supabase.from('mensajes').insert({
        'contenido': content,
        'autor_id': userId,
        'tipo_mensaje': 'texto',
      });

      _msgController.clear();
      _scrollToBottom();

      // Reiniciar animación de burbujas para el nuevo mensaje
      _messageBubbleController.reset();
      _messageBubbleController.forward();
    } catch (error) {
      _showSnackBar('Error al enviar mensaje', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Seleccionar y enviar imagen
  Future<void> _sendImage() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _showSnackBar('Usuario no autenticado', Colors.red);
      return;
    }

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() => _isUploadingImage = true);

      // Generar nombre único para la imagen
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';

      // Subir imagen a Supabase Storage
      final imageBytes = await File(image.path).readAsBytes();
      await _supabase.storage
          .from('chat-images')
          .uploadBinary('$userId/$fileName', imageBytes);

      // Obtener URL pública de la imagen
      final imageUrl = _supabase.storage
          .from('chat-images')
          .getPublicUrl('$userId/$fileName');

      // Guardar mensaje con imagen en la base de datos
      await _supabase.from('mensajes').insert({
        'contenido': 'Imagen compartida',
        'autor_id': userId,
        'tipo_mensaje': 'imagen',
        'imagen_url': imageUrl,
      });

      _scrollToBottom();
      _showSnackBar('Imagen enviada', Colors.green);
    } catch (error) {
      _showSnackBar('Error al enviar imagen: $error', Colors.red);
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  // Mostrar opciones de envío con animaciones mejoradas
  void _showSendOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar animado
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 50,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: _accentGradient),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              },
            ),

            // Opciones con animaciones escalonadas
            _buildAnimatedOption(
              icon: Icons.image,
              title: 'Enviar imagen',
              subtitle: 'Seleccionar desde galería',
              gradient: _primaryGradient,
              delay: 100,
              onTap: () {
                Navigator.pop(context);
                _sendImage();
              },
            ),

            _buildAnimatedOption(
              icon: Icons.camera_alt,
              title: 'Tomar foto',
              subtitle: 'Usar cámara',
              gradient: _secondaryGradient,
              delay: 200,
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required int delay,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient.map((c) => c.withOpacity(0.1)).toList(),
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: gradient[0].withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                title: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                onTap: onTap,
              ),
            ),
          ),
        );
      },
    );
  }

  // Tomar foto con cámara
  Future<void> _takePhoto() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() => _isUploadingImage = true);

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_camera.jpg';
      final imageBytes = await File(image.path).readAsBytes();

      await _supabase.storage
          .from('chat-images')
          .uploadBinary('$userId/$fileName', imageBytes);

      final imageUrl = _supabase.storage
          .from('chat-images')
          .getPublicUrl('$userId/$fileName');

      await _supabase.from('mensajes').insert({
        'contenido': 'Foto tomada',
        'autor_id': userId,
        'tipo_mensaje': 'imagen',
        'imagen_url': imageUrl,
      });

      _scrollToBottom();
      _showSnackBar('Foto enviada', Colors.green);
    } catch (error) {
      _showSnackBar('Error al tomar foto: $error', Colors.red);
    } finally {
      if (mounted) setState(() => _isUploadingImage = false);
    }
  }

  Future<void> _deleteMessage(String messageId) async {
    try {
      await _supabase.from('mensajes').delete().eq('id', messageId);
      _showSnackBar('Mensaje eliminado', Colors.green);
    } catch (error) {
      _showSnackBar('Error al eliminar mensaje', Colors.red);
    }
  }

  void _confirmDelete(String messageId, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: _secondaryGradient),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Eliminar mensaje'),
          ],
        ),
        content: Text('¿Eliminar este mensaje?\n\n"$content"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey.shade600)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _secondaryGradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteMessage(messageId);
              },
              child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullscreenImage(String imageUrl) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            _FullscreenImageViewer(imageUrl: imageUrl),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                color == Colors.red ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  String _formatTime(String timestamp) {
    final date = DateTime.parse(timestamp);
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _primaryGradient[0].withOpacity(0.1),
              _accentGradient[1].withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(theme),
            Expanded(
              child: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: _buildMessagesList(theme),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isUploadingImage) _buildUploadingIndicator(theme),
            _buildMessageInput(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return AnimatedBuilder(
      animation: _headerSlideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _headerSlideAnimation.value),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _primaryGradient,
              ),
              boxShadow: [
                BoxShadow(
                  color: _primaryGradient[0].withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: _accentGradient),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _accentGradient[0].withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.forum, color: Colors.white, size: 28),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.white, Colors.white.withOpacity(0.8)],
                        ).createShader(bounds),
                        child: const Text(
                          'CHAT GRUPAL',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _isConnected ? Colors.greenAccent : Colors.redAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (_isConnected ? Colors.greenAccent : Colors.redAccent).withOpacity(0.5),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isConnected ? 'En línea • Texto e imágenes' : 'Desconectado',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadingIndicator(ThemeData theme) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _accentGradient.map((c) => c.withOpacity(0.1)).toList()),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accentGradient[0].withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(_accentGradient[0]),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Subiendo imagen...',
                  style: TextStyle(
                    color: _accentGradient[0],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessagesList(ThemeData theme) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildErrorState(theme);
        }

        if (!snapshot.hasData) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: _primaryGradient.map((c) => c.withOpacity(0.1)).toList()),
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_primaryGradient[0]),
                strokeWidth: 3,
              ),
            ),
          );
        }

        final mensajes = snapshot.data!;

        if (mensajes.isEmpty) {
          return _buildEmptyState(theme);
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: mensajes.length,
          itemBuilder: (context, index) {
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 400 + (index * 100)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: _buildMessageBubble(mensajes[index], theme),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, ThemeData theme) {
    final isMine = msg['autor_id'] == _supabase.auth.currentUser?.id;
    final nombre = msg['profiles']?['nombre'] ?? 'Usuario';
    final contenido = msg['contenido'] ?? '';
    final hora = _formatTime(msg['creado_en']);
    final tipoMensaje = msg['tipo_mensaje'] ?? 'texto';
    final imagenUrl = msg['imagen_url'];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: GestureDetector(
              onLongPress: isMine ? () => _confirmDelete(msg['id'], contenido) : null,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isMine ? _primaryGradient : [Colors.white, Colors.grey.shade50],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(24),
                    topRight: const Radius.circular(24),
                    bottomLeft: Radius.circular(isMine ? 24 : 8),
                    bottomRight: Radius.circular(isMine ? 8 : 24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isMine
                          ? _primaryGradient[0].withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: !isMine ? Border.all(
                    color: Colors.grey.shade200,
                    width: 1,
                  ) : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMine) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: _accentGradient),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            nombre,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            hora,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Mostrar imagen si es mensaje de tipo imagen
                    // Mostrar imagen si es mensaje de tipo imagen
                    if (tipoMensaje == 'imagen' && imagenUrl != null) ...[
                      GestureDetector(
                        onTap: () => _showFullscreenImage(imagenUrl),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imagenUrl,
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(_accentGradient[0]),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(Icons.error_outline, size: 48, color: Colors.grey),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Mostrar texto del mensaje
                    if (contenido.isNotEmpty && tipoMensaje == 'texto')
                      Text(
                        contenido,
                        style: TextStyle(
                          fontSize: 15,
                          color: isMine ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),

                    // Hora para mensajes propios
                    if (isMine) ...[
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          hora,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: _secondaryGradient.map((c) => c.withOpacity(0.1)).toList()),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _secondaryGradient[0].withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: _secondaryGradient),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'Error al cargar mensajes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Revisa tu conexión a internet',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _accentGradient),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _accentGradient[0].withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.chat_bubble_outline, size: 48, color: Colors.white),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(colors: _primaryGradient).createShader(bounds),
            child: const Text(
              '¡Comienza la conversación!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Envía tu primer mensaje o comparte una imagen',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Botón de opciones
            AnimatedBuilder(
              animation: _sendButtonScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _sendButtonScaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: _accentGradient),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _accentGradient[0].withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: _showSendOptions,
                      icon: const Icon(Icons.add, color: Colors.white),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(width: 12),

            // Campo de texto
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _msgController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendTextMessage(),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Botón de envío
            AnimatedBuilder(
              animation: _sendButtonScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _sendButtonScaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: _primaryGradient),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _primaryGradient[0].withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: _isLoading ? null : _sendTextMessage,
                      icon: _isLoading
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Icon(Icons.send, color: Colors.white),
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sendButtonController.dispose();
    _messageBubbleController.dispose();
    _headerController.dispose();
    _pulseController.dispose();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Visor de imagen a pantalla completa
class _FullscreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const _FullscreenImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Error al cargar imagen',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}