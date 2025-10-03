import 'package:chat_app/main/ui/reels/create_reel/bloc/create_reel_bloc.dart';
import 'package:chat_app/main/ui/reels/create_reel/bloc/create_reel_event.dart';
import 'package:chat_app/main/ui/reels/create_reel/bloc/create_reel_state.dart';
import 'package:chat_app/main/ui/reels/create_reel/media_picked.dart';
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

class CreateReelsPage extends StatefulWidget {
  const CreateReelsPage({super.key});

  @override
  State<CreateReelsPage> createState() => _CreateReelPageState();
}

class _CreateReelPageState extends State<CreateReelsPage> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateReelsBloc()..add(LoadRequest(RequestType.common, 5)),
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
          body: BlocBuilder<CreateReelsBloc, CreateReelsState>(
            builder: (context, state) {
              if (state is CreateReelsSuccess) {
                return _buildListImage(state.asset);
              }
              if (state is CreateReelsFailure) {
                return Center(
                  child: Text(
                    state.errorMessage,
                    style: AppStyles.title1Bold.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOptionHeadeMediaV2() {
    return BlocBuilder<CreateReelsBloc, CreateReelsState>(
      builder: (context, state) {
        if (state is CreateReelsSuccess) {
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
                          final recentAlbum = state.album.firstWhere(
                            (a) => a.type == RequestType.common,
                            orElse: () => state.album.first,
                          );
                          context.read<CreateReelsBloc>().add(
                            LoadRequest(
                              RequestType.common,
                              5,
                              selectedAlbum: recentAlbum,
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
                          final imageAlbum = state.album.firstWhere(
                            (a) => a.type == RequestType.image,
                            orElse: () => state.album.first,
                          );
                          context.read<CreateReelsBloc>().add(
                            LoadRequest(
                              RequestType.image,
                              5,
                              selectedAlbum: imageAlbum,
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
                          context.read<CreateReelsBloc>().add(
                            LoadRequest(RequestType.video, 5),
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
                                value: context.read<CreateReelsBloc>(),
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
                        state.selectedAlbum.name,
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
              GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.gray80,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    color: AppColors.white,
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      AppImages.icGallery,
                      color: AppColors.white,
                    ),
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

  Widget _buildListImage(List<AssetEntity> assetList) {
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
              print("Chọn ảnh mới");
            },
            child: Container(
              color: AppColors.gray60,
              child: const Center(
                child: Icon(Icons.camera_alt, size: 32, color: Colors.white),
              ),
            ),
          );
        }
        final asset = assetList[index - 1];
        return _assetWidget(asset);
      },
    );
  }

  Widget _assetWidget(AssetEntity asset) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: AssetEntityImage(
              asset,
              isOriginal: false, // dùng thumbnail cho nhanh
              thumbnailSize: const ThumbnailSize.square(
                250,
              ), // kích thước thumbnail
              fit: BoxFit.cover, // cách hiển thị
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          ),
        ),
        if (asset.type == AssetType.video)
          Positioned(
            right: 5,
            bottom: 5,
            child: SvgPicture.asset(
              AppImages.icReelsActive,
              width: 24,
              height: 24,
              color: AppColors.red100,
            ),
          ),
      ],
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
                    context.read<CreateReelsBloc>().add(
                      LoadRequest(RequestType.common, 5),
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
                            context.read<CreateReelsBloc>().add(
                              LoadRequest(RequestType.common, 5),
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
                    context.read<CreateReelsBloc>().add(
                      LoadRequest(RequestType.image, 5),
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
                            context.read<CreateReelsBloc>().add(
                              LoadRequest(RequestType.image, 5),
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
                    context.read<CreateReelsBloc>().add(
                      LoadRequest(RequestType.video, 5),
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
                            context.read<CreateReelsBloc>().add(
                              LoadRequest(RequestType.video, 5),
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
                        context.read<CreateReelsBloc>().add(
                          LoadRequest(e.type, 5, selectedAlbum: e),
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
                    context.read<CreateReelsBloc>().add(
                      LoadRequest(e.type, 5, selectedAlbum: e),
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
