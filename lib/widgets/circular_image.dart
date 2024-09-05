import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool isAsset;

  const CircularImage({
    Key? key,
    required this.imageUrl,
    this.size = 100.0,
    this.isAsset = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.contain,
          image: isAsset
              ? AssetImage(
                  imageUrl,
                ) as ImageProvider
              : NetworkImage(imageUrl),
        ),
      ),
    );
  }
}
