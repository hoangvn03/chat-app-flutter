import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<AssetEntity> assets = [];

  Future<void> _fetchAssets() async {
    assets = await PhotoManager.getAssetListRange(
      start: 0,
      end: 100000,
    );

    setState(() {});
  }

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: assets.length,
        itemBuilder: (_, index) {
          return AssetThumbnail(
            asset: assets[index],
          );
        },
      ),
    );
  }
}
class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    super.key,
    required this.asset,
  });

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: asset.thumbnailData.then((value) => value!),
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null) return const CircularProgressIndicator();
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  if (asset.type == AssetType.image) {
                    // If this is an image, navigate to ImageScreen
                    return ImageView(
                      imageFile: asset.file,
                    );
                  } else {
                    // if it's not, navigate to VideoScreen
                    return VideoView(
                      videoFile: asset.file,
                    );
                  }
                },
              ),
            );
          },
          child: Stack(
            children: [
              // Wrap the image in a Positioned.fill to fill the space
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              // Display a Play icon if the asset is a video
              if (asset.type == AssetType.video)
                Center(
                  child: Container(
                    color: Colors.blue,
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
class ImageView extends StatelessWidget {
  const ImageView({
    Key? key,
    required this.imageFile,
  }) : super(key: key);

  final Future<File?> imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: FutureBuilder<File>(
        future: imageFile.then((value) => value!),
        builder: (_, snapshot) {
          final file = snapshot.data;
          if (file == null) return Container();
          return PhotoView(
            imageProvider: FileImage(file),
          );
        },
      ),
    );
  }
}
class VideoView extends StatefulWidget {
  const VideoView({
    Key? key,
    required this.videoFile,
  }) : super(key: key);

  final Future<File?> videoFile;

  @override
  State createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late final VideoPlayerController _videoPlayerController;
  late final ChewieController _chewieController;
  late final Chewie videoPlayerWidget;
  bool initialized = false;

  _initVideo() async {
    final video = await widget.videoFile;
    _videoPlayerController = VideoPlayerController.file(video!)
      ..setLooping(true)
      ..initialize().then(
        (_) => setState(() => initialized = true),
      );
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );

    videoPlayerWidget = Chewie(
      controller: _chewieController,
    );
  }

  @override
  void initState() {
    _initVideo();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: initialized
          // If the video is initialized, display it
          ? Scaffold(
              body: Center(
                child: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: videoPlayerWidget,
                ),
              ),
            )
          // If the video is not yet initialized, display a spinner
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}