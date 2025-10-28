import 'package:chat_app/main/ui/conversations/screens/message/audio_chat/bloc/audio_bloc.dart';
import 'package:chat_app/res/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget audio({
  required String message,
  required bool isCurrentUser,
  required int index,
  required String time,
  required String duration,
}) {
  return BlocBuilder<AudioBloc, AudioState>(
    builder: (context, state) {
      bool isPlaying = false;
      double progress = 0.0;
      int currentId = -1;

      // Chỉ đọc khi state là AudioStateSuccess
      if (state is AudioStateSuccess) {
        isPlaying = state.isPlaying;
        progress = state.progress;
        currentId = state.currentId;
      }

      return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? AppColors.blue20
              : AppColors.blue20.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                final bloc = context.read<AudioBloc>();
                if (isPlaying && currentId == index) {
                  bloc.add(PauseAudioEvent());
                } else {
                  bloc.add(PlayAudioEvent(message, index));
                }
              },
              child: Icon(
                (isPlaying && currentId == index)
                    ? Icons.pause
                    : Icons.play_arrow,
                color: isCurrentUser ? Colors.white : AppColors.blue20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: LinearProgressIndicator(
                minHeight: 4,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCurrentUser ? Colors.white : AppColors.blue20,
                ),
                value: (isPlaying && currentId == index) ? progress : 0.0,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              duration,
              style: TextStyle(
                fontSize: 12,
                color: isCurrentUser ? Colors.white : AppColors.blue20,
              ),
            ),
          ],
        ),
      );
    },
  );
}
