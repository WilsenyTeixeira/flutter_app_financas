import 'package:hive_flutter/hive_flutter.dart';

class DespesasDataBase {
  List despesasList = [];

  final _myBox = Hive.box('mybox');

  void createInitialData() {
    despesasList = [
      [120.0, "wilseny", "Nov 14, 2022", false, "Alimentacao", "Cartão"],
    ];
  }

  void loadData() {
    despesasList = _myBox.get("DB_DESPESAS");
  }

  void updateDataBase() {
    _myBox.put("DB_DESPESAS", despesasList);
  }
}
