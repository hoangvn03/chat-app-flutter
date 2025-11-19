import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class PageViewChooseMedia extends StatelessWidget {
  final List<Uint8List> assetImage;

  const PageViewChooseMedia({super.key, required this.assetImage});
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: Colors.black12,
                child: Image.memory(
                  assetImage[index],
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
