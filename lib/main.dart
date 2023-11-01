// ignore_for_file: non_constant_identifier_names, avoid_print
import 'package:drift/drift.dart' as dr;
import 'package:driftinsert/Controller/database_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'databsase/database.dart';

final database = AppDatabase();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(database_controller());
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: _MyHomePageState(),
    );
  }

}


class _MyHomePageState extends StatelessWidget {

  final datacontroller = Get.put(database_controller());
  List<TodoItem>? allDataRecords;

  TextEditingController title_controller =TextEditingController();
  TextEditingController content_controller =TextEditingController();

  TextEditingController title_update_controller =TextEditingController();
  TextEditingController content_update_controller =TextEditingController();

  insertData(String titles,String contents)
  async {
    await database.into(database.todoItems).insert(TodoItemsCompanion.insert(
      title: titles,
      content: contents,
    ));
  }

  display_records()
  async {
    allDataRecords = await database.select(database.todoItems).get();
  }

  delete_data(int id)
  async {
    database.deleteRecord(id).then((value) => null);
    allDataRecords = await database.select(database.todoItems).get();
    datacontroller.onInit();
  }

  update_data(int id, String title, String content)
  async {
    database.updateRecord(TodoItemsCompanion(id: dr.Value(id), title: dr.Value(title),
            content: dr.Value(content))).then((value) => null);
    allDataRecords = await database.select(database.todoItems).get();
    datacontroller.onInit();
  }

  @override
  Widget build(BuildContext context)
  {
    return GetBuilder(
        init:datacontroller ,
        builder: (datacontroller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Drift Data'),
            ),
            body: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: datacontroller.allItems?.length??0,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),// BoxShape.circle or BoxShape.retangle
                          boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5.0,),]),
                        child: InkWell(
                          onTap: () {
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(datacontroller.allItems![index].title,
                                      style: const TextStyle(color: Colors.black)),
                                  IconButton(onPressed: () {
                                    delete_data(datacontroller.allItems![index].id);
                                  }, icon: const Icon(Icons.delete)),
                                  IconButton(onPressed: () {
                                    title_update_controller.text=datacontroller.allItems![index].title;
                                    content_update_controller.text=datacontroller.allItems![index].content;
                                    showGeneralDialog(
                                      context: context,
                                      barrierLabel: "showGeneralDialog",
                                      barrierDismissible: true,
                                      transitionDuration: const Duration(milliseconds: 400),
                                      pageBuilder: (context, animation, secondaryAnimation) {
                                        return Dialog(
                                          backgroundColor: Colors.white,
                                          elevation: 0,
                                          child: Container(
                                            height: 150,
                                            margin: const EdgeInsets.all(20),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                    controller: title_update_controller,
                                                    decoration: InputDecoration(border: InputBorder.none, fillColor: Colors.grey,
                                                        hintText: datacontroller.allItems![index].title)),
                                                TextFormField(
                                                    controller: content_update_controller,
                                                    decoration: InputDecoration(border: InputBorder.none, fillColor: Colors.grey,
                                                        hintText: datacontroller.allItems![index].content)),
                                                TextButton(onPressed: () {
                                                  update_data(datacontroller.allItems![index].id,
                                                      title_update_controller.text,
                                                      content_update_controller.text);
                                                  title_update_controller.clear();
                                                  content_update_controller.clear();
                                                  Navigator.pop(context);
                                                }, child: const Text('Update'))
                                              ],
                                            ),
                                          ),
                                        );
                                      },);

                                  }, icon: const Icon(Icons.edit))
                                ],
                              ),
                              Text(datacontroller.allItems![index].content, style: const TextStyle(color: Colors.black)),
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
                  child: Container(
                    height: 150,
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(controller: title_controller,
                            decoration: const InputDecoration(border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: 'Title')),
                        TextField(controller: content_controller,
                            decoration: const InputDecoration(border: InputBorder.none,
                                fillColor: Colors.grey,
                                hintText: 'Content')),
                        TextButton(onPressed: () {
                            insertData(title_controller.text, content_controller.text);
                            datacontroller.onInit();
                            title_controller.clear();
                            content_controller.clear();
                            Navigator.pop(context);
                        }, child: const Text('Insert'))
                      ],
                    ),
                  ),
                );
              },);
          }, child: const Icon(Icons.add,)),
          );
      });
  }
}