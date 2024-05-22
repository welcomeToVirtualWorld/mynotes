import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'dart:developer';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  //late final NotesService _notesService;
  late final FirebaseCloudStorage _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;
  String get userId => AuthService.firebase().currentUser!.id;
  

  @override
  void initState() {
    //_notesService = NotesService();
    //_notesService.open();
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Your Notes"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  {
                    print("Logout---->");
                    final shouldLogout = await showLogOutDialog(context);
                    log("Logout::->$shouldLogout");
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    }
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text("Logout")),
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId:note.documentId);
                  },
                  onTap: (note) async {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          )
        ],
      );
    },
  ).then((value) => value ?? false);
}



// body: FutureBuilder(
//         future: _notesService.getOrCreateUser(email: userEmail),
//         builder: (context, snapshot) {  
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               return StreamBuilder(
//                   stream: _notesService.allNotes,
//                   builder: (context, snapshot) {
//                     switch (snapshot.connectionState) {
//                       case ConnectionState.waiting:
//                       case ConnectionState.active:
//                         if (snapshot.hasData) {
//                           final allNotes = snapshot.data as List<DatabaseNote>;
//                           return NotesListView(
//                             notes: allNotes,
//                             onDeleteNote: (note) async {
//                               await _notesService.deleteNote(id: note.id);
//                             },
//                             onTap: (note) async {
//                               Navigator.of(context).pushNamed(
//                                 createOrUpdateNoteRoute,
//                                 arguments: note,
//                               );
//                             },
//                           );
//                         } else {
//                           return const CircularProgressIndicator();
//                         }
//                       default:
//                         return const CircularProgressIndicator();
//                     }
//                   });
//             default:
//               return const CircularProgressIndicator();
//           }
//         },
//       )