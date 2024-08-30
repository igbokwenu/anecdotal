import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedText extends StatelessWidget {
  const AnimatedText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!,
          child: AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(
                'Talk To Us',
              ),
              TyperAnimatedText(
                "We Understand 🤍",
              ),
              TyperAnimatedText(
                'Here Are Questions You Can Ask',
              ),
              FadeAnimatedText(
                'I am having muscle spasms and twitches.',
              ),
              FadeAnimatedText(
                "My family does not believe that I am sick.",
              ),
              FadeAnimatedText(
                'I am having food intolerance.',
              ),
              FadeAnimatedText(
                "How do I start treating CIRS/Mold Illness?",
              ),
              FadeAnimatedText(
                "I can't afford a doctor, what can I do?",
              ),
              FadeAnimatedText(
                "Could my house be making me sick?",
              ),
              FadeAnimatedText(
                "Doctors are saying it's all in my head.",
              ),
              ScaleAnimatedText(
                'Will I ever get better?',
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
