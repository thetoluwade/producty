import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/todo/todo_list_item.dart';
import '../../data/models/todo.dart';
import '../../providers/todo_provider.dart';
import '../auth/auth_screen.dart';
import 'package:uuid/uuid.dart';
import '../../widgets/custom_toast.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _todoController = TextEditingController();
  String _selectedTab = 'all';

  void _showToast(String message, {bool isError = false}) {
    CustomToast.show(context, message, isError: isError);
  }

  void _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', false);
    if (!mounted) return;
    _showToast('Successfully logged out');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (route) => false,
    );
  }

  void _addTodo() {
    if (_todoController.text.trim().isNotEmpty) {
      context.read<TodoProvider>().addTodo(
        Todo(
          id: const Uuid().v4(),
          title: _todoController.text,
          isCompleted: false,
          createdAt: DateTime.now(),
        ),
      );
      _todoController.clear();
    }
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F1F1),
        elevation: 0,
        title: Text(
          'Producty',
          style: theme.textTheme.headlineMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Iconsax.logout,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildTab('All', 'all'),
                const SizedBox(width: 16),
                _buildTab('Pending', 'pending'),
                const SizedBox(width: 16),
                _buildTab('Completed', 'completed'),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          final todos = switch (_selectedTab) {
            'pending' => todoProvider.pendingTodos,
            'completed' => todoProvider.completedTodos,
            _ => todoProvider.todos,
          };

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return TodoListItem(todo: todos[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _todoController,
                        decoration: const InputDecoration(
                          hintText: 'Add a new todo',
                        ),
                        onSubmitted: (_) => _addTodo(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _addTodo,
                    ),
                  ],
                ),
              ),
            ),
            isScrollControlled: true,
          );
        },
        child: const Icon(Iconsax.add),
      ),
    );
  }

  Widget _buildTab(String title, String value) {
    final isSelected = _selectedTab == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.grey,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
