import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/database_service.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/constants/symptom_list.dart';
import 'package:anecdotal/views/deleted_tasks_view.dart';
import 'package:anecdotal/views/progress_tracker_view.dart';
import 'package:anecdotal/views/suggested_tasks_view.dart';
import 'package:anecdotal/views/view_widgets.dart/tasks_widget.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToDoScreen extends ConsumerStatefulWidget {
  const ToDoScreen({super.key});

  @override
  ConsumerState<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends ConsumerState<ToDoScreen> {
  bool isDefaultUI = true; // Initially set the default UI as active.

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    final themeStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontSize: 18, fontWeight: FontWeight.bold);

    if (userData == null) {
      return const MySpinKitWaveSpinner();
    }
    Widget headerText(String text) {
      return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(text, style: themeStyle),
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const MyAppBarTitleWithAI(title: "Healing Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore_from_trash),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DeletedTasksScreen(uid: uid!)),
              );
            },
          ),
          IconButton(
            icon: Icon(
              !isDefaultUI ? Icons.view_comfy_alt : Icons.view_list,
            ), // Toggle between two icons
            onPressed: () {
              setState(() {
                isDefaultUI = !isDefaultUI; // Toggle the UI state
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Text(
                'Your completed tasks and tasks in progress are added whenever you update your mood.',
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProgressTracker(),
                  ),
                );
              },
              label: const Text("Update Mood"),
              icon: const Icon(Icons.edit_note),
            ),
            headerText('To-Do:'),
            TaskListWidget(
              tasks: userData.toDoList,
              listName: 'toDo',
              onMoveTask: (task, toList) =>
                  moveTask(context, uid!, task, 'toDo', toList),
              onDeleteTask: (task) => deleteTask(context, uid!, task, 'toDo'),
              onEditTask: (task, newTask) =>
                  editTask(context, uid!, task, newTask, 'toDo'),
              isDefaultUI: isDefaultUI, // Pass the UI toggle value.
            ),
            const Divider(),
            headerText('In Progress:'),
            TaskListWidget(
              tasks: userData.inProgressList,
              listName: 'inProgress',
              onMoveTask: (task, toList) =>
                  moveTask(context, uid!, task, 'inProgress', toList),
              onDeleteTask: (task) =>
                  deleteTask(context, uid!, task, 'inProgress'),
              onEditTask: (task, newTask) =>
                  editTask(context, uid!, task, newTask, 'inProgress'),
              isDefaultUI: isDefaultUI, // Pass the UI toggle value.
            ),
            const Divider(),
            headerText('Done:'),
            TaskListWidget(
              tasks: userData.doneList,
              listName: 'done',
              onMoveTask: (task, toList) =>
                  moveTask(context, uid!, task, 'done', toList),
              onDeleteTask: (task) => deleteTask(context, uid!, task, 'done'),
              onEditTask: (task, newTask) =>
                  editTask(context, uid!, task, newTask, 'done'),
              isDefaultUI: isDefaultUI, // Pass the UI toggle value.
            ),
            const Divider(),
            mySpacing(spacing: 70),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async {
              if (userData.suggestedTasks.isEmpty) {
                final databaseService = DatabaseService(uid: uid!);

                await databaseService.updateAnyUserData(
                  fieldName: userSuggestedTasksList,
                  newValue: cirsToDoTasks,
                );
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SuggestedTasksScreen(
                          userId: uid!,
                        )),
              );
            },
            icon: const Icon(
              Icons.question_mark,
              size: 30,
            ),
          ),
          mySpacing(),
          IconButton(
            onPressed: () {
              addTaskDialog(context, uid!);
            },
            icon: const Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
