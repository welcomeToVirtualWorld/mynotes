import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Home"), 
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform
                  ),
        builder: (context,snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if(user?.emailVerified == true){
              print("You are verified user.");
            }else{
              print("You need to verify your email first.");
            }
              return const Text("Done");
            default:
              return const Text("Loading...");
          }
        }
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}




