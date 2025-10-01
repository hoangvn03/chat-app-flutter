import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/search/bloc/search_bloc.dart';
import 'package:chat_app/main/ui/search/bloc/search_event.dart';
import 'package:chat_app/main/ui/search/bloc/search_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:chat_app/res/app_images.dart';
import 'package:chat_app/res/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchResultPage extends StatelessWidget {
  SearchResultPage({super.key});
  final TextEditingController _inputSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              SearchBloc()..add(PressInputSearch(_inputSearchController.text)),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          titleSpacing: 0,
          title: _buildTitleAppBar(),

          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Transform.flip(
              flipX: true,
              child: SvgPicture.asset(
                AppImages.icNextRight,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchSuccess) {
              return SingleChildScrollView(
                child:
                // List posts
                _buildListSearchRequest(state.users ?? []),
              );
            } else if (state is SearchFailure) {
              return const Center(child: Text('Failed to load users'));
            }
            return const Center(child: Text('Welcome to the Search Page!'));
          },
        ),
      ),
    );
  }

  Widget _buildTitleAppBar() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return commonTextFieldV2(
          controller: _inputSearchController,
          hintText: 'Tìm kiếm...',
          onChanged:
              (value) =>
                  context.read<SearchBloc>().add(PressInputSearch(value)),
        );
      },
    );
  }

  Widget _buildListSearchRequest(List<UserModel> results) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (context, index) {
        return _itemUserSuggest(results[index], context);
      },
    );
  }

  Widget _itemUserSuggest(UserModel user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: Image.asset(AppImages.imgAvatarDefault),
        title: Text(user.email ?? 'Unknown', style: AppStyles.title2Bold),
        subtitle: Text(user.name ?? 'Unknown', style: AppStyles.bodyRegular),
        onTap: () {
          context.pushNamed(PathName.profilePage, extra: user);
        },
      ),
    );
  }
}
