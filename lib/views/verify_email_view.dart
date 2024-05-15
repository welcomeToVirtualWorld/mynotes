import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatelessWidget {
  const VerifyEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Verify Email"),
      ),
      body: Column(children: [
        const Text("Please verify your email address."),
        TextButton(onPressed: () async{
          await AuthService.firebase().sendEmailVerification();
        },
         child: const Text("Send Email Verifivation.")
         )
      ],
      ),
    );
  }
}