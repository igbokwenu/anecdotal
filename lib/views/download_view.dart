import 'package:anecdotal/utils/constants.dart';
import 'package:anecdotal/widgets/smaller_reusable_widgets.dart';
import 'package:flutter/material.dart';

class AnecdotalDownloadPage extends StatelessWidget {
  const AnecdotalDownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Anecdotal',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 40),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/anecdotal_demo.png',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Your Personal Health Companion',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Anecdotal is a revolutionary health app that helps you track, analyze, and improve your well-being. With personalized insights and easy-to-use features, taking control of your health has never been easier.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _DownloadButton(
                      image: isDarkMode
                          ? 'assets/google_play_dark.png'
                          : 'assets/google_play_light.png',
                      onTap: () {
                        // TODO: Implement Google Play download
                      },
                    ),
                    const SizedBox(width: 20),
                    _DownloadButton(
                      image: isDarkMode
                          ? 'assets/app_store_dark.png'
                          : 'assets/app_store_light.png',
                      onTap: () {
                        // TODO: Implement App Store download
                      },
                    ),
                  ],
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
        height: 60,
      ),
    );
  }
}

class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              MyCircularImage(
                imageUrl: logoAssetImageUrlWithTagLine,
                size: 300,
              ),
              // Demo image of the app
              // Image.asset('assets/images/anecdotal_1000.png', height: 200),

              // Write-up about the app
              const SizedBox(height: 20),
              const Text(
                'Anecdotal: Your Health Companion',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Discover a healthier you with Anecdotal. Track your fitness, monitor your health, and get personalized recommendations to improve your well-being.',
                style: TextStyle(fontSize: 16),
              ),

              // Download buttons
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Google Play download button
                  Image.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? 'assets/images/play_store_ondark.png'
                        : 'assets/images/play_store_onlight.png',
                    height: 50,
                  ),

                  // Apple App Store download button
                  Image.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? 'assets/images/app_store_ondark.png'
                        : 'assets/images/app_store_onlight.png',
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DownloadView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Detect if the app is in dark or light mode
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Download Anecdotal"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App demo image
            Image.asset(
              'assets/images/anecdotal_demo.png', // Replace with your app demo image
              height: 300,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            
            // App write-up
            Text(
              'Anecdotal is your companion app for managing chronic illness. '
              'Track symptoms, get personalized health insights, and connect with others '
              'who share your journey. Available now on Android and iOS.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            
            // Download buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Google Play button
                GestureDetector(
                  onTap: () {
                    // Add your Google Play download link here
                  },
                  child: Image.asset(
                    isDarkMode 
                        ? 'assets/images/google_play_dark.png' // Dark mode image
                        : 'assets/images/google_play_light.png', // Light mode image
                    height: 50,
                  ),
                ),
                // Apple App Store button
                GestureDetector(
                  onTap: () {
                    // Add your App Store download link here
                  },
                  child: Image.asset(
                    isDarkMode 
                        ? 'assets/images/app_store_dark.png' // Dark mode image
                        : 'assets/images/app_store_light.png', // Light mode image
                    height: 50,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            
            // Footer (Optional)
            Text(
              'Get the app now and start your journey to better health!',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
