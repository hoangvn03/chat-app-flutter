import 'package:chat_app/main/networks/model/user.dart';

class ContactUser {
  final int contactId;
  final UserModel? friend;
  final DateTime? createdAt;

  ContactUser({
    required this.contactId,
    this.friend,
    this.createdAt,
  });

  factory ContactUser.fromJson(Map<String, dynamic> json) {
    return ContactUser(
      contactId: json['contact_id'],
      friend: json['friend'] != null ? UserModel.fromJson(json['friend']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact_id': contactId,
      'friend': friend?.toJson(),
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
