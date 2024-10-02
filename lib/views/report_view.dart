import 'dart:io';
import 'package:anecdotal/providers/iap_provider.dart';
import 'package:anecdotal/providers/in_app_review_provider.dart';
import 'package:anecdotal/providers/public_data_provider.dart';
import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/constants/writeups.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/view_reports_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportView extends ConsumerStatefulWidget {
  final String summaryContent;
  final List<String> keyInsights;
  final List<String> recommendations;
  final List<String> followUpSearchTerms;
  final List<String> citations;
  final String? title;
  final String? name;
  final bool enableManualCitations;
  final String reportType;
  final List<File>? selectedImages;

  const ReportView({
    super.key,
    required this.summaryContent,
    required this.keyInsights,
    required this.recommendations,
    required this.followUpSearchTerms,
    required this.citations,
    required this.reportType,
    this.title,
    this.name,
    this.enableManualCitations = true,
    this.selectedImages,
  });

  @override
  ConsumerState<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends ConsumerState<ReportView> {
  bool _isSaved = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventCountProvider.notifier).incrementEventCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iapStatus = ref.watch(iapProvider);
    ref.read(iapProvider.notifier).checkAndSetIAPStatus();

    List<Widget> buildCitationLinks(
        List<String> dynamicCitations, List<String>? manualCitations) {
      final allCitations = [
        ...dynamicCitations
      ]; // Start with dynamic citations
      if (manualCitations != null && manualCitations.isNotEmpty) {
        allCitations.addAll(manualCitations); // Add manual citations if present
      }

      return allCitations
          .map((citation) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          label: Text(
                            citation,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          icon: const Icon(Icons.link),
                          onPressed: () {
                            MyReusableFunctions.launchCustomUrl(url: citation);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList();
    }

    List<Widget> buildSearchTerms(List<String> points) {
      return points
          .map((point) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Icon(Icons.health_and_safety_rounded),
                    // const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          label: Text(
                            point,
                            style: theme.textTheme.bodyMedium,
                          ),
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            MyReusableFunctions.launchGoogleSearch(point);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList();
    }

    Future<void> saveAndSharePDF(BuildContext context, bool share) async {
      setState(() {
        _isSaving = true;
      });
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
      final publicData = ref.watch(publicDataProvider).value;
      final pdf = pw.Document();
      final subject = userData!.lastName!.isEmpty
          ? "Subject Anonymous"
          : "${userData.firstName} ${userData.lastName}";

      String getUserType(String type) {
        switch (type) {
          case userSymptomReportPdfUrls:
            return 'symptom_analysis';
          case userLabReportPdfUrls:
            return 'lab_result_analysis';
          case userHomeReportPdfUrls:
            return 'environmental_report_analysis';
          case userGeneralReportPdfUrls:
            return 'general_report';
          default:
            return 'report';
        }
      }

      // Load image from assets
      final imageBytes = await rootBundle.load(logoAssetImageUrlSplash);
      final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

      // Get the current date and time
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd_HH-mm-ss').format(now);
      final formattedDateWithoutTime = DateFormat('yyyy-MM-dd').format(now);

      // Create file name with current date and time
      final fileName =
          "${getUserType(widget.reportType)}_anecdotalAI_$formattedDate.pdf";

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => [
            pw.Center(
              child: pw.Container(
                alignment: pw.Alignment.center,
                width: 130,
                height: 130,
                decoration: pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  // border: pw.Border.all(
                  //   color: PdfColors.teal,
                  //   width: 4.0,
                  // ),
                  image: pw.DecorationImage(
                    fit: pw.BoxFit.contain,
                    image: image,
                  ),
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.UrlLink(
              child: pw.Text(
                'Website: www.anecdotalhq.web.app',
                style: pw.TextStyle(
                  color: PdfColors.teal,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
              destination: "https://anecdotalhq.web.app/download",
            ),
            pw.SizedBox(height: 10),
            pw.Text('Report Created For: $subject'),
            pw.SizedBox(height: 5),
            pw.Text('Date: $formattedDateWithoutTime'),
            pw.SizedBox(height: 20),
            pw.Text(
              'Introduction:',
              style: pw.TextStyle(
                color: PdfColors.teal,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(widget.summaryContent),
            pw.SizedBox(height: 10),
            pw.Text(
              'Key Insights:',
              style: pw.TextStyle(
                color: PdfColors.teal,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            ...widget.keyInsights.map((insight) => pw.Bullet(text: insight)),
            pw.SizedBox(height: 10),
            pw.Text(
              'Recommendations:',
              style: pw.TextStyle(
                color: PdfColors.teal,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            ...widget.recommendations
                .map((recommendation) => pw.Bullet(text: recommendation)),
            pw.SizedBox(height: 10),
            pw.Text(
              'Citations:',
              style: pw.TextStyle(
                color: PdfColors.teal,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            ...widget.citations.map(
              (citation) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(vertical: 5),
                child: pw.UrlLink(
                  child: pw.Text(
                    citation,
                  ),
                  destination: citation,
                ),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Follow Up Search Terms:',
              style: pw.TextStyle(
                color: PdfColors.teal,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            ...widget.followUpSearchTerms.map((term) => pw.Bullet(text: term)),
            if (widget.selectedImages != null &&
                widget.selectedImages!.isNotEmpty)
              pw.Header(level: 1, text: 'Analyzed Media'),
            if (widget.selectedImages != null)
              ...widget.selectedImages!.map((file) {
                final image = pw.MemoryImage(file.readAsBytesSync());
                return pw.Center(
                  child: pw.Image(image, height: 200),
                );
              }).toList(),
          ],
        ),
      );

      if (!kIsWeb) {
        if (userData.aiGeneralTextUsageCount >= publicData!.aiFreeUsageLimit &&
            !iapStatus.isPro) {
          MyReusableFunctions.showPremiumDialog(
              context: context, message: premiumSpeechPDFAccess);
        } else {
          try {
            final bytes = await pdf.save();
            final output = await getTemporaryDirectory();
            final file = File("${output.path}/$fileName");
            await file.writeAsBytes(await pdf.save());

            if (share) {
              final xFile = XFile(file.path);

              // Ensure the context and the RenderBox are available
              final RenderBox? box = context.findRenderObject() as RenderBox?;

              await Share.shareXFiles(
                [xFile],
                text: 'Anecdotal Report',
                sharePositionOrigin: box!.localToGlobal(Offset.zero) &
                    box.size, // Required for iPad
              );
            } else {
              setState(() {
                _isSaving = true;
              });
              // Upload to Firebase Storage
              final storageRef = FirebaseStorage.instance
                  .ref()
                  .child('user_data/$uid/$fileName');
              await storageRef.putData(bytes);

              // Get download URL
              final downloadURL = await storageRef.getDownloadURL();

              // Update Firestore
              final userRef =
                  FirebaseFirestore.instance.collection('users').doc(uid);
              await userRef.update({
                widget.reportType: FieldValue.arrayUnion([downloadURL]),
              });

              // Show success dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Report Saved'),
                    content:
                        const Text('Your report has been saved successfully.'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('View Reports'),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewReports()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            }

            setState(() {
              _isSaving = false;
            });
            setState(() {
              _isSaved = true;
            });
          } catch (e) {
            setState(() {
              _isSaving = false;
            });
            setState(() {
              _isSaved = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error processing PDF: $e')),
            );
          }
        }
      }
      ref.read(eventCountProvider.notifier).incrementEventCount();
    }

    return Scaffold(
      appBar: AppBar(
        title: MyAppBarTitleWithAI(
          title: widget.title ?? 'Report',
        ),
        actions: kIsWeb
            ? []
            : [
                if (!kIsWeb)
                  _isSaved
                      ? const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.check_circle),
                        )
                      : _isSaving
                          ? const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: MySpinKitWaveSpinner(
                                size: 35,
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.save),
                              onPressed: () =>
                                  saveAndSharePDF(context, false), // Save PDF
                            ),
              ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!kIsWeb)
              if (Platform.isIOS) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                  child: Text(
                    medicalDisclaimer,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Center(
                  child: TextButton.icon(
                    onPressed: () => _showSourcesAndCitationsDialog(context),
                    label: const Text("View Sources And Citations"),
                    icon: const Icon(Icons.link_rounded),
                  ),
                )
              ],
            mySpacing(spacing: 2),
            _buildHeader(context),
            _buildSection(
              title: 'Summary',
              icon: Icons.notes,
              color: theme.cardTheme.color!,
              children: [_buildParagraph(widget.summaryContent)],
            ),
            _buildSection(
              title: 'Key Insights',
              icon: Icons.lightbulb_outline,
              color: theme.cardTheme.color!,
              children: _buildBulletPoints(widget.keyInsights),
            ),
            _buildSection(
              title: "Recommendations",
              icon: Icons.list_rounded,
              color: theme.cardTheme.color!,
              children: _buildToDoItems(widget.recommendations),
            ),
            _buildSection(
              title: 'Sources & Citations',
              icon: Icons.link,
              color: theme.cardTheme.color!,
              children: buildCitationLinks(
                widget.citations,
                widget.enableManualCitations ? [] : [],
              ),
            ),
            _buildSection(
              title: 'Follow Up Search Terms',
              icon: Icons.directions_run,
              color: theme.cardTheme.color!,
              children: buildSearchTerms(widget.followUpSearchTerms),
            ),
            //  if (widget.selectedImages != null && widget.selectedImages!.isNotEmpty)
            //   _buildSection(
            //     title: 'Analyzed Images',
            //     icon: Icons.image,
            //     color: theme.cardTheme.color!,
            //     children: widget.selectedImages!.map((file) => Image.file(file, height: 200)).toList(),
            //   ),
            mySpacing(spacing: 80),
          ],
        ),
      ),
      floatingActionButton: kIsWeb
          ? myEmptySizedBox()
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!kIsWeb)
                  _isSaving
                      ? const MySpinKitWaveSpinner(
                          size: 35,
                        )
                      : _isSaved
                          ? myEmptySizedBox()
                          : IconButton(
                              icon: const Icon(
                                Icons.save,
                              ),
                              onPressed: () =>
                                  saveAndSharePDF(context, false), // Save PDF
                            ),
                if (Platform.isAndroid)
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () =>
                        saveAndSharePDF(context, true), // Share PDF
                  ),
              ],
            ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildParagraph(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        content,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  List<Widget> _buildBulletPoints(List<String> points) {
    return points
        .map((point) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.health_and_safety_rounded),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  List<Widget> _buildToDoItems(List<String> items) {
    return items
        .map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_outline, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }

  Widget _buildHeader(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    final now = DateTime.now();
    final formattedDateWithoutTime = DateFormat('yyyy-MM-dd').format(now);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userData!.lastName!.isEmpty
                ? "Report created for: Name Not Provided"
                : "Report created for: ${userData.firstName} ${userData.lastName}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'Created on: $formattedDateWithoutTime',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  void _showSourcesAndCitationsDialog(BuildContext context) {
    // Combine dynamic citations with manual citations if enabled
    List<String> allCitations = [...widget.citations];
    if (widget.enableManualCitations) {
      allCitations.add("");
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sources & Citations'),
          content: SingleChildScrollView(
            child: ListBody(
              children: allCitations.map((citation) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: InkWell(
                    onTap: () async {
                      if (await canLaunchUrl(Uri.parse(citation))) {
                        await launchUrl(Uri.parse(citation));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch $citation')),
                        );
                      }
                    },
                    child: Text(
                      citation,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                );
              }).toList(),
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
}
