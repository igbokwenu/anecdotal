import 'package:anecdotal/services/gemini_ai_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CustomCamera extends StatefulWidget {
  final String prompt;
  final Function(Map<String, dynamic>?) onResponse;

  const CustomCamera({
    super.key,
    required this.prompt,
    required this.onResponse,
  });

  @override
  _CustomCameraState createState() => _CustomCameraState();
}

class _CustomCameraState extends State<CustomCamera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _enableFlash = false;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      cameras[0], // Make sure to get available cameras first
      ResolutionPreset.max,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final XFile file = await _controller.takePicture();
      final File imageFile = File(file.path);

      final response = await GeminiService.analyzeImages(
        images: [imageFile],
        prompt: widget.prompt,
      );

      widget.onResponse(response);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              CameraPreview(_controller),
              Positioned(
                bottom: 20,
                left: MediaQuery.of(context).size.width / 2 - 30,
                child: FloatingActionButton(
                  onPressed: _takePicture,
                  child: const Icon(Icons.camera),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: Icon(_enableFlash ? Icons.flash_on : Icons.flash_off),
                  onPressed: () {
                    setState(() {
                      _enableFlash = !_enableFlash;
                      _controller.setFlashMode(
                        _enableFlash ? FlashMode.torch : FlashMode.off,
                      );
                    });
                  },
                ),
              ),
              Positioned(
                top: 80,
                right: 20,
                child: Slider(
                  value: _zoomLevel,
                  min: 1.0,
                  max: 10.0,
                  onChanged: (value) {
                    setState(() {
                      _zoomLevel = value;
                      _controller.setZoomLevel(value);
                    });
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom Camera Example')),
        body: CustomCamera(
          prompt: 'Analyze this image',
          onResponse: (response) {
            print('Received response: $response');
          },
        ),
      ),
    );
  }
}
