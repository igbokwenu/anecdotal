import 'package:flutter/material.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/view_widgets.dart/video_player_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:anecdotal/widgets/theme_toggle_button.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktopOrTablet = screenWidth > 600;

    // Single source of truth for content
    final content = {
      'title': 'Meet Anecdotal AI',
      'videoTitle': 'Watch Our Demo Video',
      'videoUrl':
          demoVideoAfroTech,
      'appTitle': 'Your Personal Health Companion',
      'appDescription':
          'Rethinking healthcare: from profit-driven to patient-centric. Anecdotal AI helps shorten the distance between symptoms and diagnosis of chronic illnesses. '
              'Track and evaluate your symptoms, investigate your home, get personalized health insights, and connect with others '
              'who share your journey.',
      'callToAction':
          'Download the app today and jump-start your healing journey!',
      'playStoreUrl':
          'https://play.google.com/store/apps/details?id=com.increasedw.anecdotal',
      'appStoreUrl': 'https://apps.apple.com/app/anecdotal-ai/id6670702224',
    };

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Center(
          child: MyAppBarTitleWithAI(
            title: content['title']!,
          ),
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
            child: isDesktopOrTablet
                ? _buildDesktopTabletLayout(context, isDarkMode, content)
                : _buildMobileLayout(context, isDarkMode, content),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTabletLayout(
      BuildContext context, bool isDarkMode, Map<String, String> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        mySpacing(spacing: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildVideoSection(context, content),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: _buildAppInfoSection(context, isDarkMode, content),
            ),
          ],
        ),
        mySpacing(),
        const Divider(),
        const PrivacyAndTermsButton(
          showAbout: true,
          showDownload: false,
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
      BuildContext context, bool isDarkMode, Map<String, String> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildVideoSection(context, content),
        const SizedBox(height: 20),
        _buildAppInfoSection(context, isDarkMode, content),
        mySpacing(),
        const Divider(),
        const PrivacyAndTermsButton(
          showAbout: true,
          showDownload: false,
        ),
      ],
    );
  }

  Widget _buildVideoSection(BuildContext context, Map<String, String> content) {
    return Column(
      children: [
        Text(
          content['videoTitle']!,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const Divider(),
        mySpacing(),
        VideoPlayerWidget(
          videoUrl: content['videoUrl']!,
          height: 469,
          width: 264,
        ),
      ],
    );
  }

  Widget _buildAppInfoSection(
      BuildContext context, bool isDarkMode, Map<String, String> content) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktopOrTablet = screenWidth > 600;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isDesktopOrTablet) ...[
          mySpacing(spacing: 30),
          const MyCircularImage(
            imageUrl: logoAssetImageUrlNoTagLine,
            size: 200,
          ),
          mySpacing(spacing: 20),
        ],
        Text(
          content['appTitle']!,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          content['appDescription']!,
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
              onTap: () =>
                  MyReusableFunctions.launchCustomUrl(url: content['playStoreUrl']!),
            ),
            const SizedBox(width: 20),
            _DownloadButton(
              image: isDarkMode
                  ? 'assets/images/app_store_onlight.png'
                  : 'assets/images/app_store_ondark.png',
              onTap: () =>
                  MyReusableFunctions.launchCustomUrl(url: content['appStoreUrl']!),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          content['callToAction']!,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
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
