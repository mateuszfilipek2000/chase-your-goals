import 'package:chase_your_goals/screens/timer/widgets/stopwatch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chase_your_goals/screens/timer/cubit/timer_cubit.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerCubit(),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StopwatchButton(
                onDecrement: () {},
                onIncrement: () {},
                value: "HH",
              ),
              Text(
                ":",
                style: Theme.of(context).textTheme.headline4,
              ),
              StopwatchButton(
                onDecrement: () {},
                onIncrement: () {},
                value: "MM",
              ),
              Text(
                ":",
                style: Theme.of(context).textTheme.headline4,
              ),
              StopwatchButton(
                onDecrement: () {},
                onIncrement: () {},
                value: "SS",
              ),
            ],
          ),
          Hero(
            tag: "StopwatchStart",
            child: Material(
              elevation: 3.0,
              shape: const CircleBorder(),
              color: Theme.of(context).primaryColor,
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/stopwatch",
                    arguments: {
                      "hours": 0,
                      "minutes": 1,
                      "seconds": 0,
                    },
                  );
                },
                child: const AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  size: 100.0,
                  progress: AlwaysStoppedAnimation<double>(0.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
