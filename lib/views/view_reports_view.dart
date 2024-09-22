import 'package:anecdotal/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewReports extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Reports'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'General'),
              Tab(text: 'Symptom'),
              Tab(text: 'Lab'),
              Tab(text: 'Space'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ReportList(reportType: userGeneralReportPdfUrls),
            ReportList(reportType: userSymptomReportPdfUrls),
            ReportList(reportType: userLabReportPdfUrls),
            ReportList(reportType: userHomeReportPdfUrls),
          ],
        ),
      ),
    );
  }
}

class ReportList extends StatelessWidget {
  final String reportType;

  const ReportList({Key? key, required this.reportType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream:
          FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text('No reports found'));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final reportUrls = List<String>.from(data[reportType] ?? []);

        if (reportUrls.isEmpty) {
          return const Center(child: Text('No reports found'));
        }

        return ListView.builder(
          itemCount: reportUrls.length,
          itemBuilder: (context, index) {
            final url = reportUrls[index];
            return ListTile(
              title: Text('Report ${index + 1}'),
              subtitle: Text(url),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () => _viewReport(url),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteReport(context, uid!, url),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _viewReport(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  Future<void> _deleteReport(
      BuildContext context, String uid, String url) async {
    try {
      // Delete from Firebase Storage
      await FirebaseStorage.instance.refFromURL(url).delete();

      // Remove URL from Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        reportType: FieldValue.arrayRemove([url]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting report: $e')),
      );
    }
  }
}
