import 'package:photo_manager/photo_manager.dart';

abstract class ListReelsState {}

class ListReelsLoading extends ListReelsState {}

class ListReelsSuccess extends ListReelsState {
  ListReelsSuccess(

  );
}

class ListReelsFailure extends ListReelsState {
  final String errorMessage;
  ListReelsFailure(this.errorMessage);
}
