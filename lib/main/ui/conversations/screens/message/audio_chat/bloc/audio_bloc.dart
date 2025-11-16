import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:record/record.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

part 'audio_event.dart';
part 'audio_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioRecorder _record = AudioRecorder();

  AudioBloc() : super(AudioInitial()) {
    // --- AUDIO ---
    on<PlayAudioEvent>(_onPlayAudio);
    on<PauseAudioEvent>(_onPauseAudio);
    on<StopAudioEvent>(_onStopAudio);

    // --- RECORD ---
    on<StartRecordEvent>(_onStartRecord);
    on<StopRecordEvent>(_onStopRecord);

    // --- LISTEN DURATION ---
    _audioPlayer.onDurationChanged.listen((duration) {
      add(UpdateTotalDurationEvent(duration.inMicroseconds));
    });

    _audioPlayer.onPositionChanged.listen((position) {
      add(UpdateCurrentDurationEvent(position.inMicroseconds));
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      add(StopAudioEvent());
    });

    on<UpdateTotalDurationEvent>((event, emit) {
      if (state is AudioStateSuccess) {
        final s = state as AudioStateSuccess;
        emit(s.copyWith(totalDuration: event.totalDuration));
      }
    });

    on<UpdateCurrentDurationEvent>((event, emit) {
      if (state is AudioStateSuccess) {
        final s = state as AudioStateSuccess;
        double progress =
            (s.totalDuration == 0)
                ? 0
                : event.currentDuration / s.totalDuration;
        emit(
          s.copyWith(
            currentDuration: event.currentDuration,
            progress: progress,
          ),
        );
      }
    });
  on<ResetAudioEvent>((event, emit) {
  emit(AudioInitial());
});
  }

  // --- PLAY AUDIO ---
  Future<void> _onPlayAudio(
    PlayAudioEvent event,
    Emitter<AudioState> emit,
  ) async {
    await _audioPlayer.play(UrlSource(event.url));
    emit(
      AudioStateSuccess(
        isPlaying: true,
        currentId: event.id,
        currentUrl: event.url,
        isPlayVoiceMessage: event.isPlayVoiceMessage,
      ),
    );
  }

  // --- PAUSE AUDIO ---
  Future<void> _onPauseAudio(
    PauseAudioEvent event,
    Emitter<AudioState> emit,
  ) async {
    await _audioPlayer.pause();
    if (state is AudioStateSuccess) {
      emit(
        (state as AudioStateSuccess).copyWith(
          isPlaying: false,
          isPlayVoiceMessage: event.isPlayVoiceMessage,
        ),
      );
    }
  }

  // --- STOP AUDIO ---
  Future<void> _onStopAudio(
    StopAudioEvent event,
    Emitter<AudioState> emit,
  ) async {
    await _audioPlayer.stop();
    if (state is AudioStateSuccess) {
      emit(
        (state as AudioStateSuccess).copyWith(isPlaying: false, progress: 0),
      );
    } else {
      emit(AudioInitial());
    }
  }

  // --- START RECORDING ---
  Future<void> _onStartRecord(
    StartRecordEvent event,
    Emitter<AudioState> emit,
  ) async {
    if (await _record.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      final path =
          '${dir.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _record.start(
        RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      emit(AudioRecording(path: path));
    } else {
      emit(AudioError("Không có quyền ghi âm"));
    }
  }

  Future<void> _onStopRecord(
    StopRecordEvent event,
    Emitter<AudioState> emit,
  ) async {
    final path = await _record.stop();
    if (path != null) {
      final tempPlayer = AudioPlayer();
      await tempPlayer.setSource(DeviceFileSource(path));
      final totalDuration = await tempPlayer.getDuration();
      await tempPlayer.dispose();
      emit(
        AudioStateSuccess(
          currentUrl: path,
          totalDuration: totalDuration?.inMilliseconds ?? 0,
        ),
      );
    } else {
      emit(AudioError("Ghi âm thất bại"));
    }
  }

  final Map<String, String> _cachedDurations = {};

  Future<String> getAudioDuration(String url) async {
    if (_cachedDurations.containsKey(url)) return _cachedDurations[url]!;
    final player = AudioPlayer();
    await player.setSourceUrl(url);
    final duration = await player.getDuration();
    player.dispose();
    if (duration != null) {
      final seconds = duration.inSeconds;
      final formatted =
          '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
      _cachedDurations[url] = formatted;
      return formatted;
    }
    return '00:00';
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    _record.dispose();
    return super.close();
  }
}
