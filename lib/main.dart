import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'add_todo_page.dart';

// Steg 3: API + navigation
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
  String id;
  String title;
  bool done;
  Todo(this.title, {this.done = false, this.id = ''});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      json['title'],
      done: json['done'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'done': done,
      };
}

enum TodoFilter { all, done, undone }

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _apiBase = 'https://todoapp-api.apps.k8s.gu.se';
  final _apiKey = '4b9a2bbe-d660-4ebd-a8b3-e98587cfbaa4';
  List<Todo> _todos = [];
  TodoFilter _filter = TodoFilter.all;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final res = await http.get(Uri.parse('$_apiBase/todos?key=$_apiKey'));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      setState(() {
        _todos = data.map((e) => Todo.fromJson(e)).toList();
      });
    }
  }

  Future<void> _addTodoOnline(String title) async {
    await http.post(
      Uri.parse('$_apiBase/todos?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'done': false}),
    );
    _loadTodos();
  }

  Future<void> _toggleTodoOnline(Todo t, bool value) async {
    await http.put(
      Uri.parse('$_apiBase/todos/${t.id}?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': t.title, 'done': value}),
    );
    _loadTodos();
  }

  Future<void> _removeTodoOnline(Todo t) async {
    await http.delete(Uri.parse('$_apiBase/todos/${t.id}?key=$_apiKey'));
    _loadTodos();
  }

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

  void _navigateToAddPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTodoPage(onAdd: _addTodoOnline),
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
            child: RefreshIndicator(
              onRefresh: _loadTodos,
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
                        onChanged: (v) => _toggleTodoOnline(t, v ?? false),
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
                        onPressed: () => _removeTodoOnline(t),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPage,
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
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
}
