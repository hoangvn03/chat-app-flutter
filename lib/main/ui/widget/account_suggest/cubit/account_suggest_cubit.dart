import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:chat_app/main/networks/model/contact_user.dart';
import 'package:chat_app/main/networks/model/phone_contact.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/widget/account_suggest/cubit/account_suggest_state.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class AccountSuggestCubit extends Cubit<AccountSuggestState> {
  AccountSuggestCubit() : super(AccountSuggestLoading());

  Future<void> loadRequest() async {
    try {
      emit(AccountSuggestLoading());
      if (!await FlutterContacts.requestPermission()) {
        // emit(AccountSuggestFailure('User denied permission'));
      }
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      List<String> numbers = [];
      for (var c in contacts) {
        for (var p in c.phones) {
          numbers.add(p.number);
        }
      }
      final data = {'phone_numbers': numbers};
      var url = '${ApiEndPoints.USERS}/suggestions/contacts';
      ApiResponse res = await ApiUtil.post(url: url, data: data);
      if (res.statusCode == 200) {
        final phoneContacts =
            (res.body['data'] as List)
                .map((e) => PhoneContact.fromJson(e))
                .toList();

        emit(AccountSuggestSuccess(contactList: phoneContacts));
      } else {
        emit(
          AccountSuggestFailure(
            'Error ${res.statusCode}: ${res.body?['error']['message'] ?? 'Unknown'}',
          ),
        );
      }
    } catch (e) {
      print('eerrr $e');
      emit(AccountSuggestFailure(e.toString()));
    }
  }

  Future<void> follow() async {
    try {
      emit(AccountSuggestLoading());
      if (!await FlutterContacts.requestPermission()) {
        // emit(AccountSuggestFailure('User denied permission'));
      }
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      List<String> numbers = [];
      for (var c in contacts) {
        for (var p in c.phones) {
          numbers.add(p.number);
        }
      }
      final data = {'phone_numbers': numbers};
      var url = '${ApiEndPoints.USERS}/suggestions/contacts';
      ApiResponse res = await ApiUtil.post(url: url, data: data);
      if (res.statusCode == 200) {
        final phoneContacts =
            (res.body['data'] as List)
                .map((e) => PhoneContact.fromJson(e))
                .toList();

        emit(AccountSuggestSuccess(contactList: phoneContacts));
      } else {
        emit(
          AccountSuggestFailure(
            'Error ${res.statusCode}: ${res.body?['error']['message'] ?? 'Unknown'}',
          ),
        );
      }
    } catch (e) {
      print('eerrr $e');
      emit(AccountSuggestFailure(e.toString()));
    }
  }
}
