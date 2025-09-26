import 'package:chat_app/main/features/post/post_widget.dart';
import 'package:chat_app/main/features/read_more_text/read_more_cubit.dart';
import 'package:chat_app/main/features/read_more_text/read_more_text.dart';
import 'package:chat_app/main/networks/model/common_item.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/home/bloc/home_bloc.dart';
import 'package:chat_app/main/ui/home/bloc/home_event.dart';
import 'package:chat_app/main/ui/home/bloc/home_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _HomePageState();
}

class _HomePageState extends State<ProfilePage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (_) => HomeBloc()..add(LoadRequest())),
        BlocProvider<ReadMoreCubit>(create: (_) => ReadMoreCubit()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeSuccess) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.white,
                    floating: true, // ẩn khi vuốt lên
                    snap: true, // hiện lại khi vuốt xuống
                    pinned: false, // không cố định
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: SvgPicture.asset(AppImages.icChevronLeft),
                        ),
                      ],
                    ),
                    title: Text(
                      'hoangvn03',
                      style: AppStyles.title3Bold.copyWith(fontSize: 24),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {},
                        icon: Transform.rotate(
                          angle: 90 * 3.1415926535 / 180, // quay 90 độ
                          child: SvgPicture.asset(AppImages.icOption),
                        ),
                      ),
                    ],
                  ),

                  SliverToBoxAdapter(child: _buildProfileInfo()),
                ],
              );
            } else if (state is HomeFailure) {
              return const Center(child: Text('Failed to load users'));
            }
            return const Center(child: Text('Welcome to the Home Page!'));
          },
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              cricleColorImage(
                size: 86,
                childWidget: Image.asset(
                  AppImages.imgAvatarDefault, // ảnh PNG/JPG
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("hoangvn03", style: AppStyles.headlineBold),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Column(
                        children: [
                          Text('151', style: AppStyles.title3Bold),
                          Text('post', style: AppStyles.bodyRegular),
                        ],
                      ),
                      const SizedBox(width: 50),
                      Column(
                        children: [
                          Text('122K', style: AppStyles.title3Bold),
                          Text('followers', style: AppStyles.bodyRegular),
                        ],
                      ),
                      const SizedBox(width: 50),

                      Column(
                        children: [
                          Text('162', style: AppStyles.title3Bold),
                          Text('following', style: AppStyles.bodyRegular),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Blogger",
                style: AppStyles.bodyRegular.copyWith(color: AppColors.gray40),
              ),
              readMoreDescription(context, '''TRỞ NÊN TỐT - ĐẸP HƠN MỖI NGÀY
            🏷 Hàng Order Nội Địa Trung Cao Cấp
            🏷 Nhận Ship Quốc Tế Hàn - Nhật - Đài
            🏷 Order Từ 1-2 Tuần & Có Cọc
            🏷 Freeship Từ 2sp'''),
              _bioLink([
                "https://shop.me/hoang",
                "https://instagram.com/hoang",
                "https://tiktok.com/@hoang",
                "https://facebook.com/hoang",
                "https://youtube.com/@hoang",
              ]),
              _bannerProfile(context, [
                CommonItem(title: 'yunbray110', iconUrl: AppImages.icThreads),
                CommonItem(title: 'yunbray110', iconUrl: AppImages.icThreads),
                CommonItem(title: 'yunbray110', iconUrl: AppImages.icThreads),
                CommonItem(
                  title: 'Bố đi mua heo sữa',
                  iconUrl: AppImages.icThreads,
                ),
              ]),
              _buttonActionProfile(),
              _buildGalleryProfile([
                ReelModel(user: UserModel(name: "Hoang")),
                ReelModel(user: UserModel(name: "Hoang")),
                ReelModel(user: UserModel(name: "Hoang")),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bioLink(List<String> links) {
    if (links.isEmpty) return const SizedBox();
    final firstLink = links.first;
    final remaining = links.length - 1;
    return Row(
      children: [
        SvgPicture.asset(AppImages.icLink),
        const SizedBox(width: 4),
        Text(
          firstLink,
          style: AppStyles.bodyBold,
          overflow: TextOverflow.ellipsis, // nếu link quá dài thì cắt
        ),
        if (remaining > 0)
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder:
                    (context) =>
                        _buildBottomSheetShowFullBioLinks(context, links),
              );
            },
            child: Text(
              " và $remaining liên kết khác.",
              style: AppStyles.bodyBold,
            ),
          ),
      ],
    );
  }

  Widget _bannerProfile(BuildContext context, List<CommonItem> banners) {
    if (banners.isEmpty) return const SizedBox();
    double maxWidth = MediaQuery.of(context).size.width;
    double usedWidth = 0;
    List<CommonItem> visibleItems = [];
    int remaining = 0;

    for (var item in banners) {
      final textWidth = measureTextWidth(
        item.title ?? 'Unknown',
        AppStyles.bodyBold,
      );
      final itemWidth =
          20 + 4 + textWidth + 4 + 12; // icon + spacing + text + padding

      if (usedWidth + itemWidth < maxWidth - 80) {
        visibleItems.add(item);
        usedWidth += itemWidth;
      } else {
        break;
      }
    }
    remaining = banners.length - visibleItems.length;
    return Row(
      children: [
        ...visibleItems.map(
          (item) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(item.iconUrl ?? AppImages.icLink, width: 20),
              const SizedBox(width: 4),
              Text(
                item.title ?? 'Unknown',
                style: AppStyles.bodyBold,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
        if (remaining > 0)
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder:
                    (context) =>
                        _buildBottomSheetShowFullBanner(context, banners),
              );
            },
            child: Text(
              "và $remaining liên kết khác",
              style: AppStyles.bodyBold,
            ),
          ),
      ],
    );
  }

  Widget _buttonActionProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: commonButton(
              margin: EdgeInsets.only(right: 6),
              hasHeight: true,
              padding: EdgeInsets.symmetric(vertical: 6),
              text: 'Follow',
              textStyle: AppStyles.bodyBold.copyWith(color: AppColors.white),
              onTap: () {},
              radius: 6,
            ),
          ),
          Expanded(
            child: commonButton(
              hasHeight: true,
              padding: EdgeInsets.symmetric(vertical: 6),
              margin: EdgeInsets.only(left: 6),
              isBoxBorder: Border.all(color: AppColors.gray20, width: 0),
              text: 'Message',
              textStyle: AppStyles.bodyBold,
              onTap: () {},
              radius: 6,
              color: AppColors.gray30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryProfile(List<ReelModel> reels) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: reels.length,
        itemBuilder: (context, index) {
          return _buildItemReel(reels[index]);
        },
      ),
    );
  }

  Widget _buildItemReel(ReelModel reel) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          cricleColorImage(
            childWidget: Image.asset(
              AppImages.imgAvatarDefault, // ảnh PNG/JPG
              fit: BoxFit.cover,
            ),
          ),
          Text(reel.user!.name ?? "Unknown"),
        ],
      ),
    );
  }

  Widget _buildBottomSheetShowFullBioLinks(
    BuildContext context,
    List<String> linkBios,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              context.pop();
            },
            child: Container(
              margin: EdgeInsets.only(top: 7),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.gray40,
              ),
              height: 4,
              width: 32,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Center(child: Text('Liên kết', style: AppStyles.title3Regular)),
              const SizedBox(height: 16),

              Container(height: 1, color: AppColors.gray30),
              const SizedBox(height: 16),

              ...linkBios.map((link) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                    left: 12,
                    right: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.gray30, // màu vòng
                            width: 1, // độ dày vòng
                          ),
                        ),
                        child: SvgPicture.asset(AppImages.icLink),
                      ),
                      Text(
                        ' $link',
                        style: AppStyles.bodyBold,
                        overflow:
                            TextOverflow.ellipsis, // nếu link quá dài thì cắt
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetShowFullBanner(
    BuildContext context,
    List<CommonItem> banners,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              context.pop();
            },
            child: Container(
              margin: EdgeInsets.only(top: 7),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.gray40,
              ),
              height: 4,
              width: 32,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Center(child: Text('Liên kết', style: AppStyles.title3Regular)),
              const SizedBox(height: 16),

              Container(height: 1, color: AppColors.gray30),
              const SizedBox(height: 16),

              ...banners.map((banner) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                    left: 12,
                    right: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.gray30, // màu vòng
                            width: 1, // độ dày vòng
                          ),
                        ),
                        child: SvgPicture.asset(
                          banner.iconUrl ?? AppImages.icLink,
                        ),
                      ),
                      Text(
                        ' ${banner.title}',
                        style: AppStyles.bodyBold,
                        overflow:
                            TextOverflow.ellipsis, // nếu link quá dài thì cắt
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  double measureTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }
}
