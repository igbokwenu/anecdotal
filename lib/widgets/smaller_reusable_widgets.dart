import 'package:anecdotal/utils/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

class MyCircularImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final bool isAsset;
  final bool hasBorder; // New parameter to toggle border

  const MyCircularImage({
    super.key,
    required this.imageUrl,
    this.size = 150.0,
    this.isAsset = true,
    this.hasBorder = true, // Default to showing border
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: hasBorder // Conditionally show border
            ? Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .tertiary, // Use default theme color
                width: 4.0, // You can adjust the border width if needed
              )
            : null, // No border if hasBorder is false
        image: DecorationImage(
          fit: BoxFit.contain,
          image: isAsset
              ? AssetImage(imageUrl) as ImageProvider
              : NetworkImage(imageUrl),
        ),
      ),
    );
  }
}

class PrivacyAndTermsButton extends StatelessWidget {
  final bool showAbout;
  const PrivacyAndTermsButton({super.key, this.showAbout = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.terms);
            },
            child: Text(
              'Terms of Service',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          const Text(
            '|',
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.privacy);
            },
            child: Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          if (showAbout)
            const Text(
              '|',
            ),
          if (showAbout)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.about);
              },
              child: Text(
                'About',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          if (kIsWeb)
            const Text(
              '|',
            ),
          if (kIsWeb)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.download);
              },
              child: Text(
                'Download',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
        ],
      ),
    );
  }
}

Widget mySizedBox({double? height}) {
  return SizedBox(
    height: height ?? 20,
  );
}

Widget myEmptySizedBox() {
  return const SizedBox.shrink();
}

Widget mySpacing({double? spacing}) {
  return Gap(
    spacing ?? 10,
  );
}

class MySpinKitWaveSpinner extends StatelessWidget {
  final double? size;
  const MySpinKitWaveSpinner({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return SpinKitWaveSpinner(
      color: Theme.of(context).iconTheme.color!,
      waveColor: Theme.of(context).iconTheme.color!,
      size: size ?? 50,
    );
  }
}

class MyAnimatedText extends StatelessWidget {
  final String text;
  const MyAnimatedText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorizeColors = [
      Theme.of(context)
          .colorScheme
          .primary, // Primary color (teal in both themes)
      Theme.of(context)
          .colorScheme
          .secondary, // Secondary color (tealAccent in both themes)
      Theme.of(context)
          .colorScheme
          .tertiary, // Tertiary color (lighter teal shades in both themes)
      Theme.of(context)
          .colorScheme
          .onPrimary, // OnPrimary color (white in light theme, black in dark theme)
      Theme.of(context)
          .colorScheme
          .onSecondary, // OnSecondary color (white in light theme, black in dark theme)
    ];

    final colorizeTextStyle = Theme.of(context).textTheme.bodyMedium!;
    return AnimatedTextKit(
      animatedTexts: [
        ColorizeAnimatedText(
          text,
          textStyle: colorizeTextStyle,
          colors: colorizeColors,
        ),
      ],
      repeatForever: true,
    );
  }
}

class MyAnimatedText2 extends StatelessWidget {
  const MyAnimatedText2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorizeColors = [
      Theme.of(context)
          .colorScheme
          .primary, // Primary color (teal in both themes)
      Theme.of(context)
          .colorScheme
          .secondary, // Secondary color (tealAccent in both themes)
      Theme.of(context)
          .colorScheme
          .tertiary, // Tertiary color (lighter teal shades in both themes)
      Theme.of(context)
          .colorScheme
          .onPrimary, // OnPrimary color (white in light theme, black in dark theme)
      Theme.of(context)
          .colorScheme
          .onSecondary, // OnSecondary color (white in light theme, black in dark theme)
    ];

    final colorizeTextStyle = Theme.of(context).textTheme.bodyMedium!;
    return AnimatedTextKit(
      animatedTexts: [
        ColorizeAnimatedText(
          "Doing some AI magic, please wait...",
          textStyle: colorizeTextStyle,
          colors: colorizeColors,
        ),
      ],
      repeatForever: true,
    );
  }
}
