import 'dart:io';

import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_bloc.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_event.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class CreateReelsPage extends StatefulWidget {
  CreateReelsPage({required this.listImagePath, super.key});
  List<dynamic> listImagePath;
  @override
  State<CreateReelsPage> createState() => _CreateReelsPageState();
}

class _CreateReelsPageState extends State<CreateReelsPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create:
            (_) =>
                CreateReelsBloc()
                  ..add(LoadReelsMedia(assetList: widget.listImagePath)),
        child: Scaffold(
          backgroundColor: AppColors.black,
          body: Column(
            children: [
              _buildImagePreview(context),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomTab(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          SizedBox(
            height: height * 0.8,
            width: double.infinity,
            child:
                (widget.listImagePath.first is String)
                    ? Image.file(
                      File(widget.listImagePath[0]),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        );
                      },
                    )
                    : AssetEntityImage(
                      widget.listImagePath.first,
                      isOriginal: false,
                      thumbnailSize: const ThumbnailSize.square(250),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        );
                      },
                    ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120, // chiều cao vùng phủ
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54, // đen trong suốt 50%
                  ],
                ),
              ),
            ),
          ),
          Positioned(left: 8, right: 8, top: 12, child: _buildListHeaderIcon()),
          Positioned(left: 16, right: 16, bottom: 16, child: _buildAddNote()),
        ],
      ),
    );
  }

  Widget _buildListHeaderIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton.filledTonal(
          onPressed: () {
            context.pop();
          },
          icon: SvgPicture.asset(
            AppImages.icChevronLeft,
            color: AppColors.white,
          ),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.gray100.withOpacity(0.6),
          ),
        ),
        Spacer(),
        IconButton.filledTonal(
          onPressed: () {},
          icon: SvgPicture.asset(AppImages.icText, color: AppColors.white),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.gray100.withOpacity(0.6),
          ),
        ),
        IconButton.filledTonal(
          onPressed: () {},
          icon: SvgPicture.asset(AppImages.icStickers, color: AppColors.white),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.gray100.withOpacity(0.6),
          ),
        ),
        IconButton.filledTonal(
          onPressed: () {},
          icon: SvgPicture.asset(AppImages.icFilters, color: AppColors.white),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.gray100.withOpacity(0.6),
          ),
        ),
        IconButton.filledTonal(
          onPressed: () {},
          icon: SvgPicture.asset(AppImages.icMusic, color: AppColors.white),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.gray100.withOpacity(0.6),
          ),
        ),
        IconButton.filledTonal(
          onPressed: () {},
          icon: SvgPicture.asset(AppImages.icOption, color: AppColors.white),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.gray100.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildAddNote() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          // isScrollControlled: true,
          backgroundColor: AppColors.gray80,
          builder:
              (context) => Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gray80,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: _buildBottomSheetAddNote(),
              ),
        );
      },
      child: Text(
        'Thêm chú thích...',
        style: AppStyles.bodyRegular.copyWith(color: AppColors.white),
      ),
    );
  }

  Widget _buildBottomSheetAddNote() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconCloseBottomSheet(context),
        Row(
          children: [
            CircleAvatar(
              child: Image.asset(
                AppImages.imgAvatarDefault,
                width: 48,
                height: 48,
              ),
            ),
            Expanded(
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                controller: _textEditingController,
                style: AppStyles.bodyRegular.copyWith(color: AppColors.white),
                onChanged:(_){
                  
                },
                decoration: InputDecoration(
                  hintText: 'Thêm chú thích...',
                  hintStyle: AppStyles.bodyRegular.copyWith(
                    color: AppColors.white,
                  ),
                  
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
                      _textEditingController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () {
                              print('Nội dung: ${_textEditingController.text}');
                              _textEditingController.clear();
                            },
                          )
                          : null, 
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.gray70,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      AppImages.imgAvatarDefault,
                      width: 32,
                      height: 32,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tin của bạn',
                    style: AppStyles.bodyRegular.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.gray70,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppImages.icStartRoundWhite,
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tin của bạn',
                    style: AppStyles.bodyRegular.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              final data = ReelModel(
                assetList: widget.listImagePath,
                media: MediaType.image,
                duration: Duration(seconds: 20),
              );
              context.pushNamed(PathName.listReelsPage, extra: [data]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(AppImages.icChevronRight),
            ),
          ),
        ],
      ),
    );
  }
}
