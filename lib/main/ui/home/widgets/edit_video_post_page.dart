import 'dart:typed_data';
import 'dart:io';

import 'package:chat_app/main/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pro_video_editor/pro_video_editor.dart';
import 'package:path_provider/path_provider.dart';


class VideoEditorScreen extends StatefulWidget {
  final File videoFile;

  const VideoEditorScreen({super.key, required this.videoFile});

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen> {
  Uint8List? editedVideoBytes;
  double startSeconds = 0;
  double endSeconds = 10;

  bool isRendering = false;

  // Convert Uint8List → File
  Future<File> saveBytesToFile(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/edited_video.mp4");
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F10),
        body: Column(
          children: [
            Expanded(
              child: editedVideoBytes == null
                  ? Center(child: Text("Nhấn chỉnh sửa để bắt đầu", style: TextStyle(color: Colors.white)))
                  : Center(
                      child: Text("Video đã render xong", style: TextStyle(color: Colors.white)),
                    ),
            ),

            /// CHỈNH START - END TIME
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text("Điểm bắt đầu: ${startSeconds.toStringAsFixed(1)}s",
                      style: const TextStyle(color: Colors.white)),
                  Slider(
                    value: startSeconds,
                    min: 0,
                    max: 30,
                    onChanged: (v) => setState(() => startSeconds = v),
                  ),
                  Text("Điểm kết thúc: ${endSeconds.toStringAsFixed(1)}s",
                      style: const TextStyle(color: Colors.white)),
                  Slider(
                    value: endSeconds,
                    min: 0,
                    max: 30,
                    onChanged: (v) => setState(() => endSeconds = v),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// NÚT CHỈNH SỬA VIDEO
            ElevatedButton(
              onPressed: () async {
                setState(() => isRendering = true);

                final data = RenderVideoModel.withQualityPreset(
                  video: EditorVideo.file(widget.videoFile),
                  qualityPreset: VideoQualityPreset.p720,
                  startTime: Duration(seconds: startSeconds.toInt()),
                  endTime: Duration(seconds: endSeconds.toInt()),
                );

                Uint8List renderedBytes =
                    await ProVideoEditor.instance.renderVideo(data);

                setState(() {
                  editedVideoBytes = renderedBytes;
                  isRendering = false;
                });
              },
              child: const Text("Chỉnh sửa video"),
            ),

            const SizedBox(height: 8),

            if (isRendering)
              StreamBuilder<ProgressModel>(
                stream: ProVideoEditor.instance.progressStream,
                builder: (context, snapshot) {
                  double progress = snapshot.data?.progress ?? 0;
                  return Column(
                    children: [
                      CircularProgressIndicator(value: progress),
                      const SizedBox(height: 10),
                      Text(
                        "${(progress * 100).toStringAsFixed(1)}%",
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  );
                },
              ),

            const SizedBox(height: 20),

            /// NÚT TIẾP TỤC
            if (editedVideoBytes != null)
              ElevatedButton(
                onPressed: () async {
                  File output = await saveBytesToFile(editedVideoBytes!);
                  context.pushNamed(
                    PathName.uploadPostPage,
                    extra: [output],
                  );
                },
                child: const Text("Tiếp tục với video đã chỉnh sửa"),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
