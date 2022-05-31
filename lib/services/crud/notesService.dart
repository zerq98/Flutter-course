import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'crudExceptions.dart';

class NotesService {
  Database? _db;

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db
        .delete(userTable, where: 'email=?', whereArgs: [email.toLowerCase()]);
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);

    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }

    final userId =
        await db.insert(userTable, {emailColumn: email.toLowerCase()});

    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(userTable,
        limit: 1, where: 'email=?', whereArgs: [email.toLowerCase()]);

    if (results.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);

    if (dbUser != owner) {
      throw CouldNotFindUserException();
    } else {
      final noteId = await db.insert(noteTable,
          {userIdColumn: owner.id, textColumn: '', isSyncedWithCloudColumn: 1});

      return DatabaseNote(
          id: noteId, userId: owner.id, text: '', isSyncedWithCloud: true);
    }
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount =
        await db.delete(noteTable, where: 'id=?', whereArgs: [id]);
    if (deletedCount != 1) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<List<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(noteTable);
    return results.map((n) => DatabaseNote.fromRow(n)).toList();
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    final db = _getDatabaseOrThrow();
    final dbNote = await getNote(id: note.id);
    final updateCount = await db.update(
        noteTable, {textColumn: text, isSyncedWithCloudColumn: 0},
        where: 'id=?', whereArgs: [note.id]);
    if (updateCount == 0) {
      throw CouldNotFindNoteException();
    } else {
      return await getNote(id: note.id);
    }
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final results =
        await db.query(noteTable, limit: 1, where: 'id=?', whereArgs: [id]);

    if (results.isEmpty) {
      throw CouldNotFindNoteException();
    } else {
      return DatabaseNote.fromRow(results.first);
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) throw DatabaseIsNotOpenException();

    try {
      final docsPath = await getApplicationDocumentsDirectory();

      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException catch (e) {
      throw UnableToGetDocumentsDirectoryException();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final String text;
  final bool isSyncedWithCloud;
  final int userId;
  const DatabaseNote(
      {required this.id,
      required this.text,
      required this.userId,
      required this.isSyncedWithCloud});

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        text = map[textColumn] as String,
        userId = map[userIdColumn] as int,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID = $id, userId = $userId, text = $text, isSyncedWithCloud = $isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const textColumn = 'text';
const userIdColumn = 'userId';
const isSyncedWithCloudColumn = 'isSyncedWithCloud';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
        "id" INTEGER NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        PRIMARY KEY("id" AUTOINCREMENT));''';
const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note" (
        "id" INTEGER NOT NULL,
        "userId" INTEGER NOT NULL,
        "text" TEXT,
        "isSyncedWithCloud" INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("userId") REFERENCES "user"("id"),
        PRIMARY KEY("id" AUTOINCREMENT)
      );''';
