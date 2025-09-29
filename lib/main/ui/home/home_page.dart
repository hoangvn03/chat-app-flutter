import 'package:chat_app/main/features/post/post_widget.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/home/bloc/home_bloc.dart';
import 'package:chat_app/main/ui/home/bloc/home_event.dart';
import 'package:chat_app/main/ui/home/bloc/home_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadRequest()),
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
                        onPressed: () {},
                        icon: iconLikeNotification(isHasNotification: true),
                      ),
                      IconButton(
                        onPressed: () {
                          context.pushNamed(PathName.chatPage);
                        },
                        icon: iconShareNotification(
                          num: 5,
                          isHasNotification: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),

                  // List reels
                  SliverToBoxAdapter(child: _buildListReels(state.reels ?? [])),

                  // List posts
                  SliverToBoxAdapter(child: _buildListPost(state.posts ?? [])),
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

  Widget _buildUserList(List<UserModel> users, BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: Text(user.id.toString()),
          title: Text(user.email ?? 'No username provided'),
          subtitle: Text(user.name ?? 'No email provided'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return buildEditDialog(
                        context: context,
                        onSave: () {
                          final updatedUser = UserModel(
                            id: user.id!,
                            email: usernameController.text,
                          );
                          context.read<HomeBloc>().add(UpdateUser(updatedUser));
                        },
                      );
                      ;
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  context.read<HomeBloc>().add(DeletetUser(user.id ?? 0));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Deleted user: ${user.email}')),
                  );
                },
              ),
            ],
          ),
        );
      },
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
    return Container(
      height: 120,
      // color: AppColors.gray30,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Center(
                      child: ClipOval(
                        child: Image.asset(
                          AppImages.imgAvatarDefault, // ảnh PNG/JPG
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
              const Text("Your Story"),
            ],
          ),
          const SizedBox(width: 12), // khoảng cách với ListView
          // ListView scroll ngang
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: reels.length,
              itemBuilder: (context, index) {
                return _buildItemReel(reels[index]);
              },
            ),
          ),
        ],
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

  Widget _buildListPost(List<PostModel> post) {
    return ListView.builder(
      shrinkWrap: true, // 👈 Bắt buộc khi dùng trong SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(),
      itemCount: post.length,
      itemBuilder: (context, index) {
        return PostWidget(post: post[index]);
      },
    );
  }
}
