import 'package:chat_app/main/networks/model/user.dart';

abstract class SearchEvent {}

class LoadRequest extends SearchEvent {}

class PressInputSearch extends SearchEvent {
  final String input;
  PressInputSearch(this.input);
}

