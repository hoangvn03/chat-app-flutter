part of 'audio_bloc.dart';

abstract class AudioState {}

class AudioStateSuccess extends AudioState {
  final bool isPlaying;
  final int currentId;
  final String currentUrl;
  final int currentDuration;
  final int totalDuration;
  final double progress;

  AudioStateSuccess({
    this.isPlaying = false,
    this.currentId = -1,
    this.currentUrl = '',
    this.currentDuration = 0,
    this.totalDuration = 0,
    this.progress = 0.0,
  });

  AudioStateSuccess copyWith({
    bool? isPlaying,
    int? currentId,
    String? currentUrl,
    int? currentDuration,
    int? totalDuration,
    double? progress,
  }) {
    return AudioStateSuccess(
      isPlaying: isPlaying ?? this.isPlaying,
      currentId: currentId ?? this.currentId,
      currentUrl: currentUrl ?? this.currentUrl,
      currentDuration: currentDuration ?? this.currentDuration,
      totalDuration: totalDuration ?? this.totalDuration,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [
        isPlaying,
        currentId,
        currentUrl,
        currentDuration,
        totalDuration,
        progress
      ];
}

class AudioInitial extends AudioState {}
class AudioFailured extends AudioState {}

class AudioRecording extends AudioState {
  final String path;
  AudioRecording({required this.path});
}

class AudioRecorded extends AudioState {
  final String path;
  AudioRecorded({required this.path});
}

class AudioError extends AudioState {
  final String message;
  AudioError(this.message);
}
