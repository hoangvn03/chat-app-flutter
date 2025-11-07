import 'package:chat_app/main/utils/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:go_router/go_router.dart';

import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:chat_app/main/ui/home/widgets/page_view_choose_media.dart';

class UploadPostPage extends StatefulWidget {
  final List<AssetEntity> assetImage;

  const UploadPostPage({super.key, required this.assetImage});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  bool _aiTag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leadingWidth: 36,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Transform.flip(
              flipX: true,
              child: SvgPicture.asset(
                AppImages.icNextRight,
                color: AppColors.white,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
        title: Text(
          'Bài viết mới',
          style: AppStyles.title1Bold.copyWith(color: AppColors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Ảnh / video preview
            const SizedBox(height: 8),
            PageViewChooseMedia(assetImage: widget.assetImage),

            const SizedBox(height: 12),
            _buildAddNote(),

            const SizedBox(height: 24),
            commonTileItemV2(
              title: 'Thêm nhạc',
              titleStyle: AppStyles.bodyRegular.copyWith(
                color: AppColors.white,
              ),

              margin: const EdgeInsets.symmetric(vertical: 12),
              leadingWidget: const Icon(Icons.music_note, color: Colors.white),
              onTap: () {},
            ),
            commonTileItemV2(
              title: 'Gắn thẻ người khác',
              margin: const EdgeInsets.symmetric(vertical: 12),
              titleStyle: AppStyles.bodyRegular.copyWith(
                color: AppColors.white,
              ),

              leadingWidget: const Icon(
                Icons.person_outline,
                color: Colors.white,
              ),
              onTap: () {},
            ),
            commonTileItemV2(
              title: 'Thêm vị trí',
              margin: const EdgeInsets.symmetric(vertical: 12),
              titleStyle: AppStyles.bodyRegular.copyWith(
                color: AppColors.white,
              ),

              leadingWidget: const Icon(
                Icons.location_on_outlined,
                color: Colors.white,
              ),
              onTap: () {},
            ),

            // 🔹 Mục có switch
            commonTileItemV2(
              title: 'Thêm nhãn AI',
              margin: const EdgeInsets.symmetric(vertical: 12),
              titleStyle: AppStyles.bodyRegular.copyWith(
                color: AppColors.white,
              ),
              subTitleStyle: AppStyles.bodyRegular.copyWith(
                color: AppColors.gray20,
              ),
              subtitle:
                  'Chúng tôi yêu cầu bạn gắn nhãn cho nội dung được tạo bằng AI và cảm giác như thật. Tìm hiểu thêm',
              leadingWidget: const Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
              ),
              trallingWidget: Switch(
                value: _aiTag,
                onChanged: (v) => setState(() => _aiTag = v),
                activeColor: AppColors.blue20,
              ),
            ),

            commonTileItemV2(
              title: 'Đối tượng',
              margin: const EdgeInsets.symmetric(vertical: 12),
              titleStyle: AppStyles.bodyRegular.copyWith(
                color: AppColors.white,
              ),

              leadingWidget: const Icon(
                Icons.visibility_outlined,
                color: Colors.white,
              ),
              trallingWidget: Text(
                'Người theo dõi',
                style: AppStyles.bodyRegular.copyWith(color: Colors.grey),
              ),
              onTap: () {},
            ),
            commonTileItemV2(
              title: 'Cũng chia sẻ trên...',
              margin: const EdgeInsets.symmetric(vertical: 12),
              titleStyle: AppStyles.bodyRegular.copyWith(
                color: AppColors.white,
              ),

              leadingWidget: const Icon(
                Icons.share_outlined,
                color: Colors.white,
              ),
              trallingWidget: Text(
                'Tắt  Mới',
                style: AppStyles.bodyRegular.copyWith(color: Colors.grey),
              ),
              onTap: () {},
            ),
            commonTileItemV2(
              title: 'Lựa chọn khác',
              margin: const EdgeInsets.symmetric(vertical: 12),
              titleStyle: AppStyles.bodyRegular.copyWith(
                color: AppColors.white,
              ),
              leadingWidget: const Icon(Icons.more_horiz, color: Colors.white),
              onTap: () {},
            ),

            // commonButton(text: 'Chia sẻ', onTap: () {},margin: EdgeInsets.zero),
            const SizedBox(height: 90),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.black,
          border: const Border(
            top: BorderSide(
              color: AppColors.gray60, // 🎨 màu border bạn muốn
              width: 1, // 📏 độ dày border
            ),
          ),
        ),
        child: commonButton(
          radius: 8,
          text: 'Chia sẻ',
          onTap: () {},
          margin: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildAddNote() {
    return GestureDetector(
      onTap: () {},
      child: Text(
        'Thêm chú thích...',
        style: AppStyles.bodyRegular.copyWith(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {String? trailingText}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: AppStyles.bodyRegular.copyWith(color: Colors.white),
      ),
      trailing:
          trailingText != null
              ? Text(
                trailingText,
                style: AppStyles.bodyRegular.copyWith(color: Colors.grey),
              )
              : const Icon(Icons.chevron_right, color: Colors.white54),
      onTap: () {},
    );
  }

  Widget _buildSwitchItem(String title, String description) {
    bool isSwitched = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return ListTile(
          leading: const Icon(Icons.smart_toy_outlined, color: Colors.white),
          title: Text(
            title,
            style: AppStyles.bodyRegular.copyWith(color: Colors.white),
          ),
          subtitle: Text(
            description,
            style: AppStyles.bodyRegular.copyWith(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          trailing: Switch(
            value: isSwitched,
            onChanged: (val) => setState(() => isSwitched = val),
            activeColor: AppColors.blue20,
          ),
        );
      },
    );
  }

  Widget _buildShareButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue20,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Chia sẻ',
          style: AppStyles.title1Bold.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
