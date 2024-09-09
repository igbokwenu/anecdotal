import 'package:anecdotal/utils/constants.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(height: 10),
                // Text(
                //   'Anecdotal',
                //   style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                //         fontWeight: FontWeight.bold,
                //         color: Theme.of(context).colorScheme.primary,
                //       ),
                // ),
                mySpacing(),
                const MyCircularImage(
                  imageUrl: logoAssetImageUrlNoTagLine,
                  size: 180,
                ),
                // const SizedBox(height: 20),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(20),
                //   child: Image.asset(
                //     'assets/images/mockup.PNG',
                //     height: 300,
                //     width: double.infinity,
                //     fit: BoxFit.contain,
                //   ),
                // ),
                const SizedBox(height: 20),
                Text(
                  'Your Personal Health Companion',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),
                Text(
                  'Anecdotal is your companion app for managing chronic illness. '
                  'Track and evaluate symptoms, get personalized health insights, and connect with others '
                  'who share your journey. Available now on Android and iOS.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _DownloadButton(
                      image: isDarkMode
                          ? 'assets/images/play_store_onlight.png'
                          : 'assets/images/play_store_ondark.png',
                      onTap: () {
                        MyReusableFunctions.launchCustomUrl('');
                      },
                    ),
                    const SizedBox(width: 20),
                    _DownloadButton(
                      image: isDarkMode
                          ? 'assets/images/app_store_onlight.png'
                          : 'assets/images/app_store_ondark.png',
                      onTap: () {
                        MyReusableFunctions.launchCustomUrl('');
                      },
                    ),
                  ],
                ),
                mySpacing(),
                Text(
                  'Get the app now and start your journey to a better health!',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                mySpacing(),
                const PrivacyAndTermsButton(
                  showAbout: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final String image;
  final VoidCallback onTap;

  const _DownloadButton({
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        image,
        height: 50,
      ),
    );
  }
}
