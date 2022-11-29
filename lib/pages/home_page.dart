import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';
import '../util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();
  List dbFinal = [];
  double _sum = 0.0;

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_myBox.get("TODOLIST-1") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }
    atualizaDbFinal();

    super.initState();
  }

  void atualizaDbFinal() {
    dbFinal.clear();
    for (var element in db.toDoList) {
      if (element[3] == false) {
        dbFinal.add(element);
      }
    }

    dbFinal.forEach((element) {
      _sum += element.first;
    });
  }

  // text controller

  // checkbox was tapped
  void payTask(int index) {
    setState(() {
      db.toDoList[index][3] = true;
    });
    db.updateDataBase();
    atualizaDbFinal();
  }

  // delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
    atualizaDbFinal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          elevation: 0,
        ),
        body: Column(
          children: [
            Text("Total: R\$ " + _sum.toString()),
            SizedBox(
              height: 500,
              width: 400,
              child: ListView.builder(
                itemCount: dbFinal.length,
                itemBuilder: (context, index) {
                  return ToDoTile(
                    taskValor: dbFinal[index][0],
                    taskDesc: dbFinal[index][1],
                    taskDate: dbFinal[index][2],
                    taskCompleted: dbFinal[index][3],
                    taskCategoria: dbFinal[index][4],
                    taskMetodo: dbFinal[index][5],
                    payTask: (context) => payTask(index),
                    deleteFunction: (context) => deleteTask(index),
                  );
                },
              ),
            )
          ],
        ));
  }
}
