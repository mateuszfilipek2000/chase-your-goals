import 'package:flutter/material.dart';

class StopwatchButton extends StatelessWidget {
  const StopwatchButton({
    Key? key,
    required this.onDecrement,
    required this.onIncrement,
    required this.value,
  }) : super(key: key);

  final Function() onIncrement;
  final Function() onDecrement;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: onIncrement,
          iconSize: 40.0,
        ),
        Text(value, style: Theme.of(context).textTheme.headline4),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: onDecrement,
          iconSize: 40.0,
        ),
      ],
    );
  }
}
