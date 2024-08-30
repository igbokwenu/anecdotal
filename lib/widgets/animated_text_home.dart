import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedText extends StatelessWidget {
  const AnimatedText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Talk To Us - We Understand 🤍",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!,
          child: AnimatedTextKit(
            animatedTexts: [
              RotateAnimatedText(
                'I am having muscle spasms and twitches.',
              ),
              RotateAnimatedText(
                "My family does not believe that I am sick.",
              ),
              RotateAnimatedText(
                'I am having food intolerance.',
              ),
              RotateAnimatedText(
                "How do I start treating CIRS/Mold Illness?",
              ),
              RotateAnimatedText(
                "I can't afford a doctor, what can I do?",
              ),
              RotateAnimatedText(
                "Could my house be making me sick?",
              ),
              RotateAnimatedText(
                "Doctors are saying it's all in my head.",
              ),
            ],
            repeatForever: true,
            pause: const Duration(milliseconds: 1000),
          ),
        ),
      ],
    );
  }
}
