import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/user.dart';

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
  SendMessage(this.conversationId, this.message);
}
class ReceiveMessage extends ChatEvent {
  final Map<String,dynamic> message;
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
  UpdateTypingEvent(this.user,this.isStop);
}

class UserTypingOrStopTypingEvent extends ChatEvent {
  final int conversationId;
  final bool isStop;
  UserTypingOrStopTypingEvent({required this.conversationId,required this.isStop});
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


