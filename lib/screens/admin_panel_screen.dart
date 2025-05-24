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
    _tabController = TabController(length: 1, vsync: this);
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
      _loadAdminData();
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
        _loadAdminData();
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
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUsersTab(),
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
