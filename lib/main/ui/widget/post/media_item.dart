import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chat_app/main/networks/model/post.dart'; // import model Media của bạn

class MediaItem extends StatefulWidget {
  final List<Media>? media;
  const MediaItem({super.key, this.media});

  @override
  State<MediaItem> createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem> {
  late final List<VideoPlayerController?> _videoControllers;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoControllers();
  }

  void _initializeVideoControllers() {
    final mediaList = widget.media ?? [];
    _videoControllers = List<VideoPlayerController?>.filled(
      mediaList.length,
      null,
    );

    for (int i = 0; i < mediaList.length; i++) {
      final media = mediaList[i];
      if (media.mediaType == 'video' && media.mediaUrl != null) {
        final controller = VideoPlayerController.network(media.mediaUrl!);
        _videoControllers[i] = controller;

        controller.initialize().then((_) {
          if (!_isDisposed && mounted) {
            controller.setLooping(true);
            controller.play();
            setState(() {});
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    for (final controller in _videoControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaList = widget.media ?? [];
    if (mediaList.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text('Không có media')),
      );
    }

    return SizedBox(
      height:
          400, // bạn có thể thay đổi chiều cao hoặc dùng MediaQuery để responsive
      child: PageView.builder(
        itemCount: mediaList.length,
        itemBuilder: (context, index) {
          final media = mediaList[index];
          if (media.mediaType == 'video') {
            return _buildVideoPlayer(index);
          } else {
            return _buildImage(media);
          }
        },
      ),
    );
  }

  Widget _buildVideoPlayer(int index) {
    final controller = _videoControllers[index];
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
        setState(() {}); // refresh icon
      },
      child: Container(
        color: Colors.black, // nền đen

        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: FittedBox(
                fit: BoxFit.contain, // giữ tỉ lệ, không crop
                alignment: Alignment.center,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
            if (!controller.value.isPlaying)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black26,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Icon(Icons.videocam, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Media media) {
    return Container(
      color: Colors.black, // nền đen

      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: media.mediaUrl ?? '',
            fit: BoxFit.contain, // giữ tỉ lệ gốc
            width: double.infinity,
            placeholder:
                (context, url) =>
                    const Center(child: CircularProgressIndicator()),
            errorWidget:
                (context, url, error) =>
                    const Center(child: Icon(Icons.broken_image)),
          ),
          if (media.mediaType == 'video')
            Positioned(
              bottom: 10,
              right: 10,
              child: Icon(Icons.videocam, color: Colors.white, size: 24),
            ),
        ],
      ),
    );
  }
}
