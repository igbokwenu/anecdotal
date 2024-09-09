import 'dart:io';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraWidget extends StatefulWidget {
  final String prompt;
  final Function(Map<String, dynamic>?) onResponse;
  final VoidCallback onComplete;

  const CameraWidget({
    super.key,
    required this.prompt,
    required this.onResponse,
    required this.onComplete,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  final FlashMode _flashMode = FlashMode.auto;
  final double _zoom = 0.0;
  File? _capturedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Camera widget from camerawesome package
          CameraAwesomeBuilder.awesome(
            sensorConfig: SensorConfig.single(
              sensor: Sensor.position(SensorPosition.back),
              flashMode: _flashMode,
              aspectRatio: CameraAspectRatios.ratio_4_3,
              zoom: _zoom,
            ),
            onMediaCaptureEvent: (event) async {
              if (event.isPicture &&
                  event.status == MediaCaptureStatus.success) {
                event.captureRequest.when(
                  single: (single) async {
                    // Convert XFile to File
                    if (single.file != null) {
                      _capturedImage = File(single.file!.path);
                      await _analyzeCapturedImage();
                    }
                  },
                  multiple: (multiple) {},
                );
              }
            },
            saveConfig: SaveConfig.photo(
              pathBuilder: (sensors) async {
                final Directory extDir = await getTemporaryDirectory();
                final String filePath =
                    '${extDir.path}/camerawesome_${DateTime.now().millisecondsSinceEpoch}.jpg';
                return SingleCaptureRequest(filePath, sensors.first);
              },
            ),
          ),

          // UI for flash toggle and zoom controls
          const Positioned(
            top: 50,
            right: 20,
            child: Column(
              children: [
                // IconButton(
                //   icon: Icon(Icons.flash_on),
                //   onPressed: () {
                //     setState(() {
                //       _flashMode = _flashMode == FlashMode.auto
                //           ? FlashMode.on
                //           : FlashMode.auto;
                //     });
                //   },
                // ),
                // Slider(
                //   value: _zoom,
                //   min: 0.0,
                //   max: 1.0,
                //   onChanged: (value) {
                //     setState(() {
                //       _zoom = value;
                //     });
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _analyzeCapturedImage() async {
    if (_capturedImage != null) {
      final response = await GeminiService.analyzeImages(
        images: [_capturedImage!],
        prompt: widget.prompt,
      );
      widget.onResponse(response);
      widget.onComplete();
    }
  }
}
