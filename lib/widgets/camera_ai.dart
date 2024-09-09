import 'dart:io';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
                    if (single.file != null) {
                      setState(() {
                        _isLoading = true;
                        _capturedImage = File(single.file!.path);
                      });
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
            bottomActionsBuilder: (state) {
              return AwesomeBottomActions(
                state: state,
                onMediaTap: null,
                captureButton: _isLoading
                    ? const MySpinKitWaveSpinner(
                        size: 80,
                      )
                    : AwesomeCaptureButton(
                        state: state,
                      ),
              );
            },
          ),
          Positioned(
            top: 80,
            left: MediaQuery.sizeOf(context).width / 2 - 22,
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.highlight_off,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
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
      setState(() {
        _isLoading = false;
      });
    }
  }
}
