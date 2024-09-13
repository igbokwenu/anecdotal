import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class VisualizeProgress extends ConsumerStatefulWidget {
  const VisualizeProgress({Key? key}) : super(key: key);

  @override
  _VisualizeProgressState createState() => _VisualizeProgressState();
}

class _VisualizeProgressState extends ConsumerState<VisualizeProgress> {
  static const int _pageSize = 50;
  final ScrollController _scrollController = ScrollController();
  List<HealingJourneyEntry> _entries = [];
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMoreEntries();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreEntries();
    }
  }

  Future<void> _loadMoreEntries() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = await ref.read(anecdotalUserDataProvider(uid).future);

    if (userData != null && userData.healingJourneyMap.isNotEmpty) {
      final newEntries = userData.healingJourneyMap
          .skip(_entries.length)
          .take(_pageSize)
          .map((entry) => HealingJourneyEntry(
                timestamp:
                    DateTime.fromMillisecondsSinceEpoch(entry['timestamp']),
                percentage: entry['percentage'].toDouble(),
                inProgressList: List<String>.from(entry['inProgressList']),
                doneList: List<String>.from(entry['doneList']),
                notes: entry['notes'],
              ))
          .toList();

      setState(() {
        _entries.addAll(newEntries);
        _isLoading = false;
        _hasMore = newEntries.length == _pageSize;
      });
    } else {
      setState(() {
        _isLoading = false;
        _hasMore = false;
      });
    }
  }

  void _showEntryDetails(HealingJourneyEntry entry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Journey Details',
              style: Theme.of(context).textTheme.displaySmall),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(entry.timestamp)}',
                    style: Theme.of(context).textTheme.titleMedium),
                Text('Feeling ${entry.percentage.toStringAsFixed(1)}% better',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Theme.of(context).primaryColor)),
                const SizedBox(height: 16),
                Text('Tasks In Progress:',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                ...entry.inProgressList.map((item) => Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                      child: Text('• $item',
                          style: Theme.of(context).textTheme.bodyMedium),
                    )),
                const SizedBox(height: 16),
                Text('Completed Tasks:',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                ...entry.doneList.map((item) => Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                      child: Text('• $item',
                          style: Theme.of(context).textTheme.bodyMedium),
                    )),
                const SizedBox(height: 16),
                Text('Notes:',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text(entry.notes,
                    style: Theme.of(context).textTheme.bodyMedium),
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
    return Scaffold(
      appBar: AppBar(
        title: const MyAppBarTitleWithAI(
          title: 'Visualize Your Journey',
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Text(
              'Click on any point in the timeline for more details on the activities recorded.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: _entries.isEmpty && !_isLoading
                ? const Center(child: Text('No progress data available.'))
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _entries.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _entries.length) {
                        return _buildLoader();
                      }

                      // Accessing the reversed list
                      final entry = _entries.reversed.toList()[index];
                      return TimelineTile(
                        alignment: TimelineAlign.manual,
                        lineXY: 0.1,
                        isFirst: index == 0,
                        isLast: index == _entries.length - 1,
                        indicatorStyle: IndicatorStyle(
                          width: 20,
                          color: _getColor(entry.percentage),
                          padding: const EdgeInsets.all(6),
                        ),
                        beforeLineStyle:
                            LineStyle(color: _getColor(entry.percentage)),
                        endChild: _buildEntryTile(entry),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryTile(HealingJourneyEntry entry) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          '${entry.percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _getColor(entry.percentage),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              DateFormat('MMMM d, yyyy').format(entry.timestamp),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              '${entry.inProgressList.length} tasks in progress, ${entry.doneList.length} completed',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        onTap: () => _showEntryDetails(entry),
      ),
    );
  }

  Widget _buildLoader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Color _getColor(double percentage) {
    if (percentage < 20) {
      return Colors.orange[200]!;
    } else if (percentage < 40) {
      return Colors.orange[400]!;
    } else if (percentage < 60) {
      return Colors.orange[600]!;
    } else if (percentage < 80) {
      return Colors.lightGreen;
    } else {
      return Colors.green;
    }
  }
}

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
