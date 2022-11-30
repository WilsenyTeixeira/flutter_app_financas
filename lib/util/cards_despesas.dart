import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Cards_Despesas extends StatelessWidget {
  final double despesaValor;
  final String despesaDesc;
  final String despesaDate;
  final bool despesaEmAberto;
  final String despesaCategoria;
  final String despesaMetodo;
  Function(BuildContext)? payDespesa;
  Function(BuildContext)? deleteFunction;

  Cards_Despesas({
    super.key,
    required this.despesaValor,
    required this.despesaDesc,
    required this.despesaDate,
    required this.despesaEmAberto,
    required this.despesaCategoria,
    required this.despesaMetodo,
    required this.payDespesa,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            if (!despesaEmAberto)
              SlidableAction(
                onPressed: payDespesa,
                icon: Icons.done,
                backgroundColor: colors.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: colors.onErrorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 300,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          despesaDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          despesaValor.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: despesaEmAberto
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 50,
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 40,
                            child: Icon(Icons.done),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              despesaDesc,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Container(
                    width: 300,
                    height: 50,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chip(
                            labelStyle: const TextStyle(fontSize: 12),
                            label: Text(despesaCategoria),
                            backgroundColor: colors.surface,
                          ),
                          if (despesaMetodo == "Cartão")
                            Chip(
                              labelStyle: const TextStyle(fontSize: 12),
                              label: const Text("Cartão"),
                              backgroundColor: colors.surface,
                            )
                          else
                            Chip(
                              labelStyle: const TextStyle(fontSize: 12),
                              label: const Text("Dinheiro"),
                              backgroundColor: colors.surface,
                            ),
                          if (despesaEmAberto == true)
                            Chip(
                              labelStyle: const TextStyle(fontSize: 12),
                              label: const Text("Pago"),
                              backgroundColor: colors.surface,
                            )
                          else
                            Chip(
                              labelStyle: const TextStyle(fontSize: 12),
                              label: const Text("Em Aberto"),
                              backgroundColor: colors.surface,
                            )
                        ]),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
