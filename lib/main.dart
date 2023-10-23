// ignore_for_file: non_constant_identifier_names, avoid_print
import 'package:drift/drift.dart' as dr;
import 'package:driftinsert/AddNote_Controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'database.dart';

List<TodoItem>? allItems;
final database = AppDatabase();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AddNote_Controller());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      title: 'Drift Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white10),
        useMaterial3: true,
      ),
      home: _MyHomePageState(),
    );
  }

}


class _MyHomePageState extends StatelessWidget {
  final dashboard_controller = Get.put(AddNote_Controller());

  TextEditingController title_controller =TextEditingController();
  TextEditingController content_controller =TextEditingController();
  TextEditingController title_controller2 =TextEditingController();
  TextEditingController content_controller2 =TextEditingController();

  initdatabase(String titles,String contents)
  async {
    await database.into(database.todoItems).insert(TodoItemsCompanion.insert(
      title: titles,
      content: contents,
    ));
  }

  display_database()
  async {
    allItems = await database.select(database.todoItems).get();
  }

  delete_data(int id)
  async {
    database.deleteEmployee(id).then((value) => null);
    allItems = await database.select(database.todoItems).get();
    dashboard_controller.onInit();
  }

  update_data(int id, String title, String content)
  async {
    database.updateEmployee(
        TodoItemsCompanion(id: dr.Value(id),
            title: dr.Value(title),
            content: dr.Value(content))).then((value) => null);
    allItems = await database.select(database.todoItems).get();
    dashboard_controller.onInit();
  }

  @override
  Widget build(BuildContext context)
  {
    return GetBuilder(
        init:dashboard_controller ,
        builder: (dashboard_controller) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text('Drift Data'),
            ),
            body: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: dashboard_controller.allItems?.length??0,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          onTap: () {
                            showGeneralDialog(
                              context: context,
                              barrierLabel: "showGeneralDialog",
                              barrierDismissible: true,
                              transitionDuration: const Duration(milliseconds: 400),
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  child: Container
                                    (
                                    height: 150,
                                    margin: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        TextField(
                                            controller: title_controller2,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                fillColor: Colors.grey,
                                                hintText: dashboard_controller.allItems![index].title)),
                                        TextField(
                                        controller: content_controller2,
                                        decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.grey,
                                        hintText: dashboard_controller.allItems![index].content)),
                                      TextButton(onPressed: () {
                                          update_data(dashboard_controller.allItems![index].id,
                                          title_controller2.text,
                                          content_controller2.text);
                                          title_controller2.clear();
                                          content_controller2.clear();
                                          Navigator.pop(context);
                                        }, child: const Text('Update'))
                                      ],
                                    ),
                                  ),
                                );
                              },);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(dashboard_controller.allItems![index].title,
                                      style: const TextStyle(color: Colors.black)),
                                  IconButton(onPressed: () {
                                    delete_data(dashboard_controller.allItems![index].id);
                                  }, icon: const Icon(Icons.delete))
                                ],
                              ),
                              Text(dashboard_controller.allItems![index].content, style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                      );
                    },),
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(onPressed: () {
            showGeneralDialog(
              context: context,
              barrierLabel: "showGeneralDialog",
              barrierDismissible: true,
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) {
                return Dialog(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  child: Container
                    (
                    height: 150,
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(controller: title_controller,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: 'Title')),
                        TextField(controller: content_controller,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: 'Content')),
                        TextButton(onPressed: () {
                          initdatabase(title_controller.text, content_controller.text);
                          dashboard_controller.onInit();
                          title_controller.clear();
                          content_controller.clear();
                          Navigator.pop(context);
                        }, child: const Text('Insert'))
                      ],
                    ),
                  ),
                );
              },);
          }, child: const Icon(Icons.add)),
          );
      });
  }
}