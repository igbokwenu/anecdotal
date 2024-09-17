import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/view_widgets.dart/youtube_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:anecdotal/widgets/theme_toggle_button.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: MyAppBarTitleWithAI(title: "Meet Anecdotal AI"),
        ),
        actions: const [
          ThemeToggle(),
          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Watch Our Demo Video',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                mySpacing(),
                const YouTubeShortsWidget(
                    videoUrl:
                        'https://youtu.be/vn_v-qgZrgo?si=9Guxb38ZbGG0R8dx',
                    width: 150,
                    height: 266.5),
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
                  'Anecdotal AI is your companion app for managing chronic illness. '
                  'Track and evaluate symptoms, investigate your home, get personalized health insights, and connect with others '
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
                        MyReusableFunctions.launchCustomUrl(
                            'https://play.google.com/store/apps/details?id=com.increasedw.anecdotal');
                      },
                    ),
                    const SizedBox(width: 20),
                    _DownloadButton(
                      image: isDarkMode
                          ? 'assets/images/app_store_onlight.png'
                          : 'assets/images/app_store_ondark.png',
                      onTap: () {
                        MyReusableFunctions.launchCustomUrl(
                            'https://testflight.apple.com/join/2aWq4CRM');
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
                const MyCircularImage(
                  imageUrl: logoAssetImageUrlNoTagLine,
                  size: 100,
                ),
                mySpacing(),
                const Divider(),
                const PrivacyAndTermsButton(
                  showAbout: true,
                  showDownload: false,
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
