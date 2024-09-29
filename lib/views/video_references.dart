import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/database_service.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/utils/reusable_function.dart';
import 'package:anecdotal/views/citations_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  final String videoId;
  final String title;
  final String description;
  bool isRecommended;

  Video({
    required this.videoId,
    required this.title,
    required this.description,
    this.isRecommended = false,
  });
}

class VideoResourceView extends ConsumerStatefulWidget {
  const VideoResourceView({super.key});

  @override
  VideoResourceViewState createState() => VideoResourceViewState();
}

class VideoResourceViewState extends ConsumerState<VideoResourceView> {
  final List<Video> videos = [
    Video(
      videoId: '_7Nj1JOp2ik',
      title: 'A Crash Course On Mycotoxins',
      description:
          'Dr. Jin W. Sung gives a crash course on mycotoxins and how they cause debilitating symptoms.',
      isRecommended: true,
    ),
    Video(
      videoId: 'OEDp36gGEiA',
      title: 'No One Believes You Are Sick?',
      description:
          'Dr. Cameron Jones talks about how mycotoxins cause debilitating symptoms.',
    ),
    Video(
      videoId: '9P7_W4IZspk',
      title: 'Were You Misdiagnosed?',
      description:
          'Biotoxin illnesses are often misdiagnosed as Fibromyalgia, CFS, CPS, POTs, MS, ADHD etc.',
      isRecommended: true,
    ),
    Video(
      videoId: 'kcili1K9lmQ',
      title: 'Chronic Illness Pandemic In The US?',
      description:
          "Dhru Purohit sits down with attorney Kristina Baehr to talk about her family's personal experience with environmental mycotoxins and their journey to seek justice for the emotional, medical, and financial damages they suffered due to the resulting chronic illness.",
      isRecommended: true,
    ),
    Video(
      videoId: 'LGG7om1hHcU',
      title: 'An Interview With Dr. Scott McMahon & Dr. Ritchie Shoemaker',
      description:
          'Dr. Scott McMahon & Dr. Ritchie Shoemaker sit for an interview with Dr. Jordan Peterson on how biotoxin illness is a major health "epidemic".',
      isRecommended: true,
    ),
    Video(
      videoId: 'fbaUkC7Cse4',
      title: 'Never been Sicker?',
      description:
          'Michael Rubino sits down with Dr. Neil Nathan, M.D., a researcher in complex chronic medical conditions.',
    ),
    Video(
      videoId: 'BKkL1I772a8',
      title: 'Long Covid or biotoxin illness?',
      description:
          'Dr. Lauren Tessier, ND, talks about how she witnessed a spike in biotoxin induced illness during the Covid lock downs.',
    ),
    Video(
      videoId: 'IV311tl01uo',
      title: 'How Mycotoxins Affect the Brain',
      description:
          'Biotoxin illnesses causes multiple neurological and psychiatric symptoms that are often misdiagnosed.',
      isRecommended: true,
    ),
    Video(
      videoId: 'jRj8b2YaGjM',
      title: 'Story Time With Olivia Farabaugh',
      description:
          'Olivia Farabaugh shares the story of her journey with biotoxin illness.',
      isRecommended: true,
    ),
    Video(
      videoId: 'vgAOwhu2nUE',
      title: 'Story Time With The Spanish Guitar Hub',
      description:
          'The Spanish Guitar Hub shares the story of her journey with biotoxin illness.',
      isRecommended: true,
    ),
    Video(
      videoId: 'PmCNRWWmZiA',
      title: 'In The News: The Bear Family',
      description:
          'A story of how biotoxin illness affects people in the news.',
      isRecommended: true,
    ),
    Video(
      videoId: 'ZqwKoh1jCTc',
      title: 'In The News: A Military Family Speaks Up',
      description:
          'A story of how biotoxin illness affects people in the news.',
    ),
    Video(
      videoId: '9G-T0bNLUss',
      title: 'Natural Remedies by Dr. John Axe ',
      description:
          'For those dealing with mold induced biotoxin illness who (for financial or whatever reason) are not yet able to see a healthcare practitioner, here are some home remedies you can try out - by Dr. Josh Axe.',
      isRecommended: true,
    ),
  ];

  YoutubePlayerController? _controller;

  void _toggleRecommended(Video video) {
    setState(() {
      video.isRecommended = !video.isRecommended;
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    final databaseService = DatabaseService(uid: uid!);

    void playVideo(Video video) {
      setState(() {
        if (_controller == null) {
          _controller = YoutubePlayerController.fromVideoId(
            videoId: video.videoId,
            autoPlay: true,
            params: const YoutubePlayerParams(showFullscreenButton: false),
          );
        } else {
          _controller!.loadVideoById(videoId: video.videoId);
        }

        if (!userData!.watchedVideoUrls.contains(video.videoId)) {
          databaseService.updateAnyUserData(
            fieldName: userWatchedVideoUrls,
            newValue: FieldValue.arrayUnion(
              [video.videoId],
            ),
          );
        }
      });
    }

    List<Video> sortedVideos = [...videos];
    sortedVideos.sort((a, b) {
      if (userData!.watchedVideoUrls.contains(a.videoId) &&
          !userData.watchedVideoUrls.contains(b.videoId)) return 1;
      if (!userData.watchedVideoUrls.contains(a.videoId) &&
          userData.watchedVideoUrls.contains(b.videoId)) return -1;
      return 0;
    });

    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: MyAppBarTitleWithAI(title: 'Video Resources'))),
      body: Column(
        children: [
          if (_controller != null)
            YoutubePlayerScaffold(
              controller: _controller!,
              aspectRatio: 16 / 9,
              builder: (context, player) {
                return player;
              },
            ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedVideos.length,
              itemBuilder: (context, index) {
                final video = sortedVideos[index];
                return VideoCard(
                  video: video,
                  onPlay: playVideo,
                  isWatched: userData!.watchedVideoUrls.contains(video.videoId),
                );
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CitationLinks(),
                ),
              );
            },
            label: const Text('Citations'),
            icon: const Icon(Icons.link),
          ),
          mySpacing(spacing: 18)
        ],
      ),
    );
  }
}

class VideoCard extends ConsumerWidget {
  final Video video;
  final Function(Video) onPlay;

  final bool isWatched;

  const VideoCard({
    super.key,
    required this.video,
    required this.onPlay,
    required this.isWatched,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                'https://img.youtube.com/vi/${video.videoId}/0.jpg',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              IconButton(
                icon: Icon(CupertinoIcons.play_circle_fill,
                    size: 50, color: Colors.teal[500]),
                onPressed: () => onPlay(video),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(video.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(video.description),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Watch on YouTube'),
                      onPressed: () {
                        MyReusableFunctions.launchCustomUrl(
                            'https://www.youtube.com/watch?v=${video.videoId}');
                      },
                    ),
                    if (video.isRecommended ||
                        userData!.watchedVideoUrls.contains(video.videoId))
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 8,
                        children: [
                          if (video.isRecommended &&
                              !userData!.watchedVideoUrls
                                  .contains(video.videoId))
                            const Text(
                              ' Recommended ',
                              style: TextStyle(
                                  fontSize: 12, backgroundColor: Colors.green),
                            ),
                          if (userData!.watchedVideoUrls
                              .contains(video.videoId))
                            const Text(
                              ' Watched ',
                              style: TextStyle(
                                fontSize: 12,
                                backgroundColor: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
