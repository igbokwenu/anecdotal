import 'dart:io';
import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'dart:math' as math;

class OldAICameraCameraWidget extends StatefulWidget {
  final String prompt;
  final Function(Map<String, dynamic>?) onAnalysisComplete;
  final bool enableFlash;
  final bool enableZoom;
  final String? preferredModel;

  const OldAICameraCameraWidget({
    super.key,
    required this.prompt,
    required this.onAnalysisComplete,
    this.enableFlash = true,
    this.enableZoom = true,
    this.preferredModel,
  });

  @override
  _OldAICameraCameraWidgetState createState() => _OldAICameraCameraWidgetState();
}

class _OldAICameraCameraWidgetState extends State<OldAICameraCameraWidget> {
  CameraController? _controller;
  List<CameraDescription> cameras = [];
  int selectedCameraIdx = 0;
  File? _imageFile;
  bool _isAnalyzing = false;
  double _currentZoomLevel = 1.0;
  double _baseZoomLevel = 1.0;
  FlashMode _currentFlashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    final firstCamera = cameras.first;

    if (cameras.isNotEmpty) {
      _controller = CameraController(
        cameras[selectedCameraIdx],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await _controller!.initialize();
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    if (!_controller!.value.isInitialized) {
      return;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath =
        join(dirPath, '${DateTime.now().millisecondsSinceEpoch}.jpg');

    try {
      XFile picture = await _controller!.takePicture();
      setState(() {
        _imageFile = File(picture.path);
        _isAnalyzing = true;
      });

      // Perform image analysis
      List<File> images = [_imageFile!];
      Map<String, dynamic>? result = await GeminiService.analyzeImages(
        images: images,
        prompt: widget.prompt,
        preferredModel: widget.preferredModel,
      );

      widget.onAnalysisComplete(result);

      setState(() {
        _isAnalyzing = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isAnalyzing = false;
      });
      widget.onAnalysisComplete(null); // Call with null in case of error
    }
  }

  void _toggleCameraLens() {
    selectedCameraIdx =
        selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    _initCameraController(selectedCamera);
  }

  Future<void> _initCameraController(
      CameraDescription cameraDescription) async {
    _controller = CameraController(cameraDescription, ResolutionPreset.high);

    try {
      await _controller!.initialize();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void _handleZoomUpdate(ScaleUpdateDetails details) {
    setState(() {
      _currentZoomLevel = (_baseZoomLevel * details.scale).clamp(1.0, 5.0);
      _controller?.setZoomLevel(_currentZoomLevel);
    });
  }

  void _toggleFlash() {
    if (_currentFlashMode == FlashMode.off) {
      _currentFlashMode = FlashMode.always;
    } else {
      _currentFlashMode = FlashMode.off;
    }
    _controller?.setFlashMode(_currentFlashMode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container();
    }

    // Apply a transformation to correct the orientation if necessary
    // You may need to adjust the angle based on your specific case (e.g., 90, 180, 270)
    final cameraPreview = Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(0)
        ..rotateZ(math.pi / 2), // Rotate by 180 degrees
      child: CameraPreview(_controller!),
    );

    return Column(
      children: [
        GestureDetector(
          onScaleStart: (_) => _baseZoomLevel = _currentZoomLevel,
          onScaleUpdate: widget.enableZoom ? _handleZoomUpdate : null,
          child: cameraPreview,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.switch_camera),
                onPressed: _toggleCameraLens,
              ),
              IconButton(
                icon: _isAnalyzing
                    ? const MySpinKitWaveSpinner(
                        size: 40,
                      )
                    : const Icon(Icons.camera),
                onPressed: _isAnalyzing ? null : _captureImage,
              ),
              if (widget.enableFlash)
                IconButton(
                  icon: Icon(_currentFlashMode == FlashMode.off
                      ? Icons.flash_off
                      : Icons.flash_on),
                  onPressed: _toggleFlash,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
