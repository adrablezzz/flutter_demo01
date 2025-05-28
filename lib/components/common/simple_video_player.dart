/*
 * @Date: 2025-05-14 13:42:58
 * @LastEditTime: 2025-05-15 11:52:37
 */
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SimpleVideoPlayer extends StatefulWidget {
  final String url;
  final bool autoPlay;
  final bool looping;
  final bool showControls;

  const SimpleVideoPlayer({
    Key? key,
    required this.url,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
  }) : super(key: key);

  @override
  _SimpleVideoPlayerState createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        if (widget.autoPlay) {
          _controller.play();
        }
        print('视频宽度： ${_controller.value.size.width}');
      });
    _controller.setLooping(widget.looping);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildControls() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: Icon(
        _controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
        size: 48,
        color: Colors.white70,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return SizedBox(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return SizedBox(
      child: Align(
        alignment: Alignment.centerLeft, // 视频靠左
        child: Stack(
          alignment: Alignment.center, // 图标居中于视频
          children: [
            SizedBox(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            if (widget.showControls) _buildControls(),
          ],
        ),
      ),
    );
  }
}
