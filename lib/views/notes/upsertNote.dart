import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:learning_dart/services/auth/authService.dart';
import 'package:learning_dart/services/crud/notesService.dart';
import 'package:learning_dart/utilities/generics/getArguments.dart';

class UpsertNoteView extends StatefulWidget {
  const UpsertNoteView({Key? key}) : super(key: key);

  @override
  State<UpsertNoteView> createState() => _UpsertNoteViewState();
}

class _UpsertNoteViewState extends State<UpsertNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  Future<DatabaseNote> createOrGetNote(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await _notesService.getUser(email: email);

    final newNote = await _notesService.createNote(owner: owner);
    _note = newNote;
    return newNote;
  }

  Future<void> _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      await _notesService.deleteNote(id: note.id);
    }
  }

  Future<void> _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    if (!_textController.text.isEmpty && note != null) {
      await _notesService.updateNote(note: note, text: _textController.text);
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }

    final text = _textController.text;
    await _notesService.updateNote(note: note, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextIsNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Note details')),
      body: FutureBuilder(
        future: createOrGetNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote;
              _setupTextControllerListener();
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  expands: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Start typing your note...',
                    filled: true,
                    fillColor: Colors.orange[200],
                  ),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
