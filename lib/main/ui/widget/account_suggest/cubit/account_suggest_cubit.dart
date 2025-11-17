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
      var url = '${ApiEndPoints.USERS}/suggestions';
      var params = {'page': '1', 'limit': '20'};

      ApiResponse res = await ApiUtil.get(url, params: params);
      if (res.statusCode == 200) {
        final List<UserModel> contactList =
            (res.body['data']['suggestions'] as List)
                .map((e) => UserModel.fromJson(e))
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
