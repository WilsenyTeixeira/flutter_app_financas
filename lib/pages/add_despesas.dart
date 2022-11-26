import 'package:app_financa/main.dart';
import 'package:app_financa/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';

class AddDespesas extends StatefulWidget {
  @override
  State<AddDespesas> createState() => _AddDespesasState();
}

class _AddDespesasState extends State<AddDespesas> {
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  DateTime _selectedDate = DateTime.now();
  String _formattedDate = '';
/*
  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022, 1),
      lastDate: DateTime(2030, 1),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      String newFormattedDate = DateFormat('yyyy-MM-dd').format(newDate);
      setState(() {
        _date = newDate;
        _formattedDate = newFormattedDate;
      });
    }
  }*/

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }

    super.initState();
  }

  final _controllerValor = TextEditingController();
  final _controllerDesc = TextEditingController();
  final _controllerDate = TextEditingController();

  void saveNewTask() {
    setState(() {
      db.toDoList.add([
        _controllerValor.text,
        _controllerDesc.text,
        _controllerDate.text,
        false
      ]);
      _controllerValor.clear();
      _controllerDesc.clear();
      _controllerDate.clear();
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Adicionar Despesa"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                    );
                  });
            },
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _controllerValor,
                  keyboardType: TextInputType.number,
                  cursorColor: Theme.of(context).primaryColor,
                  inputFormatters: [
                    CurrencyTextInputFormatter(locale: 'br', symbol: 'BR (\$)')
                  ],
                  decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money),
                    labelText: 'Valor da Despesa',
                    labelStyle: TextStyle(
                      color: Color(0xFF6200EE),
                    ),
                    suffixIcon: Icon(
                      Icons.check_circle,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6200EE)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _controllerDesc,
                  keyboardType: TextInputType.text,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money),
                    labelText: 'Descricao',
                    labelStyle: TextStyle(
                      color: Color(0xFF6200EE),
                    ),
                    suffixIcon: Icon(
                      Icons.check_circle,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6200EE)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                  focusNode: AlwaysDisabledFocusNode(),
                  controller: _controllerDate,
                  onTap: () {
                    _selectDate(context);
                  }),
              /*
              ElevatedButton(
                onPressed: _selectDate,
                child: const Text('Selecionar Vencimento'),
              ),
              Text(
                'Selected date: $_formattedDate',
              ),*/
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: saveNewTask,
          child: const Text("Salvar"),
        ));
  }

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child!,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _controllerDate
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _controllerDate.text.length,
            affinity: TextAffinity.upstream));
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
