// ignore_for_file: non_constant_identifier_names, avoid_print
import 'package:driftinsert/Controller/database_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(datacontroller.allItems![index].title,style: const TextStyle(color: Colors.black)),
                                Text(datacontroller.allItems![index].content, style: const TextStyle(color: Colors.black)),
                              ],
                            ),
                            Row(
                              children: [
                                 IconButton(onPressed: () {
                                  datacontroller.title_update_controller.text=datacontroller.allItems![index].title;
                                  datacontroller.content_update_controller.text=datacontroller.allItems![index].content;
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
                                                  controller: datacontroller.title_update_controller,
                                                  decoration: InputDecoration(border: InputBorder.none, fillColor: Colors.grey,
                                                  hintText: datacontroller.allItems![index].title)),
                                              TextFormField(
                                                  controller:datacontroller.content_update_controller,
                                                  decoration: InputDecoration(border: InputBorder.none, fillColor: Colors.grey,
                                                  hintText: datacontroller.allItems![index].content)),
                                              TextButton(onPressed: () {
                                                  datacontroller.update_data(datacontroller.allItems![index].id,datacontroller.title_update_controller.text,
                                                  datacontroller.content_update_controller.text);
                                                  datacontroller.title_update_controller.clear();
                                                  datacontroller.content_update_controller.clear();
                                                  Navigator.pop(context);
                                              }, child: const Text('Update'))
                                            ],
                                          ),
                                        ),
                                      );
                                    },);
                                },icon: const Icon(Icons.edit)),
                              IconButton(onPressed: () {
                              datacontroller.delete_data(datacontroller.allItems![index].id);
                              },icon: const Icon(Icons.delete)),
                           ],
                        )
                      ],
                    ),
                  );
                },),
            )
          ],
        ),floatingActionButton: FloatingActionButton(onPressed: () {
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
                      TextField(controller:datacontroller. title_controller,
                          decoration: const InputDecoration(border: InputBorder.none,
                          fillColor: Colors.grey,
                          hintText: 'Title')),
                      TextField(controller: datacontroller.content_controller,
                          decoration: const InputDecoration(border: InputBorder.none,
                          fillColor: Colors.grey,
                          hintText: 'Content')),
                      TextButton(onPressed: () {
                          datacontroller.insertData(datacontroller.title_controller.text, datacontroller.content_controller.text);
                          datacontroller.onInit();
                          datacontroller.title_controller.clear();
                          datacontroller.content_controller.clear();
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