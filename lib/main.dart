import 'package:flutter/material.dart';

// Steg 2: tillstånd + funktionalitet (add / toggle / delete / filter)
void main() {
  runApp(const Tig333TodoApp());
}

class Tig333TodoApp extends StatelessWidget {
  const Tig333TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIG333 TODO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFFF2F2F2),
      ),
      home: const TodoListScreen(),
    );
  }
}

class Todo {
  String title;
  bool done;
  Todo(this.title, {this.done = false});
}

enum TodoFilter { all, done, undone }

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _controller = TextEditingController();
  final List<Todo> _todos = [
    Todo('Write a book'),
    Todo('Do homework'),
    Todo('Tidy room', done: true),
    Todo('Watch TV'),
    Todo('Nap'),
    Todo('Shop groceries'),
    Todo('Have fun'),
    Todo('Meditate'),
  ];

  TodoFilter _filter = TodoFilter.all;

  List<Todo> get _filtered {
    switch (_filter) {
      case TodoFilter.done:
        return _todos.where((t) => t.done).toList();
      case TodoFilter.undone:
        return _todos.where((t) => !t.done).toList();
      case TodoFilter.all:
        return _todos;
    }
  }

  void _addTodo() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Write something first…')),
      );
      return;
    }
    setState(() {
      _todos.add(Todo(text));
    });
    _controller.clear();
  }

  void _toggleTodo(Todo t, bool? value) {
    setState(() {
      t.done = value ?? false;
    });
  }

  void _removeTodo(Todo t) {
    setState(() {
      _todos.remove(t);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ChoiceChip(
            label: const Text("All"),
            selected: _filter == TodoFilter.all,
            onSelected: (_) => setState(() => _filter = TodoFilter.all),
          ),
          ChoiceChip(
            label: const Text("Done"),
            selected: _filter == TodoFilter.done,
            onSelected: (_) => setState(() => _filter = TodoFilter.done),
          ),
          ChoiceChip(
            label: const Text("Undone"),
            selected: _filter == TodoFilter.undone,
            onSelected: (_) => setState(() => _filter = TodoFilter.undone),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todos = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TIG333 TODO  •  ${_todos.where((t) => t.done).length}/${_todos.length} done',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade200,
      ),
      body: Column(
        children: [
          _buildFilters(),
          const Divider(),
          Expanded(
            child: ListView.separated(
              itemCount: todos.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final t = todos[index];
                return Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Checkbox(
                      value: t.done,
                      onChanged: (v) => _toggleTodo(t, v),
                    ),
                    title: Text(
                      t.title,
                      style: TextStyle(
                        fontSize: 18,
                        decoration: t.done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: 'Delete',
                      onPressed: () => _removeTodo(t),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input + ADD
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _addTodo(), // Enter lägger till
                    decoration: InputDecoration(
                      hintText: 'What needs to be done?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _addTodo,
                  icon: const Icon(Icons.add),
                  label: const Text("ADD"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}