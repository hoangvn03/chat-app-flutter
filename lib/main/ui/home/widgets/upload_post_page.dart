import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/home/bloc/home_bloc.dart';
import 'package:chat_app/main/ui/home/bloc/home_event.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final TextEditingController _noteController = TextEditingController();
  late HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>(); // Lưu lại bloc
  }

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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
          onTap: () {
            
            context.pushNamed(
              PathName.homePage,
              extra: [_noteController.text.trim(), 'Hà Nội', widget.assetImage],
            );
            // context.read<HomeBloc>().add(
            //   CreatePost(
            //     caption: _noteController.text.trim(),
            //     location: 'Hà Nội',
            //     assetImage: widget.assetImage,
            //   ),
            // );
            // context.goNamed(PathName.homePage);
          },
          margin: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildAddNote() {
    return TextField(
      textAlignVertical: TextAlignVertical.center,
      controller: _noteController,
      style: AppStyles.bodyRegular.copyWith(color: AppColors.white),
      onChanged: (_) {},
      decoration: InputDecoration(
        hintText: 'Thêm chú thích...',
        hintStyle: AppStyles.bodyRegular.copyWith(color: AppColors.white),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        fillColor: AppColors.gray20,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon:
            _noteController.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    print('Nội dung: ${_noteController.text}');
                    _noteController.clear();
                  },
                )
                : null,
      ),
    );
  }
}
