import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class MediaItem extends StatefulWidget {
  MediaItem({super.key, this.media});
  List<Media>? media;

  @override
  State<MediaItem> createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem> {
  List<VideoPlayerController?> _videoControllers = [];
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
        _videoControllers[i] = VideoPlayerController.network(media.mediaUrl!)
          ..initialize().then((_) {
            if (!_isDisposed && mounted) {
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
    return _buildPostContent();
  }

  Widget _buildPostContent() {
    final mediaList = widget.media ?? [];
    if (mediaList.isEmpty) {
      return const SizedBox(
        height: 300,
        child: Center(child: Text('Không có ảnh')),
      );
    }

    return SizedBox(
      height: 300,
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

    return Stack(
      fit: StackFit.expand,
      children: [
        VideoPlayer(controller),
        Positioned(
          bottom: 10,
          right: 10,
          child: Icon(Icons.videocam, color: Colors.white, size: 24),
        ),
      ],
    );
  }

  Widget _buildImage(Media media) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: media.mediaUrl ?? '',
          fit: BoxFit.cover,
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
    );
  }
}
