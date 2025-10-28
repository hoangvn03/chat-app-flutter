import 'dart:async';

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
  final List<Map<String, dynamic>> suggestions = [
    {"name": "benice_menswear", "avatar": "https://via.placeholder.com/150"},
    {"name": "Nguyễn Minh Tân", "avatar": "https://via.placeholder.com/150"},
    {"name": "Độ Phùng", "avatar": "https://via.placeholder.com/150"},
    {"name": "scott_sor", "avatar": "https://via.placeholder.com/150"},
    {"name": "Ngô Kiến Huy", "avatar": "https://via.placeholder.com/150"},
    {"name": "ROSÉ", "avatar": "https://via.placeholder.com/150"},
    {"name": "Justin Bieber", "avatar": "https://via.placeholder.com/150"},
  ];
  Timer? _debounce;
  late CreateChatBloc _createChatBloc;

  @override
  void initState() {
    super.initState();
    _createChatBloc = context.read<CreateChatBloc>(); // Lưu lại bloc
    _createChatBloc.add(LoadListUser(_searchController.text));
  }

  @override
  void dispose() {
    _createChatBloc.add(ClearCreateChat()); // Gọi qua biến, KHÔNG dùng context
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createChatBloc = context.read<CreateChatBloc>();
    return BlocListener<CreateChatBloc, CreateChatState>(
      listener: (context, state) {
        if (state is CreateChatSuccess && state.isCreateSuccess) {
          context.pushReplacementNamed(
            PathName.chatRoomPage,
            extra: state.conversation,
          );
        } else if (state is CreateChatFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      child: BlocBuilder<CreateChatBloc, CreateChatState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: const Text(
                "Nhóm chat mới",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.pop();
                  context.read<CreateChatBloc>().add(ClearCreateChat());
                },
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
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: 16,
                          right: 16,
                        ),
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

                            onChanged: (text) {
                              if (_debounce?.isActive ?? false)
                                _debounce!.cancel();
                              _debounce = Timer(
                                const Duration(milliseconds: 500),
                                () {
                                  context.read<CreateChatBloc>().add(
                                    LoadListUser(text),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      _buildSelectedMembers(createChatBloc),
                      const SizedBox(height: 12),
                      _buildUserSuggestions(createChatBloc),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: commonButton(
                    text: 'Tạo nhóm',
                    onTap: () {
                      if (state is CreateChatSuccess) {
                        final member = state.members ?? [];
                        if (member.isNotEmpty) {
                          createChatBloc.add(
                            CreateNewChat(
                              participantIds:
                                  member.map((user) => user.id).toList() ?? [],
                              converationName: _groupNameController.text,
                              isGroup: true,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Vui lòng chọn thành viên')),
                          );
                        }
                      }
                    },
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedMembers(CreateChatBloc createChatBloc) {
    return BlocBuilder<CreateChatBloc, CreateChatState>(
      builder: (context, state) {
        if (state is CreateChatSuccess) {
          final members = state.members ?? [];
          if (members.isEmpty) return const SizedBox.shrink();

          return Container(
            margin: const EdgeInsets.only(top: 16),
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: members.length,
              itemBuilder: (context, index) {
                return _itemUserAdd(members[index], createChatBloc);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Hiển thị danh sách gợi ý người dùng
  Widget _buildUserSuggestions(CreateChatBloc createChatBloc) {
    return BlocBuilder<CreateChatBloc, CreateChatState>(
      builder: (context, state) {
        if (state is CreateChatSuccess && state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CreateChatSuccess) {
          final users = state.users ?? [];
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return _itemUserSuggestV1(users[index], createChatBloc);
            },
          );
        } else if (state is CreateChatFailure) {
          return Center(child: Text(state.errorMessage));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _itemUserAdd(UserModel user, CreateChatBloc createChatBloc) {
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
              Positioned(
                left: 55,
                bottom: 55,
                child: GestureDetector(
                  onTap: () {
                    createChatBloc.add(RemoveUserToGroup(user));
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      border: Border.all(width: 2, color: AppColors.black),
                    ),
                    child: SvgPicture.asset(
                      AppImages.icClose,
                      width: 16,
                      height: 16,
                    ),
                  ),
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

  Widget _itemUserSuggestV1(UserModel user, CreateChatBloc createChatBloc) {
    return BlocBuilder<CreateChatBloc, CreateChatState>(
      buildWhen:
          (previous, current) =>
              current
                  is CreateChatSuccess, // chỉ rebuild khi danh sách member thay đổi
      builder: (context, state) {
        bool isChecked = false;

        if (state is CreateChatSuccess) {
          final members = state.members ?? [];
          isChecked = members.any(
            (m) => m.id == user.id,
          ); // kiểm tra có trong nhóm không
        }

        return ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          leading: SvgPicture.network(
            user.avatar ??
                'https://api.dicebear.com/7.x/avataaars/svg?seed=Bob',
            width: 68,
            height: 68,
          ),
          title: Text(user.username ?? 'Unknown', style: AppStyles.title2Bold),
          subtitle: Text('Gợi ý cho bạn', style: AppStyles.bodyRegular),
          onTap: () {
            if (isChecked) {
              createChatBloc.add(RemoveUserToGroup(user));
            } else {
              createChatBloc.add(AddUserToGroup(user));
            }
          },
          trailing: Checkbox(
            value: isChecked,
            side: const BorderSide(color: AppColors.gray40, width: 2),
            checkColor: Colors.white,
            activeColor: Colors.blue,
            onChanged: (bool? value) {
              if (value == true) {
                createChatBloc.add(AddUserToGroup(user));
              } else {
                createChatBloc.add(RemoveUserToGroup(user));
              }
            },
          ),
        );
      },
    );
  }
}
