import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MediaItem extends StatelessWidget {
  MediaItem({super.key, this.media});
  List<Media>? media;
  @override
  Widget build(BuildContext context) {
    return _buildPostContent();
  }

  Widget _buildPostContent() {
    final mediaList = media ?? [];
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
          return CachedNetworkImage(
            imageUrl: media.mediaUrl ?? '',
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder:
                (context, url) =>
                    const Center(child: CircularProgressIndicator()),
            errorWidget:
                (context, url, error) =>
                    const Center(child: Icon(Icons.broken_image)),
          );
        },
      ),
    );
  }
}
