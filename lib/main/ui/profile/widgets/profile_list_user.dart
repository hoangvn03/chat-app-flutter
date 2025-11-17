import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/widget/account_suggest/account_suggest_widget.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:chat_app/main/ui/profile/bloc/profile_bloc.dart';
import 'package:chat_app/main/ui/profile/bloc/profile_event.dart';
import 'package:chat_app/main/ui/profile/bloc/profile_state.dart';

class ProfileListFollowerPage extends StatefulWidget {
  final UserModel user;
  final int index;
  const ProfileListFollowerPage({
    super.key,
    required this.user,
    required this.index,
  });

  @override
  State<ProfileListFollowerPage> createState() =>
      _ProfileListFollowerPageState();
}

class _ProfileListFollowerPageState extends State<ProfileListFollowerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.index, // <<< SET INDEX BAN ĐẦU
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create:
          (_) =>
              ProfileBloc()
                ..add(LoadListUserProfile(widget.user, widget.index)),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          title: Text(
            widget.user.username ?? 'Followers',
            style: AppStyles.title1Bold,
          ),
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    indicatorColor: Colors.black,
                    dividerColor: AppColors.gray30,
                    isScrollable: true,
                    labelPadding: EdgeInsets.symmetric(horizontal: 16),
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 1,
                    tabs: [
                      Tab(
                        text:
                            'Người theo dõi ${state is ProfileSuccess && state.usersContatct != null ? '(${state.usersContatct!.length})' : ''}',
                      ),
                      Tab(
                        text:
                            'Đang theo dõi ${state is ProfileSuccess && state.userFollowing != null ? '(${state.userFollowing!.length})' : ''}',
                      ),
                      Tab(text: 'Dành cho bạn'),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // ====== Ô tìm kiếm ===== //
                commonTextFieldV2(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  hintText: 'Tìm kiếm',
                  controller: _textController,
                  color: AppColors.white,
                  border: Border.all(width: 1, color: AppColors.gray30),
                  hasHeight: false,
                  padding: EdgeInsets.only(top: 16, bottom: 16, right: 16),
                  hasLeading: false,
                ),

                const SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        state is ProfileSuccess && state.usersContatct != null
                            ? ListView.builder(
                              itemCount:
                                  state.usersContatct!.length +
                                  2, // +2: 1 cho SizedBox, 1 cho AccountSuggestWidget
                              itemBuilder: (context, index) {
                                if (index < state.usersContatct!.length) {
                                  // render từng follower item
                                  final user = state.usersContatct![index];
                                  return _buildFollowerItem(user);
                                } else if (index ==
                                    state.usersContatct!.length) {
                                  // SizedBox giữa
                                  return const SizedBox(height: 10);
                                } else {
                                  return AccountSuggestWidget(
                                    title: 'Gợi ý cho bạn',
                                    isHorirontal: false,
                                  );
                                }
                              },
                            )
                            : Center(child: CircularProgressIndicator()),

                        state is ProfileSuccess && state.userFollowing != null
                            ? ListView.builder(
                              itemCount:
                                  state.userFollowing!.length +
                                  2, // +2: 1 cho SizedBox, 1 cho AccountSuggestWidget
                              itemBuilder: (context, index) {
                                if (index < state.userFollowing!.length) {
                                  // render từng follower item
                                  final user = state.userFollowing![index];
                                  return _buildFollowerItem(user);
                                } else if (index ==
                                    state.userFollowing!.length) {
                                  // SizedBox giữa
                                  return const SizedBox(height: 10);
                                } else {
                                  // AccountSuggestWidget ở cuối
                                  return AccountSuggestWidget(
                                    isHorirontal: false,
                                  );
                                }
                              },
                            )
                            : Center(child: CircularProgressIndicator()),
                        state is ProfileSuccess && state.suggestUsers != null
                            ? ListView.builder(
                              itemCount:
                                  state.suggestUsers!.length +
                                  2, // +2: 1 cho SizedBox, 1 cho AccountSuggestWidget
                              itemBuilder: (context, index) {
                                if (index < state.suggestUsers!.length) {
                                  // render từng follower item
                                  final user = state.suggestUsers![index];
                                  return _buildFollowerItem(user);
                                } else if (index ==
                                    state.suggestUsers!.length) {
                                  // SizedBox giữa
                                  return const SizedBox(height: 10);
                                } else {
                                  // AccountSuggestWidget ở cuối
                                  return AccountSuggestWidget(
                                    isHorirontal: false,
                                  );
                                }
                              },
                            )
                            : Center(child: CircularProgressIndicator()),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFollowerItem(UserModel user) {
    return commonTileItemV2(
      onTap: () {},
      leadingWidget: groupUserAvatar(
        images: [user.avatar ?? ''],
        avatarSize: 48,
      ),
      trallingWidget: SvgPicture.asset(AppImages.icCamera),
      title: user.username ?? 'Unknown',
      subtitle: null,
      margin: EdgeInsets.symmetric(vertical: 12),
    );
  }
}
