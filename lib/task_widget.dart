import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final String id;
  final String name;
  final bool is_completed;
  final VoidCallback onDelete;
  final VoidCallback onToggleComplete;

  TaskWidget({required this.id, required this.name, required this.is_completed, required this.onDelete, required this.onToggleComplete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: is_completed, onChanged: (val) => onToggleComplete()),
      title: Text(name, style: TextStyle(decoration: is_completed ? TextDecoration.lineThrough : null)),
      trailing: IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
      onTap: onToggleComplete,
    );
  }
}