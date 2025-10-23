import 'package:chat_app/main/networks/model/contact_user.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class AccountSuggestState {}

class AccountSuggestLoading extends AccountSuggestState {}

class AccountSuggestSuccess extends AccountSuggestState {
  final List<ContactUser> contactList;
  AccountSuggestSuccess({required this.contactList});
  AccountSuggestSuccess copyWith({List<ContactUser>? contactList}) {
    return AccountSuggestSuccess(contactList: contactList ?? this.contactList);
  }
}

class AccountSuggestFailure extends AccountSuggestState {
  String errorMessage;
  AccountSuggestFailure(this.errorMessage);
}
