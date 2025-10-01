import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/reels.dart';
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

class SearchPage extends StatelessWidget {
  SearchPage({super.key});
  final TextEditingController _inputSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc()..add(LoadRequest()),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchSuccess) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.white,
                    surfaceTintColor: AppColors.white,
                    floating: true, // ẩn khi vuốt lên
                    snap: true, // hiện lại khi vuốt xuống
                    pinned: false, // không cố định
                    titleSpacing: 0,
                    title: GestureDetector(
                      onTap: () {
                        context.pushNamed(PathName.searchResultPage);
                      },
                      child: commonTextFieldV2(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        controller: _inputSearchController,
                        hintText: 'Tìm kiếm...',
                        enabled: false,
                      ),
                    ),
                  ),
                  // List posts
                  _buildListRequestInit(state.posts ?? []),
                ],
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

  Widget _buildListRequestInit(List<PostModel> posts) {
    return SliverGrid(
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: [
          QuiltedGridTile(2, 1), // Large square
          QuiltedGridTile(1, 1), // Small square
          QuiltedGridTile(1, 1), // Small square
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1), // Small square
        ],
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => _itemSearchInit(posts[index]),
        childCount: posts.length, // Use actual post count
      ),
    );
  }

  Widget _itemSearchInit(PostModel post) {
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
}
