import 'package:chat_app/main/ui/reels/create_reel/gallery_screen.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CreateReelsPage extends StatefulWidget {
  const CreateReelsPage({super.key});

  @override
  State<CreateReelsPage> createState() => _CreateReelPageState();
}

class _CreateReelPageState extends State<CreateReelsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text("Gần đây", style: TextStyle(color: Colors.white)),
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
              ),
            ],
        body: GalleryScreen(),
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

  //   Widget _buildListImage() {
  //   return SliverGrid(
  //     gridDelegate: SliverQuiltedGridDelegate(
  //       crossAxisCount: 3,
  //       mainAxisSpacing: 2,
  //       crossAxisSpacing: 2,
  //       repeatPattern: QuiltedGridRepeatPattern.inverted,
  //       pattern: [
  //         QuiltedGridTile(2, 1), // Large square
  //         QuiltedGridTile(1, 1), // Small square
  //         QuiltedGridTile(1, 1), // Small square
  //         QuiltedGridTile(1, 1),
  //         QuiltedGridTile(1, 1), // Small square
  //       ],
  //     ),
  //     delegate: SliverChildBuilderDelegate(
  //       (context, index) => _itemSearchInit(posts[index]),
  //       childCount: posts.length, // Use actual post count
  //     ),
  //   );
  // }

  // Widget _itemImage() {
  //   return Stack(
  //     fit: StackFit.expand,
  //     children: [
  //       Image(
  //         '',
  //         fit: BoxFit.cover,
  //         width: double.infinity,
  //       ),

  //     ],
  //   );
  // }
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
    return Container(color: AppColors.gray20, child: child);
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
