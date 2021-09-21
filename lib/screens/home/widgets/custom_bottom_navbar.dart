import 'package:flutter/material.dart';

class CustomBottomNavbar extends StatefulWidget {
  const CustomBottomNavbar(
      {Key? key,
      this.height = 60.0,
      required this.onPageChanged,
      required this.buttonTexts})
      : super(key: key);

  final double height;
  final void Function(int) onPageChanged;
  final List<String> buttonTexts;

  @override
  _CustomBottomNavbarState createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;

  double selectedTab = 0;

  @override
  void initState() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() => setState(() {}));

    animation = Tween<double>(begin: selectedTab, end: selectedTab + 1).animate(
        CurvedAnimation(parent: animController, curve: Curves.bounceInOut));

    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: widget.height * 0.05,
            width: double.infinity,
            child: CustomPaint(
              painter: NavigationBarIndicatorPainter(
                widget.buttonTexts.length,
                selectedTabIndex: animation.value,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                for (var i = 0; i < widget.buttonTexts.length; i++)
                  Expanded(
                    child: TextButton(
                      child: Center(
                        child: Text(
                          widget.buttonTexts[i],
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      onPressed: () {
                        widget.onPageChanged(i);
                        setState(() {
                          animation = Tween<double>(
                                  begin: animation.value, end: i.toDouble())
                              .animate(CurvedAnimation(
                                  parent: animController,
                                  curve: Curves.bounceInOut));
                          selectedTab = i.toDouble();
                          animController.reset();
                          animController.forward();
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationBarIndicatorPainter extends CustomPainter {
  NavigationBarIndicatorPainter(this.amountOfTabs,
      {required this.selectedTabIndex});
  final int amountOfTabs;
  double selectedTabIndex = 0;

  @override
  void paint(Canvas canvas, Size size) {
    final double singleTabSize = size.width / amountOfTabs;

    Paint indicatorPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt;

    Paint inactiveAreaPaint = Paint()
      ..color = Colors.grey.withOpacity(0.6)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt;

    canvas.drawRect(
        Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height)),
        inactiveAreaPaint);

    canvas.drawRect(
        Rect.fromPoints(Offset(singleTabSize * selectedTabIndex, 0),
            Offset(singleTabSize * (selectedTabIndex + 1), size.height)),
        indicatorPaint);
  }

  @override
  bool shouldRepaint(NavigationBarIndicatorPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(NavigationBarIndicatorPainter oldDelegate) =>
      false;
}
