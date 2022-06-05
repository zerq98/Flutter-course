import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learning_dart/services/cloudStorage/cloudNote.dart';
import 'package:learning_dart/services/cloudStorage/cloudStorageConstants.dart';
import 'package:learning_dart/services/cloudStorage/cloudStorageExceptions.dart';

class FirebaseCloudService {
  final notes = FirebaseFirestore.instance.collection('note');

  static final FirebaseCloudService _shared =
      FirebaseCloudService._sharedInstance();
  FirebaseCloudService._sharedInstance() {}
  factory FirebaseCloudService() => _shared;

  void createNewNote({required String ownerUserId}) async {
    notes.add({ownerUserIdFieldName: ownerUserId, textFieldName: ''});
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then((value) => value.docs.map(
                (doc) {
                  return CloudNote(
                      documentId: doc.id,
                      ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                      text: doc.data()[textFieldName] as String);
                },
              ));
    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  }

  Future<void> updateNote(
      {required String documentId, required String text}) async {
    try {
      notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      notes.doc(documentId).delete();
    } catch (e) {
      CouldNotDeleteNoteException();
    }
  }
}
