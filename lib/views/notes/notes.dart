import 'package:flutter/material.dart';
import 'package:learning_dart/constants/routes.dart';
import 'package:learning_dart/enums/menuActionEnum.dart';
import 'package:learning_dart/services/auth/authService.dart';
import 'package:learning_dart/services/crud/notesService.dart';
import 'package:learning_dart/views/notes/notesList.dart';

import '../../utilities/informationDialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email;
  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(upsertNoteRoute);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: AppBar(
        title: Text('My notes'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
                case MenuAction.add:
                  Navigator.of(context).pushNamed(upsertNoteRoute);
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(value: MenuAction.add, child: Text('Add note')),
                PopupMenuItem(value: MenuAction.logout, child: Text('Logout')),
              ];
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return NotesListView(
                            notes: allNotes,
                            onTap: (note) {
                              Navigator.of(context)
                                  .pushNamed(upsertNoteRoute, arguments: note);
                            },
                            onDeleteNote: (note) async {
                              await _notesService.deleteNote(id: note.id);
                            });
                      } else {
                        return CircularProgressIndicator();
                      }
                    case ConnectionState.done:
                      return ListView.builder(
                        itemCount: (snapshot.data as List<DatabaseNote>).length,
                        itemBuilder: (context, index) {
                          return Text('Item');
                        },
                      );
                    default:
                      return CircularProgressIndicator();
                  }
                },
              );
            }

            return CircularProgressIndicator();
          }),
    );
  }
}
