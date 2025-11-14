import 'package:chat_app/main/ui/reels/widgets/media_picked/widget/all_album_media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_bloc.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_event.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_state.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';

class MediaHeaderOption extends StatelessWidget {
  final PageController pageController;

  const MediaHeaderOption({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickedBloc, MediaPickedState>(
      builder: (context, state) {
        if (state is! MediaPickedSuccess) {
          return const SizedBox();
        }

        final isSelecting = state.isSelecting ?? false;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PopupMenuButton(
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
              color: AppColors.gray60.withOpacity(0.95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              offset: const Offset(0, 60),
              itemBuilder: (context) => [
                _menuItem(
                  context,
                  icon: AppImages.icLogoAppV2,
                  title: "Mới đây",
                  type: RequestType.common,
                  onTap: () {
                    context.read<MediaPickedBloc>().add(
                          LoadRequest(
                            requestType: RequestType.common,
                            maxCount: 5,
                            nameRequestType: 'Mới đây',
                          ),
                        );
                  },
                ),
                _menuItem(
                  context,
                  icon: AppImages.icPictureGallery,
                  title: "Ảnh",
                  type: RequestType.image,
                  onTap: () {
                    context.read<MediaPickedBloc>().add(
                          LoadRequest(
                            requestType: RequestType.image,
                            maxCount: 5,
                            nameRequestType: 'Ảnh',
                          ),
                        );
                  },
                ),
                _menuItem(
                  context,
                  icon: AppImages.icReelsActive,
                  title: "Video",
                  type: RequestType.video,
                  onTap: () {
                    context.read<MediaPickedBloc>().add(
                          LoadRequest(
                            requestType: RequestType.video,
                            maxCount: 5,
                            nameRequestType: 'Video',
                          ),
                        );
                  },
                ),
                PopupMenuItem(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.black,
                      context: context,
                      useSafeArea: true,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (_) {
                        return BlocProvider.value(
                          value: context.read<MediaPickedBloc>(),
                          child: AlbumBottomSheet(
                            pageController: pageController,
                            album: state.album,
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.icGridDark,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Tất cả album",
                        style: AppStyles.title2Regular.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      state.nameRequestType ??
                          state.selectedAlbum?.name ??
                          'Mới đây',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Transform.flip(
                      flipY: true,
                      child: SvgPicture.asset(
                        AppImages.icChevronUp,
                        width: 16,
                        height: 16,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelecting ? AppColors.gray20 : AppColors.gray80,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                color: AppColors.white,
                onPressed: () {
                  if (isSelecting) {
                    state.selectedAsset?.clear();
                  }
                  context.read<MediaPickedBloc>().add(
                        ChooseMedia(isSelecting: !isSelecting),
                      );
                },
                icon: SvgPicture.asset(
                  AppImages.icGallery,
                  color: isSelecting ? AppColors.gray80 : AppColors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  PopupMenuItem _menuItem(
    BuildContext context, {
    required String icon,
    required String title,
    required RequestType type,
    required VoidCallback onTap,
  }) {
    return PopupMenuItem(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(icon, color: AppColors.white),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppStyles.title2Regular.copyWith(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
