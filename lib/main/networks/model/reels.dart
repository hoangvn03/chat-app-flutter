import 'package:chat_app/main/networks/model/user.dart';

class ReelModel {
  UserModel? user;
  String? images;
  String? text;
  ReelModel({this.user, this.images, this.text});
  factory ReelModel.fromJson(Map<String, dynamic> json) {
    return ReelModel(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      images: json['images'],
      text: json['text'],
    );
  }
}
