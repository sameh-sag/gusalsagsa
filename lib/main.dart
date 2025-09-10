import 'package:flutter/material.dart';

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

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Statisk lista som i figma
    final todos = <_TodoRowData>[
      _TodoRowData('Write a book', done: false),
      _TodoRowData('Do homework', done: false),
      _TodoRowData('Tidy room', done: true),
      _TodoRowData('Watch TV', done: false),
      _TodoRowData('Nap', done: false),
      _TodoRowData('Shop groceries', done: false),
      _TodoRowData('Have fun', done: false),
      _TodoRowData('Meditate', done: false),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TIG333 TODO',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade200,
      ),

      body: Column(
        children: [
          // Filter-knappar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text("All"),
                  selected: true,
                  onSelected: null,
                ),
                ChoiceChip(
                  label: const Text("Done"),
                  selected: false,
                  onSelected: null,
                ),
                ChoiceChip(
                  label: const Text("Undone"),
                  selected: false,
                  onSelected: null,
                ),
              ],
            ),
          ),

          const Divider(),

          // Lista med todos
          Expanded(
            child: ListView.separated(
              itemCount: todos.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final row = todos[index];
                return Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Checkbox(
                      value: row.done,
                      onChanged: null, // bara visuellt i steg 1
                    ),
                    title: Text(
                      row.title,
                      style: TextStyle(
                        fontSize: 18,
                        decoration: row.done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.close),
                    ),
                  ),
                );
              },
            ),
          ),

          // Textfält + ADD-knapp längst ner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'What are you going to do?',
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
                  onPressed: () {}, // ingen funktion ännu
                  icon: const Icon(Icons.add),
                  label: const Text("ADD"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
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

class _TodoRowData {
  final String title;
  final bool done;
  const _TodoRowData(this.title, {required this.done});
}
