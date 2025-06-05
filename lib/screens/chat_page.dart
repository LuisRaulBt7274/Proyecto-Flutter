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
    with SingleTickerProviderStateMixin {
  final _supabase = Supabase.instance.client;
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isLoading = false;
  bool _isUploadingImage = false;
  bool _isConnected = true;

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
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  // Enviar mensaje de texto
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

  // Mostrar opciones de envío
  void _showSendOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.image, color: Colors.blue),
              ),
              title: const Text('Enviar imagen'),
              subtitle: const Text('Seleccionar desde galería'),
              onTap: () {
                Navigator.pop(context);
                _sendImage();
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.green),
              ),
              title: const Text('Tomar foto'),
              subtitle: const Text('Usar cámara'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar mensaje'),
        content: Text('¿Eliminar este mensaje?\n\n"$content"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey.shade600)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMessage(messageId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade600),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showFullscreenImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullscreenImageViewer(imageUrl: imageUrl),
      ),
    );
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

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(theme),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildMessagesList(theme),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor.withOpacity(0.8),
            theme.primaryColor.withOpacity(0.6),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.forum, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CHAT GRUPAL',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  _isConnected ? 'En línea • Texto e imágenes' : 'Desconectado',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadingIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Subiendo imagen...',
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
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
          itemBuilder: (context, index) => _buildMessageBubble(mensajes[index], theme),
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
      margin: const EdgeInsets.symmetric(vertical: 4),
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
                  gradient: isMine
                      ? LinearGradient(
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withOpacity(0.8),
                    ],
                  )
                      : LinearGradient(
                    colors: [
                      Colors.grey.shade100,
                      Colors.grey.shade50,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isMine ? 20 : 6),
                    bottomRight: Radius.circular(isMine ? 6 : 20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            nombre,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
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
                      const SizedBox(height: 8),
                    ],

                    // Mostrar imagen si es mensaje de tipo imagen
                    if (tipoMensaje == 'imagen' && imagenUrl != null) ...[
                      GestureDetector(
                        onTap: () => _showFullscreenImage(imagenUrl),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 250,
                            maxHeight: 300,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imagenUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 150,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        isMine ? Colors.white : theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.error_outline,
                                      color: Colors.grey,
                                      size: 32,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      if (contenido.isNotEmpty && contenido != 'Imagen compartida' && contenido != 'Foto tomada')
                        const SizedBox(height: 8),
                    ],

                    // Mostrar texto si no es solo una imagen
                    if (tipoMensaje != 'imagen' || (contenido.isNotEmpty && contenido != 'Imagen compartida' && contenido != 'Foto tomada'))
                      Text(
                        contenido,
                        style: TextStyle(
                          fontSize: 16,
                          color: isMine ? Colors.white : Colors.black87,
                          height: 1.3,
                        ),
                      ),

                    if (isMine) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            hora,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ],
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
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'Error de conexión',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay mensajes',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '¡Envía texto o imágenes!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
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
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Botón para adjuntar imagen
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: theme.primaryColor),
                onPressed: _showSendOptions,
              ),
            ),
            const SizedBox(width: 8),

            // Campo de texto
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: _msgController,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Escribe tu mensaje...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _sendTextMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Botón enviar
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.8),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: _isLoading ? null : _sendTextMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
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
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 64,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}