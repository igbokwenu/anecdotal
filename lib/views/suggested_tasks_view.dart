import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuggestedTasksScreen extends StatefulWidget {
  final String userId; // pass in userId to fetch specific user's data
  const SuggestedTasksScreen({super.key, required this.userId});

  @override
  _SuggestedTasksScreenState createState() => _SuggestedTasksScreenState();
}

class _SuggestedTasksScreenState extends State<SuggestedTasksScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> moveToToDo(String task) async {
    DocumentReference userRef =
        _firestore.collection('users').doc(widget.userId);

    await userRef.update({
      'toDo': FieldValue.arrayUnion([task]),
      'suggestedTasks': FieldValue.arrayRemove([task]),
    });
  }

  Future<void> deleteTask(String task) async {
    DocumentReference userRef =
        _firestore.collection('users').doc(widget.userId);

    await userRef.update({
      'deletedTasks': FieldValue.arrayUnion([task]),
      'suggestedTasks': FieldValue.arrayRemove([task]),
    });
  }

  Future<void> editTask(String oldTask, String newTask) async {
    DocumentReference userRef =
        _firestore.collection('users').doc(widget.userId);

    await userRef.update({
      'suggestedTasks': FieldValue.arrayRemove([oldTask]),
    });
    await userRef.update({
      'suggestedTasks': FieldValue.arrayUnion([newTask]),
    });
  }

  void showEditDialog(String task) {
    TextEditingController controller = TextEditingController(text: task);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Task'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                editTask(task, controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyAppBarTitleWithAI(title: 'Suggested Tasks'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('users').doc(widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          List<dynamic> suggestedTasks = userData['suggestedTasks'] ?? [];
          const double iconSize = 20;

          return ListView.builder(
            itemCount: suggestedTasks.length,
            itemBuilder: (context, index) {
              String task = suggestedTasks[index];
              return ListTile(
                title: Text(
                  task,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: iconSize,
                      ),
                      onPressed: () => showEditDialog(task),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.check,
                        size: iconSize,
                      ),
                      onPressed: () => moveToToDo(task),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: iconSize,
                      ),
                      onPressed: () => deleteTask(task),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
