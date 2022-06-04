import 'package:flutter/material.dart';

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

Future<bool> showDeleteNoteDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Remove note'),
          content: const Text('Are you sure you want to delete selected note?'),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No')),
          ],
        );
      }).then((value) => value ?? false);
}
