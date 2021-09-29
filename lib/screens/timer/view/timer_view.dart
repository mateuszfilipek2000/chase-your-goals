import 'package:chase_your_goals/screens/timer/widgets/stopwatch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chase_your_goals/screens/timer/cubit/timer_cubit.dart';
import 'package:chase_your_goals/data/extensions/date_helpers.dart';

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
          BlocBuilder<TimerCubit, TimerState>(
            builder: (context, state) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StopwatchButton(
                    onDecrement: context.read<TimerCubit>().decrementHours,
                    onIncrement: context.read<TimerCubit>().incrementHours,
                    value: state.hours.addLeadingZeros(2).toString(),
                  ),
                  Text(
                    ":",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  StopwatchButton(
                    onDecrement: context.read<TimerCubit>().decrementMinutes,
                    onIncrement: context.read<TimerCubit>().incrementMinutes,
                    value: state.minutes.addLeadingZeros(2).toString(),
                  ),
                  Text(
                    ":",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  StopwatchButton(
                    onDecrement: context.read<TimerCubit>().decrementSeconds,
                    onIncrement: context.read<TimerCubit>().incrementSeconds,
                    value: state.seconds.addLeadingZeros(2).toString(),
                  ),
                ],
              );
            },
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
                      "hours": context.read<TimerCubit>().state.hours,
                      "minutes": context.read<TimerCubit>().state.minutes,
                      "seconds": context.read<TimerCubit>().state.seconds,
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
