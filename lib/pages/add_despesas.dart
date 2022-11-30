import 'package:app_financa/main.dart';
import 'package:flutter/material.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';

class Selected {
  String name;
  bool isSelect;
  Selected({required this.name, required this.isSelect});
}

class AddDespesas extends StatefulWidget {
  const AddDespesas({super.key});

  @override
  State<AddDespesas> createState() => _AddDespesasState();
}

class _AddDespesasState extends State<AddDespesas> {
  final _myBox = Hive.box('mybox');
  DespesasDataBase db = DespesasDataBase();

  String categoria = '';
  String metodo = 'Dinheiro';

  bool selectedMoney = true;
  bool selectedCard = false;

  List<Selected> selecteds = [
    Selected(name: "selectedAlimentacao", isSelect: false),
    Selected(name: "selectedLazer", isSelect: false),
    Selected(name: "selectedTransporte", isSelect: false),
    Selected(name: "selectedPet", isSelect: false),
    Selected(name: "selectedFilhos", isSelect: false),
    Selected(name: "selectedImpostos", isSelect: false),
    Selected(name: "selectedCasa", isSelect: false),
    Selected(name: "selectedEducacao", isSelect: false),
    Selected(name: "selectedSaude", isSelect: false),
    Selected(name: "selectedOutros", isSelect: false),
  ];

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    // if this is the 1st time ever openin the app, then create default data
    if (_myBox.get("DB_DESPESAS") == null) {
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

  void saveNewDespesa() {
    setState(() {
      db.despesasList.add([
        double.parse(_controllerValor.text
            .substring(0, _controllerValor.text.length - 7)
            .replaceAll(",", ".")
            .replaceAll(" ", "")),
        _controllerDesc.text,
        _controllerDate.text,
        false,
        categoria,
        metodo,
      ]);
      _controllerValor.clear();
      _controllerDesc.clear();
      _controllerDate.clear();
      categoria = '';
      metodo = '';
    });
    db.updateDataBase();
  }

  void selectMoney() {
    setState(() {
      selectedMoney = true;
      selectedCard = false;
      metodo = 'Dinheiro';
    });
  }

  void selectCard() {
    setState(() {
      selectedMoney = false;
      selectedCard = true;
      metodo = 'Cartão';
    });
  }

  void selectChip(categoriaChip, selectedChipIndex) {
    setState(() {
      categoria = categoriaChip;
      for (var element in selecteds) {
        if (element.isSelect == true) {
          element.isSelect = false;
        }
      }
      selecteds[selectedChipIndex].isSelect =
          !selecteds[selectedChipIndex].isSelect;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
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
                  cursorColor: colors.onSurfaceVariant,
                  inputFormatters: [
                    CurrencyTextInputFormatter(locale: 'br', symbol: 'BR (\$)')
                  ],
                  decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money),
                    labelText: 'Valor da Despesa',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 66, 73, 64),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 66, 73, 64)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _controllerDesc,
                  keyboardType: TextInputType.text,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.description),
                    labelText: 'Descricao',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(255, 66, 73, 64),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 66, 73, 64)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: 300,
                child: TextField(
                    focusNode: AlwaysDisabledFocusNode(),
                    controller: _controllerDate,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.date_range),
                      labelText: 'Vencimento',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 66, 73, 64),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 66, 73, 64)),
                      ),
                    ),
                    onTap: () {
                      _selectDate(context);
                    }),
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 100,
                width: 300,
                child: Column(children: [
                  const Text("Método de Pagamento:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 66, 73, 64))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (selectedCard == true && selectedMoney == false)
                        SizedBox(
                            child: Column(
                          children: [
                            IconButton(
                              isSelected: selectedCard,
                              icon: const Icon(Icons.credit_card_off_rounded),
                              selectedIcon:
                                  const Icon(Icons.credit_card_rounded),
                              tooltip: 'Cartão de Crédito',
                              onPressed: selectCard,
                              style: IconButton.styleFrom(
                                foregroundColor: colors.onPrimary,
                                backgroundColor: colors.primary,
                                disabledBackgroundColor:
                                    colors.onSurface.withOpacity(0.12),
                                hoverColor: colors.onPrimary.withOpacity(0.08),
                                focusColor: colors.onPrimary.withOpacity(0.12),
                                highlightColor:
                                    colors.onPrimary.withOpacity(0.12),
                              ),
                            ),
                            const Text("Cartão"),
                          ],
                        )),
                      if (selectedCard == true && selectedMoney == false)
                        SizedBox(
                          child: Column(
                            children: [
                              IconButton(
                                isSelected: selectedMoney,
                                icon: const Icon(Icons.money_off),
                                selectedIcon: const Icon(Icons.money_rounded),
                                tooltip: 'Dinheiro',
                                onPressed: selectMoney,
                              ),
                              const Text("Dinheiro"),
                            ],
                          ),
                        ),
                      if (selectedMoney == true && selectedCard == false)
                        SizedBox(
                            child: Column(children: [
                          IconButton(
                            isSelected: selectedCard,
                            icon: const Icon(Icons.credit_card_off_rounded),
                            selectedIcon: const Icon(Icons.credit_card_rounded),
                            tooltip: 'Cartão de Crédito',
                            onPressed: selectCard,
                          ),
                          const Text("Cartão"),
                        ])),
                      if (selectedMoney == true && selectedCard == false)
                        SizedBox(
                            child: Column(children: [
                          IconButton(
                            isSelected: selectedMoney,
                            icon: const Icon(Icons.money_off),
                            selectedIcon: const Icon(Icons.money_rounded),
                            tooltip: 'Dinheiro',
                            onPressed: selectMoney,
                            style: IconButton.styleFrom(
                              foregroundColor: colors.onPrimary,
                              backgroundColor: colors.primary,
                              disabledBackgroundColor:
                                  colors.onSurface.withOpacity(0.12),
                              hoverColor: colors.onPrimary.withOpacity(0.08),
                              focusColor: colors.onPrimary.withOpacity(0.12),
                              highlightColor:
                                  colors.onPrimary.withOpacity(0.12),
                            ),
                          ),
                          const Text("Dinheiro"),
                        ])),
                    ],
                  )
                ]),
              ),
              SizedBox(
                height: 210,
                width: 400,
                child: Column(children: [
                  const Text("Categoria:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 66, 73, 64))),
                  Column(
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ChoiceChip(
                              selected: selecteds[0].isSelect,
                              selectedColor: colors.primary,
                              label: const Text('Alimentação'),
                              onSelected: (bool selected) {
                                selectChip('Alimentação', 0);
                              }),
                          ChoiceChip(
                              selected: selecteds[1].isSelect,
                              selectedColor: colors.primary,
                              label: const Text('Lazer'),
                              onSelected: (bool selected) {
                                selectChip('Lazer', 1);
                              }),
                          ChoiceChip(
                              selected: selecteds[2].isSelect,
                              selectedColor: colors.primary,
                              label: const Text('Transporte'),
                              onSelected: (bool selected) {
                                selectChip('Transporte', 2);
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ChoiceChip(
                              selected: selecteds[3].isSelect,
                              selectedColor: colors.primary,
                              label: const Text('Pet'),
                              onSelected: (bool selected) {
                                selectChip('Pet', 3);
                              }),
                          ChoiceChip(
                              selected: selecteds[4].isSelect,
                              selectedColor: colors.primary,
                              label: const Text('Filhos'),
                              onSelected: (bool selected) {
                                selectChip('Filhos', 4);
                              }),
                          ChoiceChip(
                              selected: selecteds[8].isSelect,
                              selectedColor: colors.primary,
                              label: const Text('Saúde'),
                              onSelected: (bool selected) {
                                selectChip('Saúde', 8);
                              }),
                          ChoiceChip(
                              selected: selecteds[6].isSelect,
                              selectedColor: colors.primary,
                              label: const Text('Casa'),
                              onSelected: (bool selected) {
                                selectChip('Casa', 6);
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ChoiceChip(
                              selected: selecteds[7].isSelect,
                              selectedColor: colors.primary,
                              label: const Text('Educação'),
                              onSelected: (bool selected) {
                                selectChip('Educação', 7);
                              }),
                          ChoiceChip(
                              selected: selecteds[5].isSelect,
                              selectedColor: colors.primary,
                              label: const Text('Impostos'),
                              onSelected: (bool selected) {
                                selectChip('Impostos', 5);
                              }),
                          ChoiceChip(
                              selected: selecteds[9].isSelect,
                              selectedColor: colors.primary,
                              label: const Text('Outros'),
                              onSelected: (bool selected) {
                                selectChip('Alimentação', 9);
                              }),
                        ],
                      ),
                    ],
                  )
                ]),
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    saveNewDespesa();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Despesa Salva')));
                  },
                  icon: const Icon(Icons.done),
                  label: const Text("Confirmar")),
            ],
          ),
        ));
  }

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData(
                colorSchemeSeed: const Color.fromARGB(255, 0, 110, 27),
                useMaterial3: true),
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
