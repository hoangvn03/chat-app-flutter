import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:chat_app/main/networks/model/contact_user.dart';
import 'package:chat_app/main/networks/model/user.dart';
import 'package:chat_app/main/ui/widget/account_suggest/cubit/account_suggest_state.dart';

class AccountSuggestCubit extends Cubit<AccountSuggestState> {
  AccountSuggestCubit() : super(AccountSuggestLoading());

  Future<void> loadRequest() async {
    try {
      emit(AccountSuggestLoading());
      var url = ApiEndPoints.FRIENDS;
      ApiResponse res = await ApiUtil.get(url, params: {'page': '1'});
      if (res.statusCode == 200) {
        final List<ContactUser> contactList =
            (res.body['data']['contacts'] as List)
                .map((e) => ContactUser.fromJson(e))
                .toList();

        emit(AccountSuggestSuccess(contactList: contactList));
      } else {
        emit(
          AccountSuggestFailure(
            'Error ${res.statusCode}: ${res.body?['message'] ?? 'Unknown'}',
          ),
        );
      }
    } catch (e) {
      emit(AccountSuggestFailure(e.toString()));
    }
  }
}
