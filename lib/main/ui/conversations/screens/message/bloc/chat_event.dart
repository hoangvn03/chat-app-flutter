import 'dart:io';

import 'package:chat_app/main/networks/enum.dart';
import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

abstract class ChatEvent {}

class LoadMessage extends ChatEvent {
  Conversation conversation;
  LoadMessage(this.conversation);
}

class LoadDetailConveration extends ChatEvent {
  int id;
  LoadDetailConveration(this.id);
}

class SendMessage extends ChatEvent {
  final int conversationId;
  final String message;
  List<AssetEntity>? mediaFiles;
  List<File>? files;

  SendMessage(this.conversationId, this.message, {this.mediaFiles,this.files});
}

class ReceiveMessage extends ChatEvent {
  final Map<String, dynamic> message;
  ReceiveMessage(this.message);
}

class SendFilesMessage extends ChatEvent {
  final int conversationId;
  final String filePath; // đường dẫn file local
  final String fileName; // tên file
  final String fileType; // 'audio', 'image', 'video', 'file'
  final String? duration; // độ dài audio (chỉ dùng cho audio)
  final String? thumbnail; // thumbnail cho video (tuỳ chọn)

  SendFilesMessage({
    required this.conversationId,
    required this.filePath,
    required this.fileName,
    required this.fileType,
    this.duration,
    this.thumbnail,
  });
}

class UpdateTypingEvent extends ChatEvent {
  final UserModel user;
  final bool isStop;
  UpdateTypingEvent(this.user, this.isStop);
}

class UserTypingOrStopTypingEvent extends ChatEvent {
  final int conversationId;
  final bool isStop;
  UserTypingOrStopTypingEvent({
    required this.conversationId,
    required this.isStop,
  });
}

class MessageReadEvent extends ChatEvent {
  final int messageId;
  final int userId;

  MessageReadEvent({required this.messageId, required this.userId});
}

class MarkMessageAsRead extends ChatEvent {
  final int messageId;

  MarkMessageAsRead({required this.messageId});
}

class UpdateOnlineUsers extends ChatEvent {
  final List<UserModel> onlineUsers;
  UpdateOnlineUsers({required this.onlineUsers});
}

class UpdateStatusUsers extends ChatEvent {
  final StatusUser status;
  final bool isInit;
  UpdateStatusUsers({required this.status, required this.isInit});
}
class UpdateStatusMessage extends ChatEvent {
    final int messageId;
    final int receiverId;
  UpdateStatusMessage({required this.messageId, required this.receiverId});
}
class ClearStatusMessageEvent extends ChatEvent {}

class UploadFileMessage extends ChatEvent {
  List<dynamic> file;
  int conversationId;
  int messageId;
  UploadFileMessage({
    required this.file,
    required this.conversationId,
    required this.messageId,
  });
}
// Thêm class này vào file chat_event.dart
class ClearAlertMessage extends ChatEvent {}