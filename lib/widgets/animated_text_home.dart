import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedText extends StatelessWidget {
  const AnimatedText({super.key});

  @override
  Widget build(BuildContext context) {
    Duration duration = const Duration(milliseconds: 3000);
    Duration typerDuration = const Duration(milliseconds: 70);

    return Column(
      children: [
        DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!,
          child: AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(
                'Talk To Us',
                speed: typerDuration,
              ),
              TyperAnimatedText(
                "We Understand 🤍",
                speed: typerDuration,
              ),
              TyperAnimatedText(
                'Here Are Some Questions You Can Ask',
                speed: typerDuration,
              ),
              FadeAnimatedText(
                'I am having muscle spasms.',
                duration: duration,
              ),
              FadeAnimatedText(
                'I am having food intolerance.',
                duration: duration,
              ),
              FadeAnimatedText(
                "How do I start treatment?",
                duration: duration,
              ),
              FadeAnimatedText(
                'My eye lids are twitching.',
                duration: duration,
              ),
              FadeAnimatedText(
                "I can't afford a doctor, what can I do?",
                duration: duration,
              ),
              FadeAnimatedText(
                "Could my house be making me sick?",
                duration: duration,
              ),
              FadeAnimatedText(
                "How do I know I have mold illness?",
                duration: duration,
              ),
              FadeAnimatedText(
                "Doctors say it's all in my head.",
                duration: duration,
              ),
              ScaleAnimatedText(
                'Will I ever get better?',
                duration: duration,
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
