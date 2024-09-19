import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isSquare;
  final double? width;
  final double? height;

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
    return Container(
      width: width,
      height: height,
      child: AspectRatio(
        aspectRatio: isSquare
            ? 1
            : (width != null && height != null ? width! / height! : 16 / 8),
        child: Container(
          margin: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12.0),
            color: Colors
                .transparent, // Make the Material transparent for the ripple effect
            child: InkWell(
              onTap: onTap,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
        ),
      ),
    );
  }
}

// Usage example:
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Image Containers')),
      body: Column(
        children: [
          // Rectangular container
          ImageContainer(
            imagePath: 'assets/rectangle_image.jpg',
            title: 'Rectangular Image',
            subtitle: 'This is a rectangular container',
            onTap: () {
              print('Rectangular container tapped');
            },
            width: deviceWidth > 600
                ? 600
                : deviceWidth, // Set max width for tablet portrait
            height: 200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Square container 1
              ImageContainer(
                imagePath: 'assets/square_image1.jpg',
                title: 'Square 1',
                subtitle: 'Square container',
                onTap: () {
                  print('Square container 1 tapped');
                },
                isSquare: true,
                width: deviceWidth > 600
                    ? 200
                    : deviceWidth / 2 - 16, // Adjust width for tablets
                height: deviceWidth > 600
                    ? 200
                    : deviceWidth / 2 - 16, // Adjust height for tablets
              ),
              // Square container 2
              ImageContainer(
                imagePath: 'assets/square_image2.jpg',
                title: 'Square 2',
                subtitle: 'Square container',
                onTap: () {
                  print('Square container 2 tapped');
                },
                isSquare: true,
                width: deviceWidth > 600 ? 200 : deviceWidth / 2 - 16,
                height: deviceWidth > 600 ? 200 : deviceWidth / 2 - 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
