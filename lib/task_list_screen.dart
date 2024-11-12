import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task_widget.dart';
import 'auth_screen.dart'; 

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _taskController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  void addTask() {
    if (_taskController.text.isEmpty) return;
    _firestore.collection('tasks').add({
      'name': _taskController.text,
      'is_completed': false,
      'subTasks': [],
    });
    _taskController.clear();
  }

  void deleteTask(String id) => _firestore.collection('tasks').doc(id).delete();

  void toggleTaskCompletion(String id, bool currentStatus) {
    _firestore.collection('tasks').doc(id).update({'is_completed': !currentStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _taskController, decoration: InputDecoration(labelText: 'New Task'))),
                IconButton(icon: Icon(Icons.add), onPressed: addTask),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('tasks').snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    var task = doc.data() as Map<String, dynamic>;
                    return TaskWidget(
                      id: doc.id,
                      name: task['name'],
                      is_completed: task['is_completed'],
                      onDelete: () => deleteTask(doc.id),
                      onToggleComplete: () => toggleTaskCompletion(doc.id, task['is_completed']),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              // Log the user out when the button is pressed
              await FirebaseAuth.instance.signOut();
              
              // Navigate back to the authentication screen (login/signup)
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}