import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

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
    );
  }
}

class MyAnimatedText2 extends StatelessWidget {
  
  const MyAnimatedText2({super.key, });

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
    );
  }
}
