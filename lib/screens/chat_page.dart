import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class SimpleChatScreen extends StatefulWidget {
  const SimpleChatScreen({Key? key}) : super(key: key);

  @override
  _SimpleChatScreenState createState() => _SimpleChatScreenState();
}

class _SimpleChatScreenState extends State<SimpleChatScreen> {
  final _supabase = Supabase.instance.client;
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();

  bool _isLoading = false;
  bool _isUploadingImage = false;
  final bool _isConnected = true;

  // Gradientes y colores
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

  // Stream de mensajes
  Stream<List<Map<String, dynamic>>> get _messageStream => _supabase
      .from('mensajes')
      .select('id, contenido, creado_en, autor_id, tipo_mensaje, imagen_url, profiles(nombre)')
      .order('creado_en')
      .asStream();

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

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

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';
      final imageBytes = await File(image.path).readAsBytes();
      
      await _supabase.storage
          .from('chat-images')
          .uploadBinary('$userId/$fileName', imageBytes);

      final imageUrl = _supabase.storage
          .from('chat-images')
          .getPublicUrl('$userId/$fileName');

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

  void _showSendOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.image, color: _primaryGradient[0]),
            title: const Text('Enviar imagen'),
            subtitle: const Text('Seleccionar desde galería'),
            onTap: () {
              Navigator.pop(context);
              _sendImage();
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt, color: _secondaryGradient[0]),
            title: const Text('Tomar foto'),
            subtitle: const Text('Usar cámara'),
            onTap: () {
              Navigator.pop(context);
              _takePhoto();
            },
          ),
        ],
      ),
    );
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
        title: const Text('Eliminar mensaje'),
        content: Text('¿Eliminar este mensaje?\n\n"$content"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteMessage(messageId);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showFullscreenImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  String _formatTime(String timestamp) {
    final date = DateTime.parse(timestamp);
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildMessagesList(),
          ),
          if (_isUploadingImage) _buildUploadingIndicator(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: _primaryGradient),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _accentGradient),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.forum, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CHAT GRUPAL',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isConnected ? 'En línea • Texto e imágenes' : 'Desconectado',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(_accentGradient[0]),
          ),
          const SizedBox(width: 12),
          const Text('Subiendo imagen...'),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final mensajes = snapshot.data!;

        if (mensajes.isEmpty) {
          return const Center(child: Text('No hay mensajes'));
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: mensajes.length,
          itemBuilder: (context, index) {
            return _buildMessageBubble(mensajes[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
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
                  color: isMine ? _primaryGradient[0] : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(24),
                    topRight: const Radius.circular(24),
                    bottomLeft: Radius.circular(isMine ? 24 : 8),
                    bottomRight: Radius.circular(isMine ? 8 : 24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMine) ...[
                      Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                    ],
                    if (tipoMensaje == 'imagen' && imagenUrl != null) ...[
                      GestureDetector(
                        onTap: () => _showFullscreenImage(imagenUrl),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(imagenUrl),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (contenido.isNotEmpty && tipoMensaje == 'texto')
                      Text(contenido),
                    const SizedBox(height: 4),
                    Text(
                      hora,
                      style: TextStyle(
                        fontSize: 10,
                        color: isMine ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showSendOptions,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _msgController,
              decoration: const InputDecoration(
                hintText: 'Escribe un mensaje...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendTextMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            onPressed: _isLoading ? null : _sendTextMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
