import 'package:chat_app/main/router/router.dart';
import 'package:chat_app/main/utils/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await AppStorage.clearToken();
            // ignore: use_build_context_synchronously
            context.go(AppPath.loginPage);
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
