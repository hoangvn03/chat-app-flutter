import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_bloc.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_event.dart';
import 'package:chat_app/main/ui/reels/widgets/media_picked/bloc/media_picked_state.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class AlbumBottomSheet extends StatelessWidget {
  final List<AssetPathEntity> album;
  final PageController pageController;

  const AlbumBottomSheet({
    super.key,
    required this.album,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaPickedBloc, MediaPickedState>(
      builder: (context, state) {
        if (state is MediaPickedSuccess) {
          return SizedBox(
            height: double.infinity,
            child: WillPopScope(
              onWillPop: () async {
                if (pageController.page?.round() == 1) {
                  pageController.animateToPage(
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
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          margin: const EdgeInsets.only(top: 7),
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
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildAllAlbumInit(context),
                          _buildSeeAllAlbum(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  /// Trang đầu: chọn nhanh album
  Widget _buildAllAlbumInit(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
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
          _buildQuickFilterRow(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Album', style: AppStyles.title3Regular),
                GestureDetector(
                  onTap: () {
                    pageController.animateToPage(
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
          Expanded(child: _buildAlbumGrid(context, isHorizontal: true)),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  /// Trang 2: xem tất cả album
  Widget _buildSeeAllAlbum(BuildContext context) {
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
              pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              );
            },
            icon: SvgPicture.asset(AppImages.icChevronLeft),
          ),
        ),
        body: _buildAlbumGrid(context),
      ),
    );
  }

  /// Hàng lọc nhanh: Mới đây / Ảnh / Video
  Widget _buildQuickFilterRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _quickFilterItem(
            context,
            title: 'Mới đây',
            icon: AppImages.icLogoAppV2,
            type: RequestType.common,
          ),
          const SizedBox(width: 12),
          _quickFilterItem(
            context,
            title: 'Ảnh',
            icon: AppImages.icPictureGallery,
            type: RequestType.image,
          ),
          const SizedBox(width: 12),
          _quickFilterItem(
            context,
            title: 'Video',
            icon: AppImages.icReels,
            type: RequestType.video,
          ),
        ],
      ),
    );
  }

  Widget _quickFilterItem(
    BuildContext context, {
    required String title,
    required String icon,
    required RequestType type,
  }) {
    return InkWell(
      onTap: () {
        context.read<MediaPickedBloc>().add(
          LoadRequest(requestType: type, maxCount: 5, nameRequestType: title),
        );
        Navigator.of(context).pop();
      },
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.gray20,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset(icon),
          ),
          const SizedBox(height: 4),
          Text(title, style: AppStyles.title3Regular),
        ],
      ),
    );
  }

  /// Lưới album (dùng chung)
  Widget _buildAlbumGrid(BuildContext context, {bool isHorizontal = false}) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isHorizontal ? 2 : 2,
        crossAxisSpacing: isHorizontal ? 24 : 8,
        mainAxisSpacing: 8,
        childAspectRatio: isHorizontal ? 1.4 : 0.8,
      ),
      itemCount: album.length,
      itemBuilder: (context, index) {
        final e = album[index];
        return FutureBuilder<List<AssetEntity>>(
          future: e.getAssetListRange(start: 0, end: 1),
          builder: (context, snapshot) {
            final asset =
                snapshot.data?.isNotEmpty == true ? snapshot.data!.first : null;

            return GestureDetector(
              onTap: () {
                context.read<MediaPickedBloc>().add(
                  LoadRequest(
                    requestType: e.type,
                    maxCount: 5,
                    selectedAlbum: e,
                  ),
                );
                Navigator.of(context).pop();
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
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child:
                            asset != null
                                ? AssetEntityImage(
                                  asset,
                                  isOriginal: false,
                                  thumbnailSize: const ThumbnailSize.square(
                                    250,
                                  ),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
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
                            Text('$count', style: AppStyles.title3Regular),
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
    );
  }
}
