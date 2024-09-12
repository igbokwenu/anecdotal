import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';


class AIImageSelectWidget extends StatefulWidget {
  final String prompt;
  final Function(Map<String, dynamic>?) onResponse;
  final bool allowFileSelect;
  final int maxImages;
  final String? selectButtonText;
  final String? analyzeButtonText;

  const AIImageSelectWidget(
      {super.key,
      required this.prompt,
      required this.onResponse,
      this.allowFileSelect = false,
      this.maxImages = 4,
      this.selectButtonText = 'Select Image', this.analyzeButtonText = 'Analyze Image'});

  @override
  _AIImageSelectWidgetState createState() => _AIImageSelectWidgetState();
}

class _AIImageSelectWidgetState extends State<AIImageSelectWidget> {
  final List<File> _selectedFiles = [];
  bool _isAnalyzing = false;

  Future<void> _pickImages() async {
    List<XFile>? pickedFiles;
    if (widget.allowFileSelect) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        allowMultiple: true,
      );
      if (result != null) {
        pickedFiles = result.files.map((file) => XFile(file.path!)).toList();
      }
    } else {
      final ImagePicker picker = ImagePicker();
      pickedFiles = await picker.pickMultiImage();
    }

    if (pickedFiles != null) {
      setState(() {
        _selectedFiles.addAll(pickedFiles!
            .map((xFile) => File(xFile.path))
            .take(widget.maxImages - _selectedFiles.length));
      });
    }
  }

  Future<void> _analyzeImages() async {
    if (_selectedFiles.isEmpty) return;

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final response = await GeminiService.analyzeImages(
        images: _selectedFiles,
        prompt: widget.prompt,
      );

      widget.onResponse(response);
    } catch (e) {
      print('Error analyzing images: $e');
      widget.onResponse(null);
    } finally {
      setState(() {
        _isAnalyzing = false;
        _selectedFiles.clear(); // Clear the selected files after analysis
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        mySpacing(spacing: 16),
        ElevatedButton.icon(
          onPressed: _pickImages,
          label: Text(widget.allowFileSelect
              ? 'Select Files'
              : widget.selectButtonText!),
          icon: const Icon(Icons.attach_file),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Only images are currently supported. We are working towards adding support for uploading documents.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        if (_selectedFiles.isNotEmpty) ...[
          // mySpacing(spacing: 8),
          widget.allowFileSelect
              ? const Text(
                  "Can't show preview, click button below to analyze selected files.",
                  textAlign: TextAlign.center,
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedFiles
                      .map((file) => Image.file(file,
                          width: 100, height: 100, fit: BoxFit.cover))
                      .toList(),
                ),
        ],
        mySpacing(spacing: 16),
        ElevatedButton.icon(
          onPressed:
              _selectedFiles.isEmpty || _isAnalyzing ? null : _analyzeImages,
          label: _isAnalyzing
              ? const MySpinKitWaveSpinner(size: 40)
              : Text(
                  widget.allowFileSelect ? 'Analyze Files' : widget.analyzeButtonText!),
          icon: const Icon(Icons.auto_awesome),
        ),
      ],
    );
  }
}
