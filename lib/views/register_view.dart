import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Register"), 
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform
                  ),
        builder: (context,snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:
            return Column(
            children: [
             TextField(
                controller: _email,
                autocorrect: false,
                enableSuggestions: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Enter Your Email"
                )
              ,
              ),
             TextField(
              controller: _password,
              obscureText: true,
              autocorrect: false,
              enableSuggestions: false,
              decoration: const InputDecoration(
                hintText: "Enter Your Password"
              ),
              ),
              TextButton(
                onPressed: () async {
              
                  final email = _email.text;
                  final password = _password.text;
                  final userCridentail = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email,
                    password: password
                  );
                  print(userCridentail);
                },
                child: const Text('Register'),
              ),
            ],
          );
          default:
          return const Text("Loadinh...");
          }
        }
      ),
    );
  }
}