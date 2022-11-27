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
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

  ToDoTile({
    super.key,
    required this.taskValor,
    required this.taskDesc,
    required this.taskDate,
    required this.taskCompleted,
    required this.taskCategoria,
    required this.taskMetodo,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            )
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
              // checkbox
              SizedBox(
                width: 30,
                height: 30,
                child: Checkbox(
                  value: taskCompleted,
                  onChanged: onChanged,
                  activeColor: Colors.black,
                ),
              ),
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
                            decoration: taskCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
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
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            taskCategoria,
                            style: TextStyle(
                              decoration: taskCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          if (taskMetodo == "Cartão")
                            const Icon(Icons.credit_card_rounded)
                          else
                            const Icon(Icons.money_rounded)
                        ]),
                  ),
                  Container(
                    width: 300,
                    height: 50,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            taskDesc,
                            style: TextStyle(
                              decoration: taskCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          Text(
                            taskMetodo,
                            style: TextStyle(
                              decoration: taskCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
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
