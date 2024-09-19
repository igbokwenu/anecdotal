import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isSquare;
  final double? width;
  final double? height;

  // Default sizes
  static const double defaultRectangleWidth = 340.0;
  static const double defaultRectangleHeight = 180.0;
  static const double defaultSquareSize = 170.0;

  const ImageContainer({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isSquare = false,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerWidth = width ??
            (isSquare
                ? defaultSquareSize
                : (constraints.maxWidth > defaultRectangleWidth
                    ? defaultRectangleWidth
                    : constraints.maxWidth));

        double containerHeight = height ??
            (isSquare
                ? defaultSquareSize
                : (isSquare ? containerWidth : defaultRectangleHeight));

        return Container(
          width: containerWidth,
          height: containerHeight,
          margin: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap, // Trigger the callback
              borderRadius: BorderRadius.circular(12.0),
              splashColor: Colors.white.withOpacity(0.3),
              highlightColor: Colors.white.withOpacity(0.1),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      imagePath,
                      width: containerWidth,
                      height: containerHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSquare ? 18 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: isSquare ? 12 : 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
