// ignore_for_file: camel_case_types
import 'package:get/get.dart';
import '../databsase/database.dart';
import '../main.dart';

class AddNote_Controller extends GetxController
{
  List<TodoItem>? allItems=<TodoItem>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    allItems = await database.select(database.todoItems).get();
    update();
  }
}