import 'package:chat_app/main/networks/model/contact_user.dart';
import 'package:chat_app/main/networks/model/phone_contact.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class AccountSuggestState {}

class AccountSuggestLoading extends AccountSuggestState {}

class AccountSuggestSuccess extends AccountSuggestState {
  final List<PhoneContact> contactList;
  AccountSuggestSuccess({required this.contactList});
  AccountSuggestSuccess copyWith({List<PhoneContact>? contactList}) {
    return AccountSuggestSuccess(contactList: contactList ?? this.contactList);
  }
}

class AccountSuggestFailure extends AccountSuggestState {
  String errorMessage;
  AccountSuggestFailure(this.errorMessage);
}
