import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PageViewChooseMedia extends StatelessWidget {
  final List<String> assetImage;

  const PageViewChooseMedia({super.key, required this.assetImage});

  bool isVideo(String path) {
    final ext = path.toLowerCase();
    return ext.endsWith(".mp4") ||
        ext.endsWith(".mov") ||
        ext.endsWith(".avi") ||
        ext.endsWith(".mkv");
  }

  Future<ImageProvider> getVideoThumbnail(String path) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 300,
      quality: 90,
    );

    return MemoryImage(thumbnail!);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: PageController(
          viewportFraction: assetImage.length > 1 ? 0.9 : 1,
        ),
        itemCount: assetImage.length,
        itemBuilder: (context, index) {
          final path = assetImage[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: Colors.black12,
                child: isVideo(path)
                    ? FutureBuilder<ImageProvider>(
                        future: getVideoThumbnail(path),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return Stack(
                            children: [
                              Positioned.fill(
                                child: Image(
                                  image: snapshot.data!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Center(
                                child: Icon(Icons.play_circle_fill,
                                    size: 64, color: Colors.white),
                              )
                            ],
                          );
                        },
                      )
                    : Image.file(
                        File(path),
                        fit: BoxFit.cover,
                        width: 250,
                        height: 250,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          );
                        },
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
