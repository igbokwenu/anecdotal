import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(-0.1, 0),
      end: const Offset(0.1, 0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animated background image
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ClipRect(
                child: OverflowBox(
                  alignment: Alignment.center,
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: FractionalTranslation(
                    translation: _animation.value,
                    child: Image.asset(
                      'assets/images/happy_group_copy_818x818.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * 1.2,
                      height: MediaQuery.of(context).size.height,
                    ),
                  ),
                ),
              );
            },
          ),
          // Content overlay
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Heal Smarter',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                ),
                mySpacing(),
                Text(
                  "A soothing space to find answers, heal, and connect with others who truly understand 🤍.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.authWrapper);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
