import 'dart:typed_data';
import 'package:chat_app/main/router/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageEditorScreen extends StatefulWidget {
  const ImageEditorScreen({super.key, required this.assetImage});
  final List<AssetEntity> assetImage;

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  Uint8List? editedImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F10),
        body: Column(
          children: [
            Expanded(
              child:
                  editedImage != null
                      ? Image.memory(editedImage!)
                      : PageView.builder(
                        itemCount: widget.assetImage.length,
                        itemBuilder: (context, index) {
                          final asset = widget.assetImage[index];
                          return FutureBuilder<Uint8List?>(
                            future: asset.thumbnailDataWithSize(
                              const ThumbnailSize(1080, 1920),
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final imageBytes = snapshot.data!;
                              return GestureDetector(
                                onTap: () async {
                                  // Mở trình chỉnh sửa
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => ProImageEditor.memory(
                                            imageBytes,
                                            callbacks: ProImageEditorCallbacks(
                                              onImageEditingComplete: (
                                                Uint8List bytes,
                                              ) async {
                                                setState(() {
                                                  editedImage = bytes;
                                                });
                                                Navigator.pop(context, bytes);
                                              },
                                            ),
                                          ),
                                    ),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      editedImage = result as Uint8List;
                                    });
                                  }
                                },
                                child: Image.memory(
                                  imageBytes,
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
            const SizedBox(height: 12),
            if (editedImage != null)
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(
                    PathName.uploadPostPage,
                    extra: [editedImage!],
                  );
                },
                child: const Text("Tiếp tục với ảnh đã chỉnh sửa"),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
