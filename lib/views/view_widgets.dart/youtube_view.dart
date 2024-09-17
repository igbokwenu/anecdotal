import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class YouTubeShortsWidget extends StatefulWidget {
  final String videoUrl;
  final double aspectRatio;
  final double width;
  final double height;

  const YouTubeShortsWidget({
    Key? key,
    required this.videoUrl,
    this.aspectRatio = 9 / 16,
    this.width = 300,
    this.height = 533,
  }) : super(key: key);

  @override
  _YouTubeShortsWidgetState createState() => _YouTubeShortsWidgetState();
}

class _YouTubeShortsWidgetState extends State<YouTubeShortsWidget> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  String _errorMessage = '';
  String _debugInfo = '';

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: widget.aspectRatio,
        autoPlay: false,
        looping: false,
        showControls: true,
        allowFullScreen: true,
        allowMuting: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      );

      setState(() {});
    } catch (error) {
      print('Error initializing video: $error');
      setState(() {
        _errorMessage = 'Error loading video: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).appBarTheme.backgroundColor!,
          width: 4,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : Center(
                child: _errorMessage.isNotEmpty
                    ? Text(_errorMessage, textAlign: TextAlign.center)
                    : const CircularProgressIndicator(),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
