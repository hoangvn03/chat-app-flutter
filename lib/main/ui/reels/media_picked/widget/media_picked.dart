import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/reels/media_picked/bloc/media_picked_bloc.dart';
import 'package:chat_app/main/ui/reels/media_picked/bloc/media_picked_event.dart';
import 'package:chat_app/main/ui/reels/media_picked/bloc/media_picked_state.dart';
import 'package:chat_app/main/ui/reels/media_picked/widget/media_picked.dart';
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

// ignore: must_be_immutable
class MediaGridView extends StatelessWidget {
  MediaGridView({super.key, this.onTap});
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocListener<MediaPickedBloc, MediaPickedState>(
          listener: (context, state) {
            if (state is MediaPickedSuccess && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: BlocBuilder<MediaPickedBloc, MediaPickedState>(
            builder: (context, state) {
              if (state is MediaPickedSuccess) {
                final assetList = state.asset;
                final selectedAssets = state.selectedAsset ?? [];

                return GridView.builder(
                  padding: const EdgeInsets.all(2),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: assetList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildCameraButton(context, state, selectedAssets);
                    }
                    final asset = assetList[index - 1];
                    return _assetWidget(asset);
                  },
                );
              } else if (state is MediaPickedFailure) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: AppStyles.bodyBold.copyWith(color: Colors.white),
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _buildListAssetSelected(context),
        ),
      ],
    );
  }

  Widget _assetWidget(AssetEntity asset) {
    return BlocBuilder<MediaPickedBloc, MediaPickedState>(
      builder: (context, state) {
        if (state is MediaPickedSuccess) {
          final selectedAssets = state.selectedAsset ?? [];
          final isSelected = selectedAssets.contains(asset);
          final indexSelected =
              isSelected ? selectedAssets.indexOf(asset) + 1 : null;

          return GestureDetector(
            onTap: () {
              if (selectedAssets.isNotEmpty || state.isSelecting == true) {
                context.read<MediaPickedBloc>().add(
                  ChooseMedia(asset: asset, isSelecting: true),
                );
              } else {
                context
                    .pushNamed(PathName.createReelsPage, extra: [asset])
                    .then((_) {
                      state.selectedAsset?.clear();
                      state.isSelecting = false;
                    });
              }
            },
            onLongPress: () {
              context.read<MediaPickedBloc>().add(
                ChooseMedia(asset: asset, isSelecting: true),
              );
            },
            child: Stack(
              children: [
                // ảnh nền
                Positioned.fill(
                  child: AssetEntityImage(
                    asset,
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

                // icon video nếu có
                if (asset.type == AssetType.video)
                  Positioned(
                    right: 5,
                    bottom: 5,
                    child: SvgPicture.asset(
                      AppImages.icReelsActive,
                      width: 24,
                      height: 24,
                      color: AppColors.gray30,
                    ),
                  ),

                // vòng tròn số thứ tự chọn
                if (state.isSelecting == true)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isSelected ? AppColors.blue40 : AppColors.gray60,
                          width: 1,
                        ),
                        color:
                            isSelected ? AppColors.blue40 : Colors.transparent,
                      ),
                      child: Center(
                        child:
                            isSelected
                                ? Text(
                                  '$indexSelected',
                                  style: AppStyles.calloutRegular.copyWith(
                                    color: Colors.white,
                                  ),
                                )
                                : null,
                      ),
                    ),
                  ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildCameraButton(
    BuildContext context,
    MediaPickedSuccess state,
    List<AssetEntity> selectedAssets,
  ) {
    return GestureDetector(
      onTap: () {
        if (selectedAssets.isEmpty) {
          context.pushNamed(PathName.cameraPage).then((_) {
            state.selectedAsset?.clear();
            state.isSelecting = false;
          });
        }
      },
      child: Container(
        color: selectedAssets.isEmpty ? AppColors.gray60 : AppColors.gray80,
        child: const Center(
          child: Icon(Icons.camera_alt, size: 32, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildListAssetSelected(BuildContext context) {
    return BlocBuilder<MediaPickedBloc, MediaPickedState>(
      builder: (context, state) {
        if (state is MediaPickedSuccess &&
            (state.selectedAsset?.isNotEmpty ?? false)) {
          final assetList = state.selectedAsset!;

          return Container(
            height: 80,
            decoration: BoxDecoration(color: AppColors.gray90.withOpacity(0.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.4,
                        ),
                    itemCount: assetList.length,
                    itemBuilder: (context, index) {
                      final asset = assetList[index];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: AssetEntityImage(
                              asset,
                              width: 32,
                              height: 64,
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
                            top: 0,
                            right: 8,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.gray60,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  context.read<MediaPickedBloc>().add(
                                    ChooseMedia(asset: asset),
                                  );
                                },
                                icon: SvgPicture.asset(
                                  AppImages.icClose,
                                  width: 8,
                                  height: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                commonButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  text: 'Tiếp',
                  mainWidget: Row(
                    children: [
                      Text('Tiếp', style: AppStyles.title2Regular),
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        AppImages.icChevronRight,
                        width: 16,
                        height: 16,
                      ),
                    ],
                  ),
                  onTap:
                      onTap ??
                      () {
                        print('List Asset: ${state.selectedAsset ?? []}');
                        context
                            .pushNamed(
                              PathName.createReelsPage,
                              extra: state.selectedAsset,
                            )
                            .then((_) {
                              state.selectedAsset?.clear();
                              state.isSelecting = false;
                            });
                      },
                  color: AppColors.white,
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink(); // ẩn hoàn toàn khi không có asset
        }
      },
    );
  }
}
