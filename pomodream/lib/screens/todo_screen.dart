import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Map<String, dynamic>> todos = [];
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('tasks');
    if (data != null) {
      List decoded = jsonDecode(data);
      setState(() => todos.addAll(decoded.cast<Map<String, dynamic>>()));
    }
  }

  void _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('tasks', jsonEncode(todos));
  }

  void addTask(String task) {
    if (task.trim().isEmpty) return;
    setState(() {
      todos.add({"text": task, "done": false});
      controller.clear();
    });
    _saveTasks();
  }

  void toggleDone(int index) {
    setState(() => todos[index]['done'] = !todos[index]['done']);
    _saveTasks();
  }

  void removeTask(int index) {
    setState(() => todos.removeAt(index));
    _saveTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yapılacaklar")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              onSubmitted: addTask,
              decoration: InputDecoration(
                hintText: "Yaz...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => addTask(controller.text),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final item = todos[index];
                  return ListTile(
                    leading: Checkbox(
                      value: item['done'],
                      onChanged: (_) => toggleDone(index),
                    ),
                    title: Text(
                      item['text'],
                      style: TextStyle(
                        decoration:
                            item['done']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => removeTask(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
