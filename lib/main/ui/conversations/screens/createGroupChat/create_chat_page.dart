import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/conversations/screens/createGroupChat/bloc/create_chat_bloc.dart';
import 'package:chat_app/main/ui/conversations/screens/createGroupChat/bloc/create_chat_event.dart';
import 'package:chat_app/main/ui/conversations/screens/createGroupChat/bloc/create_chat_state.dart';
import 'package:chat_app/main/ui/widget/account_suggest/account_suggest_widget.dart';
import 'package:chat_app/main/ui/widget/account_suggest/cubit/account_suggest_cubit.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CreateChatPage extends StatefulWidget {
  const CreateChatPage({Key? key}) : super(key: key);

  @override
  State<CreateChatPage> createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  // Danh sách gợi ý (fake data)
  final List<Map<String, dynamic>> suggestions = [
    {"name": "benice_menswear", "avatar": "https://via.placeholder.com/150"},
    {"name": "Nguyễn Minh Tân", "avatar": "https://via.placeholder.com/150"},
    {"name": "Độ Phùng", "avatar": "https://via.placeholder.com/150"},
    {"name": "scott_sor", "avatar": "https://via.placeholder.com/150"},
    {"name": "Ngô Kiến Huy", "avatar": "https://via.placeholder.com/150"},
    {"name": "ROSÉ", "avatar": "https://via.placeholder.com/150"},
    {"name": "Justin Bieber", "avatar": "https://via.placeholder.com/150"},
  ];

  final Set<String> selectedUsers = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => CreateChatBloc()..add(LoadListUser(_searchController.text)),

      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text(
            "Nhóm chat mới",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ô nhập tên nhóm
                  commonTextFieldV2(
                    hintText: 'Tên nhóm (không bắt buộc)',
                    controller: _groupNameController,
                    color: AppColors.white,
                    border: Border.all(width: 1, color: AppColors.gray30),
                    hasHeight: false,
                    padding: EdgeInsets.only(top: 16, bottom: 16, right: 16),
                    hasLeading: false,
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<CreateChatBloc, CreateChatState>(
                    builder: (context, state) {
                      return commonTextFieldV2(
                        hintText: 'Tìm kiếm',
                        hintStyle: AppStyles.title2Regular.copyWith(
                          color: AppColors.gray60,
                        ),
                        controller: _searchController,
                        onChanged: (value) {
                          context.read<CreateChatBloc>().add(
                            LoadListUser(_searchController.text),
                          );
                        },
                      );
                    },
                  ),
                  BlocBuilder<CreateChatBloc, CreateChatState>(
                    builder: (context, state) {
                      if (state is CreateChatSuccess) {
                        return SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.members!.length,
                            itemBuilder: (context, index) {
                              return _itemUserAdd(
                                state.members![index],
                                context,
                              );
                            },
                          ),
                        );
                      } else if (state is CreateChatFailure) {
                        return Center(child: Text(state.errorMessage));
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<CreateChatBloc, CreateChatState>(
                    builder: (context, state) {
                      if (state is CreateChatLoading) {
                        return Center(child: const CircularProgressIndicator());
                      } else if (state is CreateChatSuccess) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.users!.length,
                          itemBuilder:
                              (context, index) => _itemUserSuggestV1(
                                state.users![index],
                                context,
                              ),
                        );
                      } else if (state is CreateChatFailure) {
                        return Center(child: Text(state.errorMessage));
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            BlocBuilder<CreateChatBloc, CreateChatState>(
              builder: (context, state) {
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: commonButton(
                    text: 'Tạo nhóm',
                    onTap: () {
                      context.read<CreateChatBloc>().add(
                        CreateNewChat(
                          participantIds: [],
                          converationName: _groupNameController.text,
                          isGroup: true,
                        ),
                      );
                    },
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemUserAdd(UserModel user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Center(
                  child: cricleColorImage(
                    childWidget: SvgPicture.network(
                      user.avatar ??
                          'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<CreateChatBloc>().add(RemoveUserToGroup(user));
                },
                child: Positioned(
                  right: 55,
                  bottom: 55,
                  child: SvgPicture.asset(AppImages.icClose),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Text(user.username ?? "Unknown", style: AppStyles.footnoteRegular),
        ],
      ),
    );
  }

  Widget _itemUserSuggestV1(UserModel user, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: SvgPicture.network(
        user.avatar ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob',
        width: 68,
        height: 68,
      ),
      title: Text(user.username ?? 'Unknown', style: AppStyles.title2Bold),
      subtitle: Text('Gợi ý cho bạn', style: AppStyles.bodyRegular),
      onTap: () {
        context.pushNamed(PathName.profilePage, extra: user);
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              context.read<CreateChatBloc>().add(AddUserToGroup(user));
            },
            child: SvgPicture.asset(AppImages.icClose, width: 16, height: 16),
          ),
        ],
      ),
    );
  }
}
