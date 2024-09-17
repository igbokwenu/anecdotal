import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubeShortsWidget extends StatefulWidget {
  final String videoUrl;
  final double aspectRatio;
  final double width;
  final double height;

  const YouTubeShortsWidget({
    Key? key,
    required this.videoUrl,
    this.aspectRatio = 9 / 16, // Default aspect ratio for portrait mode
    this.width = 300, // Default width for the video container
    this.height = 533, // Default height for the video container
  }) : super(key: key);

  @override
  _YouTubeShortsWidgetState createState() => _YouTubeShortsWidgetState();
}

class _YouTubeShortsWidgetState extends State<YouTubeShortsWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(widget.videoUrl) ?? '',
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        mute: false,
        showControls: true,
        loop: false,
        enableCaption: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .appBarTheme
            .backgroundColor, // Set background color from theme
        borderRadius: BorderRadius.circular(20), // Rounded corners
        border: Border.all(
          color: Theme.of(context)
              .appBarTheme
              .backgroundColor!, // Border color matching the container background
          width: 4, // Border width
        ),
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(20), // Same rounded corners for the video
        child: YoutubePlayerScaffold(
          controller: _controller,
          aspectRatio: widget.aspectRatio,
          builder: (context, player) {
            return player;
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
