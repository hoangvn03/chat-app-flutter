part of 'audio_bloc.dart';

abstract class AudioEvent {}

class PlayAudioEvent extends AudioEvent {
  final String url;
  final int id;
  final bool isPlayVoiceMessage;
  PlayAudioEvent(this.url, this.id,{this.isPlayVoiceMessage = false});
}

class PauseAudioEvent extends AudioEvent {

  final bool isPlayVoiceMessage;
  PauseAudioEvent({this.isPlayVoiceMessage = false});
}

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
