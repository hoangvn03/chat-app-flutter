import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main/networks/model/reels.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/reels/list_reels/bloc/list_reels_bloc.dart';
import 'package:chat_app/main/ui/reels/list_reels/bloc/list_reels_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:video_player/video_player.dart';

// // ignore: must_be_immutable
// class ListReelsPage extends StatefulWidget {
//   ListReelsPage({this.assetList, super.key});
//   List<AssetEntity>? assetList;
//   @override
//   State<ListReelsPage> createState() => _ListReelsPageState();
// }

// class _ListReelsPageState extends State<ListReelsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => ListReelsBloc()..add(LoadReelsMedia()),
//       child: Scaffold(body: Container()),
//     );
//   }
// }

class StoryScreen extends StatefulWidget {
  final List<ReelModel> stories;

  const StoryScreen({super.key, required this.stories});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  VideoPlayerController? _videoController; // video có thể null

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);

    final ReelModel firstStory = widget.stories.first;
    _loadStory(story: firstStory, animateToPage: false);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.stop();
        _animController.reset();
        setState(() {
          if (_currentIndex + 1 < widget.stories.length) {
            _currentIndex += 1;
            _loadStory(story: widget.stories[_currentIndex]);
          } else {
            // Out of bounds - loop story
            // You can also Navigator.of(context).pop() here
            _currentIndex = 0;
            _loadStory(story: widget.stories[_currentIndex]);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ReelModel story = widget.stories[_currentIndex];
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, story),
        child: Stack(
          children: <Widget>[
            PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (context, i) {
                final ReelModel story = widget.stories[i];
                final listAsset = widget.stories[i].assetList;
                return (listAsset?.first is File)
                    ? Image.file(
                      File(listAsset?[0]),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        );
                      },
                    )
                    : AssetEntityImage(
                      listAsset?[0],
                      isOriginal: false,
                      thumbnailSize: const ThumbnailSize.square(250),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        );
                      },
                    );
                // switch (story.media) {
                //   case MediaType.image:
                //     return CachedNetworkImage(
                //       imageUrl:
                //           story.url ??
                //           'https://images.unsplash.com/photo-1534103362078-d07e750bd0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                //       fit: BoxFit.cover,
                //     );
                //   case MediaType.video:
                //     if (_videoController != null &&
                //         _videoController!.value.isInitialized) {
                //       return FittedBox(
                //         fit: BoxFit.cover,
                //         child: SizedBox(
                //           width: _videoController!.value.size.width,
                //           height: _videoController!.value.size.height,
                //           child: VideoPlayer(_videoController!),
                //         ),
                //       );
                //     } else {
                //       return const Center(child: CircularProgressIndicator());
                //     }
                //   case null:
                //     // Nếu story.media bị null → trả về widget mặc định
                //     return const SizedBox.shrink();
                // }
              },
            ),
            Positioned(
              top: 40.0,
              left: 10.0,
              right: 10.0,
              child: Column(
                children: <Widget>[
                  Row(
                    children:
                        widget.stories
                            .asMap()
                            .map((i, e) {
                              return MapEntry(
                                i,
                                AnimatedBar(
                                  animController: _animController,
                                  position: i,
                                  currentIndex: _currentIndex,
                                ),
                              );
                            })
                            .values
                            .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 1.5,
                      vertical: 10.0,
                    ),
                    child: UserInfo(
                      user:
                          story.user ??
                          UserModel(
                            id: 999,
                            username: 'Unknown',
                            avatar: 'https://wallpapercave.com/wp/AYWg3iu.jpg',
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details, ReelModel story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;
    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadStory(story: widget.stories[_currentIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.stories.length) {
          _currentIndex += 1;
          _loadStory(story: widget.stories[_currentIndex]);
        } else {
          // Out of bounds - loop story
          // You can also Navigator.of(context).pop() here
          _currentIndex = 0;
          _loadStory(story: widget.stories[_currentIndex]);
        }
      });
    } else {
      if (story.media == MediaType.video && _videoController != null) {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
          _animController.stop();
        } else {
          _videoController!.play();
          _animController.forward();
        }
      }
    }
  }

  void _loadStory({required ReelModel story, bool animateToPage = true}) {
    _animController.stop();
    _animController.reset();
    switch (story.media) {
      case MediaType.image:
        _animController.duration = story.duration;
        _animController.forward();
        break;

      case MediaType.video:
        _videoController?.dispose();
        _videoController = VideoPlayerController.network(
            story.url ??
                'https://images.unsplash.com/photo-1534103362078-d07e750bd0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
          )
          ..initialize().then((_) {
            setState(() {});
            if (_videoController!.value.isInitialized) {
              _animController.duration = _videoController!.value.duration;
              _videoController!.play();
              _animController.forward();
            }
          });
        break;

      case null:
        // nếu media null thì không làm gì hoặc log ra lỗi
        debugPrint('⚠️ story.media is null');
        break;
    }

    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    super.key,
    required this.animController,
    required this.position,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                      animation: animController,
                      builder: (context, child) {
                        return _buildContainer(
                          constraints.maxWidth * animController.value,
                          Colors.white,
                        );
                      },
                    )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildContainer(double width, Color color) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black26, width: 0.8),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  final UserModel user;

  const UserInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: Colors.grey[300],
          backgroundImage: CachedNetworkImageProvider(
            user.avatar ?? 'https://wallpapercave.com/wp/AYWg3iu.jpg',
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            user.username ?? 'Unknown',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 30.0, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
