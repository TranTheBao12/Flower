import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FlowerCareGuide extends StatefulWidget {
  const FlowerCareGuide({Key? key}) : super(key: key);

  @override
  _FlowerCareGuideState createState() => _FlowerCareGuideState();
}

class _FlowerCareGuideState extends State<FlowerCareGuide> {
  // Danh sách video (URL và tiêu đề)
  final List<Map<String, String>> videos = [
    {
      'title': 'Hướng dẫn chăm sóc hoa cơ bản',
      'url': 'https://www.youtube.com/watch?v=hmptFw_f8zM',
    },
    {
      'title': 'Chăm sóc hoa hồng tại nhà',
      'url': 'https://www.youtube.com/watch?v=FZiMPvxrKeI',
    },
    {
      'title': 'Mẹo trồng và chăm sóc hoa lan',
      'url': 'https://www.youtube.com/watch?v=3yO9K_nGrbY',
    },
  ];

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Khởi tạo bộ điều khiển với video đầu tiên
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videos[0]['url']!)!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hướng Dẫn Chăm Hoa'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  YoutubePlayerBuilder(
                    player: YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId:
                        YoutubePlayer.convertUrlToId(video['url']!)!,
                        flags: const YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                    ),
                    builder: (context, player) => player,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
