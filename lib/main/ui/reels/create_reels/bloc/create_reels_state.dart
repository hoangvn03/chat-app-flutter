import 'package:chat_app/main/networks/model/reels.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class CreateReelsState {}

class CreateReelsLoading extends CreateReelsState {}

class CreateReelsWithCamera extends CreateReelsState {
  CreateReelsWithCamera();
}

class CreateReelsWithMediaPicked extends CreateReelsState {
  List<AssetEntity> mediaPicked;
List<ReelModel> stories;
  CreateReelsWithMediaPicked({required this.mediaPicked,required this.stories});
}

class CreateReelsSuccess extends CreateReelsState {
  CreateReelsSuccess();
}

class CreateReelsFailure extends CreateReelsState {
  final String errorMessage;
  CreateReelsFailure(this.errorMessage);
}
