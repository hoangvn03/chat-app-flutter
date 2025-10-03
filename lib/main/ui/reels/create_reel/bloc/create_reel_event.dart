import 'package:chat_app/main/networks/model/user.dart';
import 'package:photo_manager/photo_manager.dart';

abstract class CreateReelsEvent {}

class LoadRequest extends CreateReelsEvent {
  final int maxCount;
  final RequestType requestType;
  AssetPathEntity? selectedAlbum;
  LoadRequest(this.requestType, this.maxCount,{this.selectedAlbum});
}

class UpdateUser extends CreateReelsEvent {
  final UserModel user;
  UpdateUser(this.user);
}
