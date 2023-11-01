// ignore_for_file: camel_case_types
import 'package:get/get.dart';
import '../databsase/database.dart';
import '../main.dart';
import 'package:drift/drift.dart' as dr;


class database_controller extends GetxController
{
  List<TodoItem>? allItems=<TodoItem>[].obs;
  List<TodoItem>? allDataRecords;
  final database = AppDatabase();

  @override
  Future<void> onInit() async {
    super.onInit();
    allItems = await database.select(database.todoItems).get();
    update();
  }

  delete_data(int id)
  async {
    database.deleteRecord(id).then((value) => null);
    allItems = await database.select(database.todoItems).get();
    update();
  }

  display_records()
  async {
    allItems = await database.select(database.todoItems).get();
  }

  insertData(String titles,String contents)
  async {
    await database.into(database.todoItems).insert(TodoItemsCompanion.insert(
      title: titles,
      content: contents,
    ));
  }

 update_data(int id, String title, String content)
  async {
    database.updateRecord(TodoItemsCompanion(id: dr.Value(id), title: dr.Value(title),
        content: dr.Value(content))).then((value) => null);
    allItems = await database.select(database.todoItems).get();
    update();
  }
}