import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/home/widgets/page_view_choose_media.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class ImageEditorScreen extends StatelessWidget {
  final List<AssetEntity> assetImage;

  const ImageEditorScreen({super.key, required this.assetImage});
  @override
  Widget build(BuildContext context) {
    final media = AppImages.imgAvatarDefault; // put your local image here

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF0F0F10),
        body: Column(
          children: [
            _buildTopBar(context),
            Expanded(child: const SizedBox()),
            PageViewChooseMedia(assetImage: assetImage),
            Expanded(child: const SizedBox()),
            // Bottom control row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _controlButton(
                          icon: Icons.music_note,
                          label: 'Âm thanh',
                        ),
                        _controlButton(
                          icon: Icons.text_fields,
                          label: 'Văn bản',
                        ),
                        _controlButton(icon: Icons.layers, label: 'Lớp phủ'),
                        _controlButton(
                          icon: Icons.filter_alt_outlined,
                          label: 'Bộ lọc',
                        ),
                        _controlButton(icon: Icons.tune, label: 'Chỉnh sửa'),
                      ],
                    ),
                  ),

                  SizedBox(width: 12),

                  // Continue button
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pushNamed(PathName.uploadPostPage,extra: assetImage);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        backgroundColor: AppColors.blue60,
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Tiếp',
                            style: AppStyles.title2Bold.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _controlButton({required icon, required label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: Colors.white),
        ),
        SizedBox(height: 6),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.white70)),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
      child: Row(
        children: [
          // Close icon
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white12,
              ),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.close, size: 20, color: Colors.white),
            ),
          ),

          SizedBox(width: 12),

          // Audio chip (avatar + title + plus)
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage(AppImages.imgAvatarDefault),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lại Vũ • Chỉ',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Âm thanh gợi ý',
                          style: TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white12,
                    ),
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.add, size: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
