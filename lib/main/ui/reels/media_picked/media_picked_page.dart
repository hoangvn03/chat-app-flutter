import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/reels/media_picked/bloc/media_picked_bloc.dart';
import 'package:chat_app/main/ui/reels/media_picked/bloc/media_picked_event.dart';
import 'package:chat_app/main/ui/reels/media_picked/bloc/media_picked_state.dart';
import 'package:chat_app/main/ui/reels/media_picked/media_picked.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class MediaPickedPage extends StatefulWidget {
  const MediaPickedPage({super.key});

  @override
  State<MediaPickedPage> createState() => _CreateReelPageState();
}

class _CreateReelPageState extends State<MediaPickedPage> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              MediaPickedBloc()..add(
                LoadRequest(requestType: RequestType.common, maxCount: 5),
              ),
      child: Scaffold(
        backgroundColor: AppColors.gray90,
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                //  AppBar
                SliverAppBar(
                  backgroundColor: AppColors.gray90,
                  surfaceTintColor: AppColors.gray90,
                  floating: true,
                  snap: true,
                  pinned: true,
                  title: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Thêm vào tin',
                      style: AppStyles.title1Regular.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: Transform.flip(
                      flipX: true,
                      child: SvgPicture.asset(
                        AppImages.icClose,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        AppImages.icOption,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                //  Option header
                SliverToBoxAdapter(child: _buildOptionHeader()),
                //  Header dính khi cuộn
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate1(
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _buildOptionHeadeMediaV2(),
                    ),
                  ),
                ),
              ],
          body: Stack(
            children: [
              _buildListImage(context),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildListAssetSelected(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.gray60,
              ),
              alignment: Alignment.center,
              child: Text(
                'Mẫu',
                style: AppStyles.bodyRegular.copyWith(color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.gray60,
              ),
              alignment: Alignment.center,
              child: Text(
                'Nhạc',
                style: AppStyles.bodyRegular.copyWith(color: AppColors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.gray60,
              ),
              alignment: Alignment.center,
              child: Text(
                'Nhóm ảnh',
                style: AppStyles.bodyRegular.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionHeadeMediaV2() {
    return BlocBuilder<MediaPickedBloc, MediaPickedState>(
      builder: (context, state) {
        if (state is MediaPickedSuccess) {
          final isSelecting = (state.isSelecting) ?? false;

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
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        onTap: () {
                          context.read<MediaPickedBloc>().add(
                            LoadRequest(
                              requestType: RequestType.common,
                              maxCount: 5,

                              nameRequestType: 'Mới đây',
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppImages.icLogoAppV2,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Mới đây",
                              style: AppStyles.title2Regular.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          context.read<MediaPickedBloc>().add(
                            LoadRequest(
                              requestType: RequestType.image,
                              maxCount: 5,

                              nameRequestType: 'Ảnh',
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppImages.icPictureGallery,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Ảnh",
                              style: AppStyles.title2Regular.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          context.read<MediaPickedBloc>().add(
                            LoadRequest(
                              requestType: RequestType.video,
                              maxCount: 5,
                              nameRequestType: 'Video',
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppImages.icReelsActive,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Video",
                              style: AppStyles.title2Regular.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
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
                                child: _buildBottomSheetAllAlbum(
                                  context,
                                  state.album,
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
                        state.nameRequestType == null
                            ? state.selectedAlbum?.name ?? 'Mới đây'
                            : state.nameRequestType ?? 'Mới đây',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 8),
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
        }
        return Text('data');
      },
    );
  }

  Widget _buildListImage(BuildContext context) {
    return BlocListener<MediaPickedBloc, MediaPickedState>(
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
          Future.delayed(const Duration(seconds: 2), () {});
        }
      },
      child: BlocBuilder<MediaPickedBloc, MediaPickedState>(
        builder: (context, state) {
          if (state is MediaPickedSuccess) {
            final assetList = state.asset;
            final mediaPickerList = state.selectedAsset;
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
                  return GestureDetector(
                    onTap: () {
                      // chuyển qua CreateReelsPage, truyền danh sách asset đã chọn
                      if (selectedAssets.isEmpty) {
                        context
                            .pushNamed(
                              PathName.createReelsPage,
                              extra: mediaPickerList ?? [],
                            )
                            .then((_) {
                              state.selectedAsset?.clear();
                              state.isSelecting = false;
                            });
                      }
                    },
                    child: Container(
                      color:
                          selectedAssets.isEmpty
                              ? AppColors.gray60
                              : AppColors.gray80,
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
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
                  onTap: () {
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

  Widget _buildBottomSheetAllAlbum(
    BuildContext context,
    List<AssetPathEntity> album,
  ) {
    return SizedBox(
      height: double.infinity,
      child: WillPopScope(
        onWillPop: () async {
          if (_pageController.page?.round() == 1) {
            _pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
            );
            return false;
          }
          return true;
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 7),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.gray30,
                    ),
                    height: 4,
                    width: 32,
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildAllAlbumInit(context, album),
                    _buildSeeAllAlbum(context, album),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllAlbumInit(BuildContext context, List<AssetPathEntity> album) {
    return Container(
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Text('Hủy', style: AppStyles.title3Regular),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Center(
                      child: Text('Chọn album', style: AppStyles.title3Regular),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<MediaPickedBloc>().add(
                      LoadRequest(requestType: RequestType.common, maxCount: 5),
                    );
                    context.pop();
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.gray20,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          color: AppColors.white,
                          onPressed: () {
                            context.read<MediaPickedBloc>().add(
                              LoadRequest(
                                requestType: RequestType.common,
                                maxCount: 5,
                              ),
                            );
                            context.pop();
                          },
                          icon: SvgPicture.asset(AppImages.icLogoAppV2),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Mới đây', style: AppStyles.title3Regular),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    context.read<MediaPickedBloc>().add(
                      LoadRequest(requestType: RequestType.image, maxCount: 5),
                    );
                    context.pop();
                    print('object');
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.gray20,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          color: AppColors.white,
                          onPressed: () {
                            context.read<MediaPickedBloc>().add(
                              LoadRequest(
                                requestType: RequestType.image,
                                maxCount: 5,
                              ),
                            );
                            context.pop();
                          },
                          icon: SvgPicture.asset(AppImages.icPictureGallery),
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text('Ảnh', style: AppStyles.title3Regular),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    context.read<MediaPickedBloc>().add(
                      LoadRequest(requestType: RequestType.video, maxCount: 5),
                    );
                    context.pop();
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.gray20,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          color: AppColors.white,
                          onPressed: () {
                            context.read<MediaPickedBloc>().add(
                              LoadRequest(
                                requestType: RequestType.video,
                                maxCount: 5,
                              ),
                            );
                            context.pop();
                          },
                          icon: SvgPicture.asset(AppImages.icReels),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('Video', style: AppStyles.title3Regular),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Album', style: AppStyles.title3Regular),
                GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text('Xem tất cả', style: AppStyles.title3Regular),
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 👉 2 album 1 hàng
                crossAxisSpacing: 24,
                mainAxisSpacing: 8,
                childAspectRatio: 1.4, // vuông
              ),
              itemCount: album.length,
              itemBuilder: (context, index) {
                final e = album[index];
                return FutureBuilder<List<AssetEntity>>(
                  future: e.getAssetListRange(start: 0, end: 1),
                  builder: (context, snapshot) {
                    final asset =
                        snapshot.data?.isNotEmpty == true
                            ? snapshot.data!.first
                            : null;
                    return GestureDetector(
                      onTap: () {
                        context.read<MediaPickedBloc>().add(
                          LoadRequest(
                            requestType: e.type,
                            maxCount: 5,
                            selectedAlbum: e,
                          ),
                        );
                        context.pop();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                      0.1,
                                    ), // màu bóng
                                    blurRadius: 6, // độ tán
                                    offset: const Offset(0, 3), // vị trí bóng
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  6,
                                ), // 👉 bo góc 12
                                child:
                                    asset != null
                                        ? AssetEntityImage(
                                          asset,
                                          isOriginal: false,
                                          thumbnailSize:
                                              const ThumbnailSize.square(250),
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Center(
                                              child: Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                            );
                                          },
                                        )
                                        : Container(
                                          color: Colors.white,
                                          child: const Icon(
                                            Icons.photo,
                                            color: Colors.black,
                                          ),
                                        ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: FutureBuilder<int>(
                              future: e.assetCountAsync,
                              builder: (context, snap) {
                                final count = snap.data ?? 0;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.name,
                                      style: AppStyles.title3Regular,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$count",
                                      style: AppStyles.title3Regular,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  Widget _buildSeeAllAlbum(BuildContext context, List<AssetPathEntity> album) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 56),
              child: Text('Album', style: AppStyles.title3Regular),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              _pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              );
            },
            icon: SvgPicture.asset(AppImages.icChevronLeft),
          ),
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 👉 2 album 1 hàng
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8, // vuông
          ),
          itemCount: album.length,
          itemBuilder: (context, index) {
            final e = album[index];
            return FutureBuilder<List<AssetEntity>>(
              future: e.getAssetListRange(start: 0, end: 1),
              builder: (context, snapshot) {
                final asset =
                    snapshot.data?.isNotEmpty == true
                        ? snapshot.data!.first
                        : null;
                return GestureDetector(
                  onTap: () {
                    context.read<MediaPickedBloc>().add(
                      LoadRequest(
                        requestType: e.type,
                        maxCount: 5,
                        selectedAlbum: e,
                      ),
                    );
                    context.pop();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                  0.1,
                                ), // màu bóng
                                blurRadius: 6, // độ tán
                                offset: const Offset(0, 3), // vị trí bóng
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              6,
                            ), // 👉 bo góc 12
                            child:
                                asset != null
                                    ? AssetEntityImage(
                                      asset,
                                      isOriginal: false,
                                      thumbnailSize: const ThumbnailSize.square(
                                        250,
                                      ),
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Center(
                                          child: Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          ),
                                        );
                                      },
                                    )
                                    : Container(
                                      color: Colors.white,
                                      child: const Icon(
                                        Icons.photo,
                                        color: Colors.black,
                                      ),
                                    ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: FutureBuilder<int>(
                          future: e.assetCountAsync,
                          builder: (context, snap) {
                            final count = snap.data ?? 0;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.name,
                                  style: AppStyles.title3Regular,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text("$count", style: AppStyles.title3Regular),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class SliverAppBarDelegate1 extends SliverPersistentHeaderDelegate {
  final Widget child;
  SliverAppBarDelegate1(this.child);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(height: 60, color: AppColors.gray90, child: child);
  }

  @override
  double get maxExtent => 60.0;
  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant SliverAppBarDelegate1 oldDelegate) {
    return oldDelegate.child != child;
  }
}
