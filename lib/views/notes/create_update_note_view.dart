import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:mynotes/util/generics/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  //DatabaseNote? _note;
  CloudNote? _note;
  //late final NotesService _notesService;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    //_notesService = NotesService();
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    //await _notesService.updateNotes(note: note, text: text);
    await _notesService.updateNote(documentId: note.documentId, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener((_textControllerListener));
    _textController.addListener((_textControllerListener));
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    
    final widgetNote = context.getArgument<CloudNote>();

    if(widgetNote != null){
      _note = widgetNote;
      _textController.text = widgetNote.text.toString();
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser;
    //final email = currentUser!.email!;
    //final owner = await _notesService.getUser(email: email);
    final newNote =  await _notesService.createNewNote(ownerUserId:currentUser!.id);
    _note = newNote;
    return newNote;
  }

  void deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      //_notesService.deleteNote(id: note.id);
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text.toString();
    if (note != null && text.isNotEmpty) {
      //await _notesService.updateNotes(note: note, text: text);
      await _notesService.updateNote(documentId: note.documentId, text: text);
    }
  }

  @override
  void dispose() {
    deleteNoteIfTextIsEmpty();
    saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("New Note"),
        ),
        body: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                  _setupTextControllerListener();
                  return TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Start typing your note...',
                    ),
                  );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
