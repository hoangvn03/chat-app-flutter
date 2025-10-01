
import 'package:chat_app/main/networks/model/user.dart';

class MessageModel {
  int? id;
  UserModel? userModel;
  String? status;
  List<String>? userMessage;
  List<String>? userContactMessage;

  MessageModel({this.id,this.status,this.userModel,this.userMessage, this.userContactMessage});

}
