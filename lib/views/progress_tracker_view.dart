import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:flutter/material.dart';
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

class HealingJourneyApp extends StatefulWidget {
  @override
  _HealingJourneyAppState createState() => _HealingJourneyAppState();
}

class _HealingJourneyAppState extends State<HealingJourneyApp> {
  double _currentPercentage = 0;
  List<String> _inProgressList = [
    "Meditation",
    "Physical therapy",
    "Healthy eating",
  ];
  List<String> _doneList = [
    "Daily exercise",
    "Therapy session",
    "Journaling",
  ];
  List<HealingJourneyEntry> _entries = [];
  TextEditingController _notesController = TextEditingController();

  void _recordProgress() {
    setState(() {
      _entries.add(HealingJourneyEntry(
        timestamp: DateTime.now(),
        percentage: _currentPercentage,
        inProgressList: List.from(_inProgressList),
        doneList: List.from(_doneList),
        notes: _notesController.text, // This can now be empty
      ));
      _notesController.clear();
    });
  }

  void _showEntryDetails(HealingJourneyEntry entry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Journey Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(entry.timestamp)}'),
                Text('Feeling ${entry.percentage.toStringAsFixed(1)}% better'),
                SizedBox(height: 10),
                Text('In Progress:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...entry.inProgressList.map((item) => Text('• $item')),
                SizedBox(height: 10),
                Text('Done:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...entry.doneList.map((item) => Text('• $item')),
                SizedBox(height: 10),
                Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(entry.notes),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
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
    return Scaffold(
      appBar: AppBar(
        title: MyAppBarTitleWithAI(
          title: 'Track Your Healing',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
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
                    Container(
                      width: 50,
                      child: Text(
                        '${_currentPercentage.round()}%',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 20),
                // Text('In Progress Activities:', style: TextStyle(fontSize: 16)),
                // Wrap(
                //   spacing: 8,
                //   children: _inProgressList
                //       .map((item) => Chip(label: Text(item)))
                //       .toList(),
                // ),
                // SizedBox(height: 20),
                // Text('Completed Activities:', style: TextStyle(fontSize: 16)),
                // Wrap(
                //   spacing: 8,
                //   children:
                //       _doneList.map((item) => Chip(label: Text(item))).toList(),
                // ),
                // SizedBox(height: 20),
                Text('Notes (Optional):', style: TextStyle(fontSize: 16)),
                TextField(
                  controller: _notesController,
                  maxLength: 500,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText:
                        'Enter any notable details about your health journey.',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  label: Text('Record Progress'),
                  onPressed: _recordProgress,
                  icon: Icon(Icons.check),
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
                    padding: EdgeInsets.all(6),
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
