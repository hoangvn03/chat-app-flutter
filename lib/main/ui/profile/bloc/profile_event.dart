import 'package:chat_app/main/networks/model/user.dart';
import 'package:flutter/material.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
}
class LoadProfileUserContact extends ProfileEvent {
  int id;
  LoadProfileUserContact(this.id);
}
class LoadConveration extends ProfileEvent {
    int id;
  LoadConveration(this.id);
}

class ClearStrogeUser extends ProfileEvent {
}
class EditProfile extends ProfileEvent {
  final UserModel user;
  EditProfile(this.user);
}

class UpdateUser extends ProfileEvent {
  final UserModel user;
  UpdateUser(this.user);
}
class LoadListUserProfile extends ProfileEvent {
  final UserModel user;
  final int index;
  LoadListUserProfile(this.user,this.index);
}
class PageChange extends ProfileEvent {
  final int index;
    final UserModel? user;

  final TabController tabController;
  PageChange(this.index,this.tabController,{this.user});
}