import 'package:chat_app/main/ui/reels/bloc/reels_bloc.dart';
import 'package:chat_app/main/ui/reels/bloc/reels_event.dart';
import 'package:chat_app/main/ui/reels/bloc/reels_state.dart';
import 'package:chat_app/main/ui/reels/reel_item.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReelsBloc()..add(LoadReelsMedia()),
      child: Scaffold(
        backgroundColor: AppColors.black,
        body: BlocBuilder<ReelsBloc, ReelsState>(
          builder: (context, state) {
            if (state is ReelsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReelsSuccess && state.posts != null) {
              return PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical, // vuốt dọc
                itemCount: state.posts!.length,
                onPageChanged: (index) {},
                itemBuilder: (context, index) {
                  return ReelItem(postModel: state.posts![index]);
                },
              );
            } else if (state is ReelsFailure) {
              return Center(child: Text(state.errorMessage));
            } else {
              return Center(child: Text('Fail to load API'));
            }
          },
        ),
      ),
    );
  }
}
