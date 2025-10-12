import 'package:chat_app/main/features/account_suggest/account_suggest_widget.dart';
import 'package:chat_app/main/features/interaction_button/bloc/interaction_bloc.dart';
import 'package:chat_app/main/features/interaction_button/interaction_button.dart';
import 'package:chat_app/main/networks/model/common_item.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/profile/bloc/profile_bloc.dart';
import 'package:chat_app/main/ui/profile/bloc/profile_event.dart';
import 'package:chat_app/main/ui/profile/bloc/profile_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, this.user});
  UserModel? user;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc()..add(LoadRequest()),
        ),
        BlocProvider<InteractionBloc>(create: (_) => InteractionBloc()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileSuccess) {
              return NestedScrollView(
                headerSliverBuilder:
                    (context, innerBoxIsScrolled) => [
                      // AppBar phía trên
                      SliverAppBar(
                        backgroundColor: AppColors.white,
                        surfaceTintColor: AppColors.white,
                        floating: true,
                        snap: true,
                        pinned: true,
                        title: Text(
                          (widget.user != null)
                              ? widget.user!.name ?? 'Unkonwn'
                              : state.user!.name ?? 'Unkonwn',
                          style: AppStyles.title1Bold,
                        ),
                        leading: IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: Transform.flip(
                            flipX: true,
                            child: SvgPicture.asset(AppImages.icNextRight),
                          ),
                        ),
                        actions: [
                          PopupMenuButton(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            constraints: const BoxConstraints(),
                            color: Colors.white.withOpacity(0.95),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            offset: const Offset(40, 40),
                            itemBuilder:
                                (context) => [
                                  PopupMenuItem(
                                    padding: EdgeInsets.only(left: 24),
                                    enabled: false, // tắt click
                                    child: Text(
                                      "Thông báo từ ${(widget.user != null) ? widget.user!.name ?? 'Unkonwn' : state.user!.name ?? 'Unkonwn'}",
                                      style: AppStyles.bodyRegular,
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {},
                                    child: ListTile(
                                      dense: true,
                                      leading: SvgPicture.asset(
                                        AppImages.icPictureGallery,
                                      ),
                                      title: Text(
                                        "Bài biết",
                                        style: AppStyles.title2Regular,
                                      ),
                                      subtitle: Text(
                                        "Phù hợp nhất",
                                        style: AppStyles.bodyRegular,
                                      ),
                                      trailing: SvgPicture.asset(
                                        AppImages.icChevronRight,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {},
                                    child: ListTile(
                                      dense: true,
                                      leading: SvgPicture.asset(
                                        AppImages.icAddHighlight,
                                      ),
                                      title: Text(
                                        "Tin",
                                        style: AppStyles.title2Regular,
                                      ),
                                      subtitle: Text(
                                        "Phù hợp nhất",
                                        style: AppStyles.bodyRegular,
                                      ),
                                      trailing: SvgPicture.asset(
                                        AppImages.icChevronRight,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {},
                                    child: ListTile(
                                      dense: true,

                                      leading: SvgPicture.asset(
                                        AppImages.icReels,
                                      ),
                                      title: Text(
                                        "Reels",
                                        style: AppStyles.title2Regular,
                                      ),
                                      subtitle: Text(
                                        "Phù hợp nhất",
                                        style: AppStyles.bodyRegular,
                                      ),
                                      trailing: SvgPicture.asset(
                                        AppImages.icChevronRight,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: () {},
                                    child: ListTile(
                                      dense: true,

                                      leading: SvgPicture.asset(
                                        AppImages.icLive,
                                      ),
                                      title: Text(
                                        "Video trực tiếp",
                                        style: AppStyles.title2Regular,
                                      ),
                                      subtitle: Text(
                                        "Phù hợp nhất",
                                        style: AppStyles.bodyRegular,
                                      ),
                                      trailing: SvgPicture.asset(
                                        AppImages.icChevronRight,
                                      ),
                                    ),
                                  ),
                                ],
                            child: Transform.flip(
                              flipX: true,
                              child: SvgPicture.asset(
                                AppImages.icNotificationsOff,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                useSafeArea: true,
                                backgroundColor: AppColors.white,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                ),
                                builder:
                                    (context) =>
                                        _buildBottomSheetProfileOption(context),
                              );
                            },
                            icon: Transform.rotate(
                              angle:
                                  90 *
                                  3.1415926535 /
                                  180, // xoay 90 độ (radian)
                              child: SvgPicture.asset(AppImages.icOption),
                            ),
                          ),
                        ],
                      ),

                      // Profile info nằm giữa
                      SliverToBoxAdapter(child: _buildProfileInfo(state.user)),

                      // TabBar dính ngay dưới info
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          TabBar(
                            controller: _tabController,
                            labelColor: Colors.black,
                            indicatorColor: Colors.black,
                            dividerColor: AppColors.white,
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.black,
                              ),
                              insets: EdgeInsets.symmetric(
                                horizontal: 48,
                              ), // chỉnh để dài hơn/ngắn lại
                            ),
                            indicatorWeight: 1,
                            tabs: [
                              Tab(
                                icon: SvgPicture.asset(
                                  AppImages.icGridDark,
                                  // color: AppColors.gray60,
                                ),
                              ),
                              Tab(
                                icon: SvgPicture.asset(
                                  AppImages.icReels,
                                  color: AppColors.gray60,
                                ),
                              ),
                              Tab(
                                icon: SvgPicture.asset(
                                  AppImages.icTag,
                                  color: AppColors.gray60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildListPost(state.posts ?? [], 0),
                    _buildListPost(state.posts ?? [], 1),
                    _buildListPost(state.posts ?? [], 2),
                  ],
                ),
              );
            } else if (state is ProfileFailure) {
              return const Center(child: Text('Failed to load users'));
            }
            return const Center(child: Text('Welcome to the Profile Page!'));
          },
        ),
      ),
    );
  }

  Widget _buildProfileInfo(UserModel? user) {
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
                  (widget.user != null)
                      ? widget.user!.avatar ?? AppImages.imgAvatarDefault
                      : user!.avatar ?? AppImages.imgAvatarDefault,

                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (widget.user != null)
                          ? widget.user!.name ?? 'Unkonwn'
                          : user!.name ?? 'Unkonwn',
                      style: AppStyles.headlineBold,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('151', style: AppStyles.title3Bold),
                            Text('bài viết', style: AppStyles.calloutRegular),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('122K', style: AppStyles.title3Bold),
                            Text(
                              'người theo dõi',
                              style: AppStyles.calloutRegular,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('162', style: AppStyles.title3Bold),
                            Text(
                              'đang theo dõi',
                              style: AppStyles.calloutRegular,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
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
              readMoreDescription('''Everynight Alone
Đừng để giọt nước mắt vẫn rơi tàn hoa khắp nơi thiếu em babe
Everynight Alone
Lại gọi tên những nổi nhớ đong đầyBao đam mê cũng đã chóng phai
Yêu em ko biết đúng sai
Chỉ bằng cảm xúc bằng lý trí bằng tất cả những gì anh có
Hay em cho
Khi hai con tim lệch nhịp
Anh có cố gắng thế nào, em cũng không hiểu được em
Như là bản thân chính em.'''),
              const SizedBox(height: 12),
              _bioLink([
                "https://shop.me/hoang",
                "https://instagram.com/hoang",
                "https://tiktok.com/@hoang",
                "https://facebook.com/hoang",
                "https://youtube.com/@hoang",
              ]),
              const SizedBox(height: 8),

              _bannerProfile(context, [
                CommonItem(title: 'yunbray110', iconUrl: AppImages.icThreads),
                CommonItem(title: 'yunbray110', iconUrl: AppImages.icThreads),
                CommonItem(title: 'yunbray110', iconUrl: AppImages.icThreads),
                CommonItem(
                  title: 'Bố đi mua heo sữa',
                  iconUrl: AppImages.icThreads,
                ),
              ]),
              const SizedBox(height: 8),
              _totalUserFollow(),
              const SizedBox(height: 8),
              _buttonActionProfile(),
              _buildGalleryProfile([
                ReelModel(user: UserModel(name: "Hoang")),
                ReelModel(user: UserModel(name: "Hoang")),
                ReelModel(user: UserModel(name: "Hoang")),
              ]),
              const SizedBox(height: 8),
              AccountSuggestWidget(
                isHorirontal: true,
                title: 'Khám phá mọi người',
                users: [
                  UserModel(
                    name: 'hieu_pham',
                    avatar: AppImages.imgAvatarDefault,
                  ),
                  UserModel(
                    name: 'tuan_anh',
                    avatar: AppImages.imgAvatarDefault,
                  ),
                  UserModel(
                    name: 'nguyen_nguyen',
                    avatar: AppImages.imgAvatarDefault,
                  ),
                  UserModel(
                    name: 'ngoc_hoang',
                    avatar: AppImages.imgAvatarDefault,
                  ),
                  UserModel(
                    name: 'minh_hieu',
                    avatar: AppImages.imgAvatarDefault,
                  ),
                ],
              ),
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
        SvgPicture.asset(AppImages.icLink, width: 16, height: 16),
        const SizedBox(width: 4),
        Text(
          firstLink,
          style: AppStyles.headlineBold,
          overflow: TextOverflow.ellipsis, // nếu link quá dài thì cắt
        ),
        if (remaining > 0)
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
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
              style: AppStyles.headlineBold,
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
          20 + 4 + textWidth + 4 + 12 + 40; // icon + spacing + text + padding

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
              SvgPicture.asset(
                item.iconUrl ?? AppImages.icLink,
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 4),
              Text(
                item.title ?? 'Unknown',
                style: AppStyles.headlineBold,
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
                useSafeArea: true,
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

  Widget _totalUserFollow() {
    final avatars = [
      AppImages.imgAvatarDefault,
      AppImages.imgAvatarDefault,
      AppImages.imgAvatarDefault,
    ];
    final fistUser = ['chaubui_'];

    return totalUserFollow(
      ontap: () {
        context.pushNamed(PathName.profileListFollowerPage);
      },
      images: avatars,
      fistUser: fistUser,
    );

    // GestureDetector(
    //   onTap: () {
    //     context.pushNamed(PathName.profileListFollowerPage);
    //   },
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       SizedBox(
    //         height: 28,
    //         width: avatars.length * 20,
    //         child: Stack(
    //           clipBehavior: Clip.none,
    //           children:
    //               List.generate(avatars.length, (index) {
    //                 return Positioned(
    //                   left: index * 20, // 👈 khoảng cách chồng nhau
    //                   child: Container(
    //                     width: 28,
    //                     height: 28,
    //                     decoration: BoxDecoration(
    //                       shape: BoxShape.circle,
    //                       border: Border.all(color: Colors.white, width: 1),
    //                     ),
    //                     child: ClipOval(
    //                       child: Image.asset(avatars[index], fit: BoxFit.cover),
    //                     ),
    //                   ),
    //                 );
    //               }).reversed.toList(),
    //         ),
    //       ),
    //       const SizedBox(width: 12),
    //       GestureDetector(
    //         onTap: () {
    //           //Todo
    //         },
    //         child: RichText(
    //           text: TextSpan(
    //             text: 'Có',
    //             style: AppStyles.bodyRegular,
    //             children: [
    //               TextSpan(
    //                 text: " ${fistUser[0]}", // 👈 text giống Insta
    //                 style: AppStyles.bodyBold,
    //               ),
    //               TextSpan(
    //                 text: " và", // 👈 text giống Insta
    //                 style: AppStyles.bodyRegular,
    //               ),
    //               TextSpan(
    //                 text:
    //                     " ${fistUser.length} người khác", // 👈 text giống Insta
    //                 style: AppStyles.bodyBold,
    //               ),
    //               TextSpan(
    //                 text: " theo dõi", // 👈 text giống Insta
    //                 style: AppStyles.bodyRegular,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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
              text: 'Theo dõi',
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
              text: 'Nhắn tin',
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
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 100),
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

  Widget _buildListPost(List<PostModel> posts, int tabIndex) {
    print('$tabIndex');
    return GridView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // để không cuộn nếu bọc trong scroll cha
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 ô một hàng
        crossAxisSpacing: 2, // khoảng cách ngang = viền trắng
        mainAxisSpacing: 2, // khoảng cách dọc = viền trắng
        childAspectRatio: (tabIndex == 1) ? 0.6 : 0.8, // tỉ lệ vuông 1:1
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return _itemPost(posts[index]);
      },
    );
  }

  Widget _itemPost(PostModel post) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          post.postImage ?? '',
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        if (post.typePost != 'video')
          Positioned(
            right: 4,
            top: 4,
            child: SvgPicture.asset(
              width: 16,
              height: 16,
              post.typePost == 'reels'
                  ? AppImages.icReelsActive
                  : AppImages.icGallery,
              color: AppColors.white,
            ),
          ),
      ],
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

  Widget _buildBottomSheetProfileOption(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Hạn chế',
                style: AppStyles.title3Regular.copyWith(
                  color: AppColors.red100,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Chặn',
                style: AppStyles.title3Regular.copyWith(
                  color: AppColors.red100,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Báo cáo',
                style: AppStyles.title3Regular.copyWith(
                  color: AppColors.red100,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Giới thiệu về tài khoản này',
                style: AppStyles.title3Regular.copyWith(color: AppColors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Xem hoạt động chung',
                style: AppStyles.title3Regular.copyWith(color: AppColors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Ẩn tin của bạn',
                style: AppStyles.title3Regular.copyWith(color: AppColors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Sao chép URL trang cá nhân',
                style: AppStyles.title3Regular.copyWith(color: AppColors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Chia sẻ trang cá nhân này',
                style: AppStyles.title3Regular.copyWith(color: AppColors.black),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Mã URL',
                style: AppStyles.title3Regular.copyWith(color: AppColors.black),
              ),
            ),
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

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white, // nền của tabbar
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
