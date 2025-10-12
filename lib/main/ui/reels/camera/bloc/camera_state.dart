import 'package:camera/camera.dart';

abstract class CameraState {}

class CameraLoading extends CameraState {}

class CameraSuccess extends CameraState {
  final String? imagePath;

  CameraSuccess({this.imagePath});

}
class TakeMediaSuccess extends CameraState {
  final String imagePath;
  TakeMediaSuccess({required this.imagePath});
}


class CameraFailure extends CameraState {
  final String errorMessage;
  CameraFailure(this.errorMessage);
}
