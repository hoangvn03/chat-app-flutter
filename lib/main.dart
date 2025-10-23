import 'package:camera/camera.dart';
import 'package:chat_app/main/networks/api_end_point.dart';
import 'package:chat_app/main/networks/api_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/locale/locale_cubit.dart';
import 'l10n/app_localizations.dart';
import 'main/router/router_config.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await ApiEndPoints.init();
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => LocaleCubit())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return MaterialApp.router(
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          routerConfig: AppGoRouter.router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
