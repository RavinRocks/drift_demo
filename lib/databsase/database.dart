import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
part 'database.g.dart';

class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 32)();
  TextColumn get content => text().named('body')();
  IntColumn get category => integer().nullable()();
}

@DriftDatabase(tables: [TodoItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> deleteRecord(int id) async {
    return (delete(todoItems)..where((tbl) => tbl.id.equals(id))).go();
  }
  Future<bool> updateRecord(TodoItemsCompanion imd) async {
    return await update(todoItems).replace(imd);
  }
  Future<int> insertRecord(TodoItemsCompanion imd) async {
    return await into(todoItems).insert(imd);
  }
  Future<List<TodoItem>> getAllRecords() async {
    return await select(todoItems).get();
  }
  Future<int> deleteAllRecords() async {
    return await delete(todoItems).go();
  }
}
  LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
}