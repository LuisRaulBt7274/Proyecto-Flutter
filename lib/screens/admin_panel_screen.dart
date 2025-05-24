import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with TickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  bool _isLoading = false;
  List<Map<String, dynamic>> _users = [];
  int _totalUsers = 0;
  int _adminUsers = 0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAdminData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAdminData() async {
    setState(() => _isLoading = true);

    try {
      // Cargar usuarios con información de auth
      final usersResponse = await supabase
          .from('profiles')
          .select('id, nombre, foto_url, rango, created_at')
          .order('created_at', ascending: false);

      setState(() {
        _users = List<Map<String, dynamic>>.from(usersResponse);
        _totalUsers = _users.length;
        _adminUsers = _users.where((u) => u['rango'] == 'admin').length;
        _isLoading = false;
      });
    } catch (error) {
      if (mounted) {
        _showSnackBar('Error: ${error.toString()}', isError: true);
      }
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _updateUserRole(String userId, String newRole) async {
    try {
      await supabase
          .from('profiles')
          .update({'rango': newRole})
          .eq('id', userId);

      _showSnackBar('Rol actualizado correctamente');
      _loadAdminData(); // Recargar datos
    } catch (error) {
      _showSnackBar('Error: ${error.toString()}', isError: true);
    }
  }

  Future<void> _deleteUser(String userId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Eliminar Usuario',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          '¿Estás seguro de que quieres eliminar este usuario? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await supabase.from('profiles').delete().eq('id', userId);
        _showSnackBar('Usuario eliminado correctamente');
        _loadAdminData(); // Recargar datos
      } catch (error) {
        _showSnackBar('Error al eliminar usuario: ${error.toString()}', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(LucideIcons.users), text: 'Usuarios'),
            Tab(icon: Icon(LucideIcons.code), text: 'Editor de Código'),
            Tab(icon: Icon(LucideIcons.settings), text: 'Configuración'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUsersTab(),
          _buildCodeEditorTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
      onRefresh: _loadAdminData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('Total Usuarios', _totalUsers),
                  _buildStatCard('Admins', _adminUsers),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ..._users.map((user) => _buildUserTile(user)).toList(),
        ],
      ),
    );
  }

  Widget _buildCodeEditorTab() {
    return const CodeEditorWidget();
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(LucideIcons.database),
            title: const Text('Gestión de Base de Datos'),
            subtitle: const Text('Configurar tablas y relaciones'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navegar a gestión de BD
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(LucideIcons.shield),
            title: const Text('Configuración de Seguridad'),
            subtitle: const Text('Roles y permisos'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navegar a configuración de seguridad
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(LucideIcons.server),
            title: const Text('Estado del Servidor'),
            subtitle: const Text('Monitorear rendimiento'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navegar a estado del servidor
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(title),
      ],
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(user['foto_url'] ?? ''),
          child: user['foto_url'] == null ? const Icon(Icons.person) : null,
        ),
        title: Text(user['nombre'] ?? 'Sin nombre'),
        subtitle: Text('Rol: ${user['rango']}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'admin' || value == 'user') {
              _updateUserRole(user['id'], value);
            } else if (value == 'delete') {
              _deleteUser(user['id']);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'admin', child: Text('Hacer Admin')),
            const PopupMenuItem(value: 'user', child: Text('Hacer Usuario')),
            const PopupMenuItem(value: 'delete', child: Text('Eliminar')),
          ],
        ),
      ),
    );
  }
}

