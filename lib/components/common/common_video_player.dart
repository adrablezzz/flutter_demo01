import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class CommonVideoPlayer extends StatefulWidget {
  final String url;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  
  const CommonVideoPlayer({
    Key? key, 
    required this.url, 
    this.autoPlay=false,
    this.looping=false,
    this.showControls=true,
  }) : super(key: key);

  @override
  State<CommonVideoPlayer> createState() => _CommonVideoPlayerState();
}

class _CommonVideoPlayerState extends State<CommonVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _videoController = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoController,
            autoPlay: widget.autoPlay,
            looping: widget.looping,
            showControls: widget.showControls,
            customControls: MinimalControls(), // 使用自定义控件
            allowFullScreen: true,
            allowMuting: false,
            showControlsOnInitialize: true,
          );
        });
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null) {
      return Center(child: CircularProgressIndicator());
    }
    return GestureDetector(
      onTap: () {
        final chewieController = _chewieController!;
        final isPlaying =
            chewieController.videoPlayerController.value.isPlaying;

        if (isPlaying) {
          chewieController.pause();
        } else {
          chewieController.play();
        }
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: Chewie(controller: _chewieController!),
        ),
      ),
    );
  }
}

class MinimalControls extends StatefulWidget {
  const MinimalControls({super.key});

  @override
  State<MinimalControls> createState() => _MinimalControlsState();
}

class _MinimalControlsState extends State<MinimalControls> {
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }



  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chewieController = ChewieController.of(context);
    final controller = chewieController.videoPlayerController;

    return ValueListenableBuilder<VideoPlayerValue>(
    valueListenable: controller,
    builder: (context, value, child) {
      final isPlaying = value.isPlaying;
      final position = value.position;
      final duration = value.duration ?? Duration.zero;

      return Stack(
        children: [
          // 播放按钮
          Center(
            child: !isPlaying
                ? IconButton(
                    iconSize: 48,
                    color: Colors.white,
                    icon: Icon(Icons.play_circle),
                    onPressed: () => controller.play(),
                  )
                : const SizedBox.shrink(),
          ),

          // 底部时间进度条
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        '/',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        _formatDuration(duration),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: VideoProgressIndicator(
                      controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.white,
                        bufferedColor: Colors.grey,
                        backgroundColor: Colors.white30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      );
    },
  );
  }
}
