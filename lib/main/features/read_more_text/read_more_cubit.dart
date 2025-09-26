import 'package:flutter_bloc/flutter_bloc.dart';

class ReadMoreCubit extends Cubit<bool> {
  ReadMoreCubit() : super(false); // mặc định chưa mở rộng

  void toggle() => emit(!state);
}
