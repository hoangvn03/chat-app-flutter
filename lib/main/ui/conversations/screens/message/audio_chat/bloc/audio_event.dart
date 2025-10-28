part of 'audio_bloc.dart';

abstract class AudioEvent {}

class PlayAudioEvent extends AudioEvent {
  final String url;
  final int id;
  PlayAudioEvent(this.url, this.id);
}

class PauseAudioEvent extends AudioEvent {}

class StopAudioEvent extends AudioEvent {}

class UpdateTotalDurationEvent extends AudioEvent {
  final int totalDuration;
  UpdateTotalDurationEvent(this.totalDuration);
}

class UpdateCurrentDurationEvent extends AudioEvent {
  final int currentDuration;
  UpdateCurrentDurationEvent(this.currentDuration);
}

class StartRecordEvent extends AudioEvent {}

class StopRecordEvent extends AudioEvent {}
