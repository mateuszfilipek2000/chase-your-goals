import 'package:chase_your_goals/screens/timer/widgets/stopwatch_painter.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:chase_your_goals/data/extensions/date_helpers.dart';

class StopwatchView extends StatefulWidget {
  StopwatchView({
    Key? key,
    required this.hours,
    required this.minutes,
    required this.seconds,
  })  : duration = Duration(hours: hours, minutes: minutes, seconds: seconds),
        super(key: key);

  final Duration duration;
  final int hours;
  final int minutes;
  final int seconds;

  @override
  _StopwatchViewState createState() => _StopwatchViewState();
}

class _StopwatchViewState extends State<StopwatchView>
    with TickerProviderStateMixin {
  late AnimationController initialAnimationController;
  late AnimationController stopwatchAnimationController;
  late AnimationController iconsAnimationController;

  late Animation<double> scaffoldOpacityAnimation;
  late Animation<double> iconAlignmentAnimation;
  late Animation<double> iconRotationAnimation;
  late Animation<double> iconAnimationAnimation;

  late Animation<Alignment> foregroundIconAlignmentAnimation;
  late Animation<Alignment> backgroundIconAlignmentAnimation;
  late Animation<double> foregroundIconRotationAnimation;
  late Animation<double> backgroundIconRotationAnimation;
  late Animation<double> stopwatchAnimation;
  late Animation<double> stopwatchBackgroundAnimation;
  late Animation<double> durationTextOpacityAnimation;

  // late int hours;
  // late int minutes;
  // late int seconds;
  late Duration duration;

  @override
  void initState() {
    // hours = widget.hours;
    // minutes = widget.minutes;
    // seconds = widget.seconds;
    duration = widget.duration;

    initialAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addListener(() {
            setState(() {});
          });

    iconsAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..addListener(() => setState(() {}));

    stopwatchAnimationController =
        AnimationController(vsync: this, duration: widget.duration)
          ..addListener(() => setState(() {}));

    stopwatchAnimation = Tween<double>(begin: 0.0, end: 100.0)
        .animate(stopwatchAnimationController)
      ..addListener(() {
        duration = widget.duration -
            (widget.duration * (stopwatchAnimation.value / 100.0));
      });

    scaffoldOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: initialAnimationController,
        curve: const Interval(
          0.0,
          0.4,
          curve: Curves.linear,
        ),
      ),
    );

    iconAnimationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: iconsAnimationController, curve: Curves.bounceInOut),
    );

    foregroundIconAlignmentAnimation = Tween<Alignment>(
            begin: const Alignment(0, 0.65), end: const Alignment(-0.5, 0.65))
        .animate(
      CurvedAnimation(
        parent: initialAnimationController,
        curve: const Interval(
          0.2,
          0.5,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    backgroundIconAlignmentAnimation = Tween<Alignment>(
            begin: const Alignment(0, 0.65), end: const Alignment(0.5, 0.65))
        .animate(
      CurvedAnimation(
        parent: initialAnimationController,
        curve: const Interval(
          0.2,
          0.5,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    foregroundIconRotationAnimation = Tween<double>(begin: 0.0, end: 2).animate(
      CurvedAnimation(
        parent: initialAnimationController,
        curve: const Interval(
          0.2,
          0.5,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    stopwatchBackgroundAnimation =
        Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(
        parent: initialAnimationController,
        curve: const Interval(
          0.1,
          0.3,
          curve: Curves.linear,
        ),
      ),
    )..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              stopwatchAnimationController.forward();
            }
          });

    durationTextOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: initialAnimationController,
        curve: const Interval(
          0.3,
          0.5,
          curve: Curves.linear,
        ),
      ),
    );

    super.initState();
    // Future.delayed(
    //     const Duration(milliseconds: 500), iconsAnimationController.forward);
    initialAnimationController.forward();
    iconsAnimationController.forward();
  }

  @override
  void dispose() {
    initialAnimationController.dispose();
    iconsAnimationController.dispose();
    stopwatchAnimationController.dispose();
    super.dispose();
  }

  void pauseStopwatch() {
    stopwatchAnimationController.stop();
    iconsAnimationController.reverse();
  }

  void resumeStopwatch() {
    stopwatchAnimationController.forward();
    iconsAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 20.0,
            left: 20.0,
            child: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(Icons.close_rounded),
            ),
          ),
          Align(
            alignment: backgroundIconAlignmentAnimation.value,
            child: Transform.rotate(
              angle: math.pi * foregroundIconRotationAnimation.value,
              child: Material(
                elevation: 3.0,
                shape: const CircleBorder(),
                color: Theme.of(context).primaryColor,
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  onTap: () {
                    pauseStopwatch();
                    stopwatchAnimationController.reset();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.restart_alt_outlined,
                      size: 50.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: foregroundIconAlignmentAnimation.value,
            child: Transform.rotate(
              angle: math.pi * -foregroundIconRotationAnimation.value,
              child: Hero(
                tag: "StopwatchStart",
                child: Material(
                  elevation: 3.0,
                  shape: const CircleBorder(),
                  color: Theme.of(context).primaryColor,
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      if (!iconsAnimationController.isAnimating) {
                        if (iconsAnimationController.isCompleted) {
                          pauseStopwatch();
                        } else {
                          resumeStopwatch();
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        size: 50.0,
                        progress: iconAnimationAnimation,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, -0.5),
            child: ClipOval(
              child: SizedBox(
                height: 300.0,
                width: 300.0,
                child: CustomPaint(
                  painter: StopwatchPainter(
                    stopwatchBackgroundAnimation.value,
                    color: Colors.grey,
                    thickness: 25.0,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, -0.5),
            child: ClipOval(
              child: SizedBox(
                height: 300.0,
                width: 300.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                      child: Opacity(
                        opacity: durationTextOpacityAnimation.value,
                        child: Text(
                          "${duration.stopwatchValues["hours"]!.addLeadingZeros(2)}:${duration.stopwatchValues["minutes"]!.addLeadingZeros(2)}:${duration.stopwatchValues["seconds"]!.addLeadingZeros(2)}",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                    ),
                    CustomPaint(
                      painter: StopwatchPainter(
                        stopwatchAnimation.value,
                        thickness: 25.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension StopwatchHelper on Duration {
  Map<String, int> get stopwatchValues => {
        "hours": (inSeconds / 3600).floor(),
        "minutes": (((inSeconds) - ((inSeconds / 3600).floor())) / 60).floor(),
        "seconds": inSeconds -
            ((inSeconds / 3600).floor() * 3600) -
            ((((inSeconds) - ((inSeconds / 3600).floor())) / 60).floor() * 60),
      };
}
