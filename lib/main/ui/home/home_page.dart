import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/home/bloc/home_bloc.dart';
import 'package:chat_app/main/ui/home/bloc/home_event.dart';
import 'package:chat_app/main/ui/home/bloc/home_state.dart';
import 'package:chat_app/main/utils/common_widdget.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadListReel()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Instagram'),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: xử lý khi bấm nút
              },
              icon: iconLikeNotification(isHasNotification: true),
            ),
            IconButton(
              onPressed: () {
                // TODO: xử lý khi bấm nút
              },
              icon: iconShareNotification(num: 5,isHasNotification: true),
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const CircularProgressIndicator();
            } else if (state is HomeSuccess) {
              return SingleChildScrollView(
                child: Column(children: [_buildListReels(state.reels ?? [])]),
              );
            } else if (state is HomeFailure) {
              return const Text('Failed to load users');
            }
            return Text('Welcome to the Home Page!');
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
    return SizedBox(
      height: 200,
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
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SvgPicture.asset(AppImages.icCreate),
        ),
        const SizedBox(height: 12),
        Text(reel.user!.name ?? "Unknown"),
      ],
    );
  }
}
