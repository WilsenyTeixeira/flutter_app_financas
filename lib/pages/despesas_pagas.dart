import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app_financa/util/cards_despesas.dart';
import '../data/database.dart';

class DespesasPagas extends StatefulWidget {
  const DespesasPagas({super.key});

  @override
  State<DespesasPagas> createState() => _DespesasPagasState();
}

class _DespesasPagasState extends State<DespesasPagas> {
  final _myBox = Hive.box('mybox');
  DespesasDataBase db = DespesasDataBase();
  List dbFinal = [];
  double _sum = 0.0;

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_myBox.get("DB_DESPESAS") == null) {
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
    for (var element in db.despesasList) {
      if (element[3] == true) {
        dbFinal.add(element);
      }
    }

    dbFinal.forEach((element) {
      _sum += element.first;
    });
  }

  // text controller

  // checkbox was tapped
  void payDespesa(int index) {
    setState(() {
      db.despesasList[index][3] = false;
    });
    db.updateDataBase();
    atualizaDbFinal();
  }

  // delete task
  void deleteDespesa(int index) {
    setState(() {
      db.despesasList.removeAt(index);
    });
    db.updateDataBase();
    atualizaDbFinal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Despesas Pagas'),
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
                  return Cards_Despesas(
                    despesaValor: dbFinal[index][0],
                    despesaDesc: dbFinal[index][1],
                    despesaDate: dbFinal[index][2],
                    despesaEmAberto: dbFinal[index][3],
                    despesaCategoria: dbFinal[index][4],
                    despesaMetodo: dbFinal[index][5],
                    payDespesa: (context) => payDespesa(index),
                    deleteFunction: (context) => deleteDespesa(index),
                  );
                },
              ),
            )
          ],
        ));
  }
}
