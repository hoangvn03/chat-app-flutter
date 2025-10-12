import 'package:chat_app/main/networks/model/reels.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class CreateReelsState {}

class CreateReelsLoading extends CreateReelsState {}

class CreateReelsSuccess extends CreateReelsState {
  List<AssetEntity> mediaPicked;
List<ReelModel> stories;
  CreateReelsSuccess({required this.mediaPicked,required this.stories});}

class CreateReelsFailure extends CreateReelsState {
  final String errorMessage;
  CreateReelsFailure(this.errorMessage);
}
