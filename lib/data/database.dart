import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = [];

  // reference our box
  final _myBox = Hive.box('mybox');

  // run this method if this is the 1st time ever opening this app
  void createInitialData() {
    toDoList = [
      [120.0, "wilseny", "2000-11-11", false, "Alimentacao", "Cartão"],
    ];
  }

  // load the data from database
  void loadData() {
    toDoList = _myBox.get("TODOLIST-1");
  }

  // update the database
  void updateDataBase() {
    _myBox.put("TODOLIST-1", toDoList);
  }
}