// Widget del Editor de Código
class CodeEditorWidget extends StatefulWidget {
  const CodeEditorWidget({super.key});

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  final supabase = Supabase.instance.client;
  final TextEditingController _codeController = TextEditingController();
  String _selectedFile = 'main.dart';
  List<String> _files = ['main.dart', 'app.dart', 'config.dart', 'utils.dart'];
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _loadCode();
    _codeController.addListener(() {
      if (!_hasUnsavedChanges) {
        setState(() => _hasUnsavedChanges = true);
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _loadCode() async {
    setState(() => _isLoading = true);

    try {
      // Simular carga de código desde la base de datos
      // En una implementación real, cargarías desde Supabase
      await Future.delayed(const Duration(milliseconds: 500));

      String defaultCode = _getDefaultCodeForFile(_selectedFile);
      _codeController.text = defaultCode;

      setState(() {
        _isLoading = false;
        _hasUnsavedChanges = false;
      });
    } catch (error) {
      _showSnackBar('Error al cargar código: ${error.toString()}', isError: true);
      setState(() => _isLoading = false);
    }
  }

  String _getDefaultCodeForFile(String fileName) {
    switch (fileName) {
      case 'main.dart':
        return '''import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  runApp(const MyApp());
}''';
      case 'app.dart':
        return '''import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}''';
      case 'config.dart':
        return '''class AppConfig {
  static const String appName = 'Mi Aplicación';
  static const String version = '1.0.0';
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';
}''';
      case 'utils.dart':
        return '''class AppUtils {
  static String formatDate(DateTime date) {
    return '\${date.day}/\${date.month}/\${date.year}';
  }
  
  static bool isValidEmail(String email) {
    return RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$').hasMatch(email);
  }
}''';
      default:
        return '// Nuevo archivo\n';
    }
  }

  Future<void> _saveCode() async {
    setState(() => _isLoading = true);

    try {
      // Aquí guardarías el código en Supabase
      // await supabase.from('app_files').upsert({
      //   'filename': _selectedFile,
      //   'content': _codeController.text,
      //   'updated_at': DateTime.now().toIso8601String(),
      // });

      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _isLoading = false;
        _hasUnsavedChanges = false;
      });

      _showSnackBar('Código guardado correctamente');
    } catch (error) {
      _showSnackBar('Error al guardar: ${error.toString()}', isError: true);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createNewFile() async {
    final fileName = await showDialog<String>(
      context: context,
      builder: (context) => _CreateFileDialog(),
    );

    if (fileName != null && fileName.isNotEmpty) {
      setState(() {
        _files.add(fileName);
        _selectedFile = fileName;
      });
      _loadCode();
    }
  }

  Future<void> _deleteFile() async {
    if (_files.length <= 1) {
      _showSnackBar('No puedes eliminar el último archivo', isError: true);
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar archivo'),
        content: Text('¿Eliminar $_selectedFile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      setState(() {
        _files.remove(_selectedFile);
        _selectedFile = _files.first;
      });
      _loadCode();
      _showSnackBar('Archivo eliminado');
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de herramientas
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              // Selector de archivos
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedFile,
                  decoration: const InputDecoration(
                    labelText: 'Archivo',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: _files.map((file) => DropdownMenuItem(
                    value: file,
                    child: Text(file),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null && value != _selectedFile) {
                      setState(() => _selectedFile = value);
                      _loadCode();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),

              // Botones de acción
              IconButton(
                onPressed: _createNewFile,
                icon: const Icon(LucideIcons.filePlus),
                tooltip: 'Nuevo archivo',
              ),
              IconButton(
                onPressed: _deleteFile,
                icon: const Icon(LucideIcons.trash2),
                tooltip: 'Eliminar archivo',
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveCode,
                icon: _isLoading
                    ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2)
                )
                    : const Icon(LucideIcons.save),
                label: Text(_hasUnsavedChanges ? 'Guardar*' : 'Guardar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hasUnsavedChanges ? Colors.orange : null,
                ),
              ),
            ],
          ),
        ),

        // Editor de código
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _codeController,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escribe tu código aquí...',
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Dialog para crear nuevo archivo
class _CreateFileDialog extends StatefulWidget {
  @override
  State<_CreateFileDialog> createState() => _CreateFileDialogState();
}

class _CreateFileDialogState extends State<_CreateFileDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Crear nuevo archivo'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Nombre del archivo',
          hintText: 'ejemplo.dart',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Crear'),
        ),
      ],
    );
  }
}