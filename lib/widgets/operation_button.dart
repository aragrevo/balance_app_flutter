import 'package:balance_app/controllers/pocket.controller.dart';
import 'package:flutter/material.dart';

class OperationButton extends StatelessWidget {
  const OperationButton({
    Key? key,
    required this.onPressed,
    required this.operation,
  }) : super(key: key);

  final Operation operation;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isSum = operation == Operation.sum;
    return CircleAvatar(
      backgroundColor: isSum ? Colors.indigoAccent : Colors.orangeAccent,
      child: IconButton(
        icon: Icon(isSum ? Icons.add : Icons.remove),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}
