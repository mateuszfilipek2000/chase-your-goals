import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  const Section({
    Key? key,
    required this.child,
    this.isFirst = false,
    this.sectionTitle,
    this.width = double.infinity,
    this.fullWidth = false,
    this.fullHeight = false,
    this.isChart = false,
  }) : super(key: key);

  final bool isFirst;
  final Widget child;
  final String? sectionTitle;
  final double? width;
  final bool fullWidth;
  final bool fullHeight;
  final bool isChart;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isFirst
          ? const EdgeInsets.symmetric(vertical: 15.0)
          : const EdgeInsets.only(bottom: 15.0),
      padding: isChart
          ? const EdgeInsets.all(30.0)
          : fullWidth
              ? fullHeight
                  ? null
                  : const EdgeInsets.only(bottom: 8.0)
              : fullHeight
                  ? const EdgeInsets.symmetric(horizontal: 8.0)
                  : const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      width: width,
      child: sectionTitle == null
          ? child
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    sectionTitle!,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                const Divider(
                  //color: Theme.of(context).disabledColor,
                  height: 1.0,
                  thickness: 1.0,
                ),
                Expanded(child: child),
              ],
            ),
    );
  }
}
