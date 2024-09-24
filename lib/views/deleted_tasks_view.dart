import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/views/view_widgets.dart/tasks_widget.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeletedTasksScreen extends ConsumerWidget {
  final String uid;

  const DeletedTasksScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;

    if (userData == null) {
      return const MySpinKitWaveSpinner();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Deleted Tasks')),
      body: ListView(
        children: userData.deletedTasks.map((task) {
          return ListTile(
            title: Text(task),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.restore),
                  onPressed: () => restoreTask(uid, task),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () => permanentlyDeleteTask(uid, task),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
