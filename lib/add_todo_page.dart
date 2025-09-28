import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  final Function(String) onAdd;

  const AddTodoPage({super.key, required this.onAdd});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _controller = TextEditingController();

  void _handleAdd() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onAdd(text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
        backgroundColor: Colors.blueGrey.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'What needs to be done?',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _handleAdd(),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _handleAdd,
              icon: const Icon(Icons.add),
              label: const Text('ADD'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
