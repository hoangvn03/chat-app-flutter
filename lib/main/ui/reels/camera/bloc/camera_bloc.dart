import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:chat_app/main/ui/reels/camera/bloc/camera_event.dart';
import 'package:chat_app/main/ui/reels/camera/bloc/camera_state.dart';
import 'package:flutter/material.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  // CameraController? _controller;

  CameraBloc() : super(CameraLoading()) {
    on<ChangeFilterPage>(_changeFilterPage);
    on<TakePicture>(_takePicture);
  }

  Future<void> _changeFilterPage(
    ChangeFilterPage event,
    Emitter<CameraState> emit,
  ) async {
    await event.pageController.animateToPage(
      event.index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    emit(CameraSuccess());
  }

Future<void> _takePicture(
  TakePicture event,
  Emitter<CameraState> emit,
) async {
  try {

    final XFile file = await event.cameraController!.takePicture();
    emit(TakeMediaSuccess(imagePath: file.path));
  } catch (e) {
    emit(CameraFailure('Lỗi khi chụp ảnh: $e'));
  }
}

}
