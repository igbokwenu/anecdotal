import 'package:anecdotal/providers/in_app_review_provider.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as path;

class ViewReports extends StatelessWidget {
  const ViewReports({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const MyAppBarTitleWithAI(title: 'My Reports'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Symptom'),
              Tab(text: 'Lab'),
              Tab(text: 'Space'),
              Tab(text: 'Others'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ReportList(reportType: userSymptomReportPdfUrls),
            ReportList(reportType: userLabReportPdfUrls),
            ReportList(reportType: userHomeReportPdfUrls),
            ReportList(reportType: userGeneralReportPdfUrls),
          ],
        ),
      ),
    );
  }
}

class ReportList extends ConsumerWidget {
  final String reportType;

  const ReportList({super.key, required this.reportType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    void viewReport(BuildContext context, String url) {
      ref.read(eventCountProvider.notifier).incrementEventCount();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerPage(url: url),
        ),
      );
    }

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
          return const Center(child: Text('No reports saved'));
        }

        // Reverse the list to display items from last to first
        final reversedReportUrls = reportUrls.reversed.toList();

        return ListView.builder(
          itemCount: reversedReportUrls.length,
          itemBuilder: (context, index) {
            final url = reversedReportUrls[index];
            final fileName = _extractFileName(url);
            return ListTile(
              title: Text('Report ${index + 1}'),
              subtitle: Text(fileName),
              onTap: () => viewReport(context, url),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () => viewReport(context, url),
                  ),
                  IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: () => _downloadReport(url),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
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

  String _extractFileName(String url) {
    // Remove any query parameters from the URL
    final uri = Uri.parse(url);
    final cleanUrl = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : url;
    return path.basename(Uri.decodeFull(cleanUrl));
  }

  void _downloadReport(String url) async {
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

class PDFViewerPage extends StatelessWidget {
  final String url;

  const PDFViewerPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_extractFileName(url)),
      ),
      body: SfPdfViewer.network(url),
    );
  }

  String _extractFileName(String url) {
    // Remove any query parameters from the URL
    final uri = Uri.parse(url);
    final cleanUrl = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : url;
    return path.basename(Uri.decodeFull(cleanUrl));
  }
}
