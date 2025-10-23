import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/reels.dart';
class UserResponse {
  final List<UserModel> users;
  final Pagination pagination;

  UserResponse({required this.users, required this.pagination});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      users:
          (json['users'] as List)
              .map((x) => UserModel.fromJson(x))
              .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}
class RoleData {
  int? id;
  String? code;
  String? value;

  RoleData({this.id, this.code, this.value});

  factory RoleData.fromJson(Map<String, dynamic> json) {
    return RoleData(
      id: json['user_id'],
      code: json['code'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': id, 'code': code, 'value': value};
  }
}

class UserModel {
  int id;
  String? username;
  String? fullname;
  bool? isPrivate;
  String? bio;
  String? email;
  String? avatar;
  String? status;
  String? createdAt;
  List<ReelModel>? reels;
  // RoleData? roleData;

  UserModel({
    required this.id,
    this.username,
    this.fullname,
    this.isPrivate,
    this.bio,
    this.email,
    this.avatar,
    // this.roleData,
    this.status,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'],
      username: json['username'],
      fullname: json['full_name'],
      isPrivate: json['is_private'],
      bio: json['bio'],
      email: json['email'],
      avatar: json['avatar_url'],
      status: json['status'],
      createdAt: json['created_at'],
      // roleData: json['roleData'] != null
      //     ? RoleData.fromJson(json['roleData'])
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'username': username,
      'email': email,
      'avatar_url': avatar,
    };
  }
}

class UserContact {
  final int contactId;
  final int userId;
  final int friendId;
  final DateTime createdAt;

  UserContact({
    required this.contactId,
    required this.userId,
    required this.friendId,
    required this.createdAt,
  });

  // Tạo từ JSON
  factory UserContact.fromJson(Map<String, dynamic> json) {
    return UserContact(
      contactId: json['contact_id'] as int,
      userId: json['user_id'] as int,
      friendId: json['friend_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // Chuyển sang JSON
  Map<String, dynamic> toJson() {
    return {
      'contact_id': contactId,
      'user_id': userId,
      'friend_id': friendId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
