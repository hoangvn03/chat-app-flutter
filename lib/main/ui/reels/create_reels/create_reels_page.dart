import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_bloc.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_event.dart';
import 'package:chat_app/main/ui/reels/create_reels/bloc/create_reels_state.dart';
import 'package:chat_app/main/utils/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

// ignore: must_be_immutable
class CreateReelsPage extends StatefulWidget {
  CreateReelsPage({this.assetList, super.key});
  List<AssetEntity>? assetList;
  @override
  State<CreateReelsPage> createState() => _CreateReelsPageState();
}

class _CreateReelsPageState extends State<CreateReelsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              CreateReelsBloc()
                ..add(LoadReelsMedia(assetList: widget.assetList ?? [])),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<CreateReelsBloc, CreateReelsState>(
            builder: (context, state) {
              if (state is CreateReelsWithMediaPicked) {
                return commonButton(
                  text: 'Create Reels',
                  onTap: () {
                    context.pushNamed(
                      PathName.listReelsPage,
                      extra: state.stories,
                    );
                  },
                );
              }
              if (state is CreateReelsWithMediaPicked) {
                return commonButton(
                  text: 'Create Reels With Camera',
                  onTap: () {
                    // context.pushNamed(
                    //   PathName.listReelsPage,
                    //   extra: state.mediaPicked,
                    // );
                  },
                );
              }
              return commonButton(text: 'Create Reels Failure', onTap: () {});
            },
          ),
        ),
      ),
    );
  }
}
