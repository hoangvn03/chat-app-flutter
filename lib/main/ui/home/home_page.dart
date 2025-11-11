import 'package:chat_app/main/helper/socket/socket_service.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/ui/widget/post/bloc/interaction_cubit.dart';
import 'package:chat_app/main/ui/widget/post/post_item_widget.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/home/bloc/home_bloc.dart';
import 'package:chat_app/main/ui/home/bloc/home_event.dart';
import 'package:chat_app/main/ui/home/bloc/home_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.extras});
  List<dynamic>? extras;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final ipController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create:
              (_) =>
                  HomeBloc(context.read<SocketService>())..add(LoadRequest()),
        ),
      ],
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeSuccess &&
              widget.extras != null &&
              widget.extras!.isNotEmpty &&
              state.posts != null) {
            print('Uplaod post');
            context.read<HomeBloc>().add(
              CreatePost(
                caption: widget.extras![0],
                location: widget.extras![1],
                assetImage: widget.extras![2],
              ),
            );
            widget.extras?.clear();
          }
        },
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
                      surfaceTintColor: AppColors.white,
                      floating: true, // ẩn khi vuốt lên
                      snap: true, // hiện lại khi vuốt xuống
                      pinned: false, // không cố định
                      title: PopupMenuButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        color: Colors.white.withOpacity(0.95),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        offset: const Offset(0, 40),
                        itemBuilder:
                            (context) => [
                              PopupMenuItem(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppImages.icPeople),
                                    const SizedBox(width: 8),
                                    const Text("Đang theo dõi"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppImages.icLike),
                                    const SizedBox(width: 8),
                                    const Text("Yêu thích"),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: commonTextFieldV2(
                                        controller: ipController,
                                        hintText: 'Nhập ip',
                                      ),
                                    ),
                                    commonButton(
                                      text: 'Lưu',
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      onTap: () async {
                                        await ApiEndPoints.updateIp(
                                          ipController.text,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(AppImages.imgLogoText),
                            const SizedBox(width: 8),
                            Transform.flip(
                              flipY: true,
                              child: SvgPicture.asset(
                                AppImages.icChevronUp,
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            context.pushNamed(PathName.notificationPage);
                          },
                          icon: iconLikeNotification(
                            isHasNotification:
                                (state.numNoti != null && state.numNoti! > 0)
                                    ? true
                                    : false,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.pushNamed(
                              PathName.chatPage,
                              extra: state.user,
                            );
                          },
                          icon: iconShareNotification(
                            num: state.numNoti,
                            isHasNotification:
                                (state.numNoti != null && state.numNoti! > 0)
                                    ? true
                                    : false,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),

                    // List reels
                    SliverToBoxAdapter(
                      child: _buildListReels(state.reels ?? []),
                    ),

                    // List posts
                    SliverToBoxAdapter(child: _buildListPost(state)),
                  ],
                );
              } else if (state is HomeFailure) {
                return Center(child: Text(state.errorMessage ?? 'null error'));
              }
              return const Center(child: Text('Welcome to the Home Page!'));
            },
          ),
        ),
      ),
    );
  }

  Widget buildEditDialog({
    required BuildContext context,
    required VoidCallback onSave,
  }) {
    return AlertDialog(
      title: Text('Chỉnh sửa người dùng'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(labelText: 'Tên đăng nhập'),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Mật khẩu'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Đóng dialog
          },
          child: Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            onSave();
            Navigator.of(context).pop(); // Đóng dialog sau khi lưu
          },
          child: Text('Lưu'),
        ),
      ],
    );
  }

  Widget _buildListReels(List<ReelModel> reels) {
    // tạo 1 list mới, thêm Your Story vào đầu
    final allReels = [null, ...reels]; // null đại diện cho "Your Story"

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allReels.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            // item đầu tiên là "Your Story"
            return GestureDetector(
              onTap: () {
                context.pushNamed(PathName.mediaPickedPage);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: ClipOval(
                              child: Image.asset(
                                AppImages.imgAvatarDefault,
                                fit: BoxFit.cover,
                                width: 78,
                                height: 78,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 55,
                          top: 55,
                          child: SvgPicture.asset(AppImages.icRoundAdd),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Your Story",
                      style: AppStyles.footnoteRegular.copyWith(
                        color: AppColors.gray60,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // các item còn lại
            return _buildItemReel(allReels[index]!);
          }
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
          const SizedBox(height: 4),
          Text(
            reel.user!.username ?? "Unknown",
            style: AppStyles.footnoteRegular,
          ),
        ],
      ),
    );
  }

  Widget _buildListPost(HomeSuccess state) {
    final posts = state.posts ?? [];
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.isLoading ? posts.length + 1 : posts.length,
      itemBuilder: (context, index) {
        if (state.isLoading && index == 0) {
          // item loading ở đầu danh sách
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // Nếu đang loading, các index thực tế bắt đầu từ 1
        final postIndex = state.isLoading ? index - 1 : index;
        return PostWidget(post: posts[postIndex]);
      },
    );
  }
}
