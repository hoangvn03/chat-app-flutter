import 'package:chat_app/main/networks/enum.dart';
import 'package:chat_app/main/networks/model/post.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class HomeEvent {}

class LoadRequest extends HomeEvent {}

class GetNotificationCount extends HomeEvent {
  final int num;
  GetNotificationCount(this.num);
}

class CreatePost extends HomeEvent {
  final String caption;
  final String location;
  final List<AssetEntity> assetImage;

  CreatePost({
    required this.caption,
    required this.location,
    required this.assetImage,
  });
}

class AddNewPost extends HomeEvent {
  final PostModel post;

  AddNewPost({required this.post});
}

class UpdateStatusUsers extends HomeEvent {
  final String status;
  final bool isInit;
  UpdateStatusUsers({required this.status, required this.isInit});
}
