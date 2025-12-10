import 'package:chat_app/main/networks/model/user.dart';

class PhoneContact {
  final String phoneNumber;
  final bool isRegistered;
  final UserModel? user;

  PhoneContact({
    required this.phoneNumber,
    required this.isRegistered,
    this.user,
  });

  factory PhoneContact.fromJson(Map<String, dynamic> json) {
    return PhoneContact(
      phoneNumber: json['phone_number'],
      isRegistered: json['is_registered'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
