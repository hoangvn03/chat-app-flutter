class RoleData {
  int? id;
  String? code;
  String? value;

  RoleData({this.id, this.code, this.value});

  factory RoleData.fromJson(Map<String, dynamic> json) {
    return RoleData(
      id: json['id'],
      code: json['code'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'value': value,
    };
  }
}

class UserModel {
  int? id;
  String? name;
  String? email;
  String? avatar;
  RoleData? roleData;

  UserModel({this.id, this.name, this.email, this.avatar, this.roleData});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      roleData: json['roleData'] != null
          ? RoleData.fromJson(json['roleData'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'roleData': roleData?.toJson(),
    };
  }
}
