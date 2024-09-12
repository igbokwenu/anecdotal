import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HealingJourneyEntry {
  final DateTime timestamp;
  final double percentage;
  final List<String> inProgressList;
  final List<String> doneList;
  final String notes;

  HealingJourneyEntry({
    required this.timestamp,
    required this.percentage,
    required this.inProgressList,
    required this.doneList,
    required this.notes,
  });
}

class ProgressTracker extends ConsumerStatefulWidget {
  const ProgressTracker({super.key});

  @override
  _HealingJourneyAppState createState() => _HealingJourneyAppState();
}

class _HealingJourneyAppState extends ConsumerState<ProgressTracker> {
  double _currentPercentage = 0;
  final List<String> _inProgressList = [
    "Meditation",
    "Physical therapy",
    "Healthy eating",
  ];
  final List<String> _doneList = [
    "Daily exercise",
    "Therapy session",
    "Journaling",
  ];
  final List<HealingJourneyEntry> _entries = [];
  final TextEditingController _notesController = TextEditingController();

  void _showEntryDetails(HealingJourneyEntry entry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Journey Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(entry.timestamp)}'),
                Text('Feeling ${entry.percentage.toStringAsFixed(1)}% better'),
                const SizedBox(height: 10),
                const Text('Tasks In Progress:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...entry.inProgressList.map((item) => Text('• $item')),
                const SizedBox(height: 10),
                const Text('Completed Tasks:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...entry.doneList.map((item) => Text('• $item')),
                const SizedBox(height: 10),
                const Text('Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(entry.notes),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    void recordProgress() {
      setState(() {
        _entries.add(HealingJourneyEntry(
          timestamp: DateTime.now(),
          percentage: _currentPercentage,
          inProgressList: List.from(userData!.inProgressList),
          doneList: List.from(userData.doneList),
          notes: _notesController.text, // This can now be empty
        ));
        _notesController.clear();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const MyAppBarTitleWithAI(
          title: 'Track Your Healing',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                    'Use the slider below to tell us how you are feeling about your health. 0% means your symptoms are debilitating and 100% means you are symptom free.',
                    style: Theme.of(context).textTheme.bodySmall),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _currentPercentage,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: '${_currentPercentage.round()}%',
                        onChanged: (value) {
                          setState(() {
                            _currentPercentage = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        '${_currentPercentage.round()}%',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Text('Notes (Optional):', style: TextStyle(fontSize: 16)),
                TextField(
                  controller: _notesController,
                  maxLength: 500,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText:
                        'Enter any notable details about your health journey.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  label: const Text('Record Progress'),
                  onPressed: recordProgress,
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[_entries.length - 1 - index];
                return TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  isFirst: index == 0,
                  isLast: index == _entries.length - 1,
                  indicatorStyle: IndicatorStyle(
                    width: 20,
                    color: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.all(6),
                  ),
                  endChild: ListTile(
                    title: Text('${entry.percentage.toStringAsFixed(1)}%'),
                    subtitle:
                        Text(DateFormat('yyyy-MM-dd').format(entry.timestamp)),
                    onTap: () => _showEntryDetails(entry),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
