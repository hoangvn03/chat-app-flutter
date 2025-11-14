import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';

abstract class CameraEvent {}

class LoadCameraMedia extends CameraEvent {}
class TakePicture extends CameraEvent {
  CameraController? cameraController;
  TakePicture({this.cameraController});
}
class ChangeFilterPage extends CameraEvent {
  final int index;
  final PageController pageController;
  ChangeFilterPage({required this.index, required this.pageController});
}
