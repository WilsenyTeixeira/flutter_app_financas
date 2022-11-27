import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ToDoTile extends StatelessWidget {
  final String taskValor;
  final String taskDesc;
  final String taskDate;
  final bool taskCompleted;
  final String taskCategoria;
  final String taskMetodo;
  Function(BuildContext)? payTask;
  Function(BuildContext)? deleteFunction;

  ToDoTile({
    super.key,
    required this.taskValor,
    required this.taskDesc,
    required this.taskDate,
    required this.taskCompleted,
    required this.taskCategoria,
    required this.taskMetodo,
    required this.payTask,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        startActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: payTask,
              icon: Icons.done,
              backgroundColor: colors.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: StretchMotion(),
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
          padding: EdgeInsets.all(15),
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
                          taskDate,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          taskValor,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: taskCompleted
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
                          SizedBox(
                            width: 40,
                            child: Icon(Icons.done),
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              taskDesc,
                              style: TextStyle(
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
                            labelStyle: TextStyle(fontSize: 12),
                            label: Text('$taskCategoria'),
                          ),
                          if (taskMetodo == "Cartão")
                            const Chip(
                              labelStyle: TextStyle(fontSize: 12),
                              label: Text("Cartão"),
                            )
                          else
                            const Chip(
                              labelStyle: TextStyle(fontSize: 12),
                              label: Text("Dinheiro"),
                            ),
                          if (taskCompleted == true)
                            const Chip(
                              labelStyle: TextStyle(fontSize: 12),
                              label: Text("Pago"),
                            )
                          else
                            const Chip(
                              labelStyle: TextStyle(fontSize: 12),
                              label: Text("Em Aberto"),
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
