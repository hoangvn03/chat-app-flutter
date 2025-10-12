import 'package:chat_app/main/networks/model/user.dart';
import 'package:photo_manager/photo_manager.dart';
enum MediaType {image,video}
class ReelModel {
  UserModel? user;
  String? images;
  String? url;
  MediaType? media;
  Duration? duration;
  String? text;
  List<dynamic>? assetList;
  ReelModel({this.user, this.images, this.text,this.url,this.media,this.duration,this.assetList});
  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      images: json['images'],
      text: json['text'],
    );
  }
}
