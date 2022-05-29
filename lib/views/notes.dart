import 'package:flutter/material.dart';
import 'package:learning_dart/constants/routes.dart';
import 'package:learning_dart/enums/menuActionEnum.dart';
import 'package:learning_dart/services/auth/authService.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       DrawerHeader(child: Text('')),
      //       ListTile(
      //         title: const Text('Item 1'),
      //         onTap: () {},
      //       ),
      //       ListTile(
      //         title: const Text('Sign out'),
      //         onTap: () {
      //           FirebaseAuth.instance.signOut();
      //           Navigator.of(context)
      //               .pushNamedAndRemoveUntil('/login/', (route) => false);
      //         },
      //       ),
      //     ],
      //   ),
      // ),
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
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(value: MenuAction.logout, child: Text('Logout')),
              ];
            },
          )
        ],
      ),
      body: Text('Notes'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Log out')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
          ],
        );
      }).then((value) => value ?? false);
}
