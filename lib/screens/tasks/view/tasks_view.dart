import 'package:chase_your_goals/data/extensions/date_helpers.dart';
import 'package:chase_your_goals/data/models/task.dart';
import 'package:chase_your_goals/data/models/task_status.dart';
import 'package:chase_your_goals/screens/tasks/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chase_your_goals/screens/tasks/cubit/tasks_cubit.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasksCubit(),
      child: const TasksView(),
    );
  }
}

//TODO REPLACE DUMMY TASKS WITH REAL ONES
class TasksView extends StatelessWidget {
  const TasksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.2,
      ),
      itemCount: dummyTasks.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => print(index),
          child: GridTile(
            header: GridTileBar(
              title: Text(
                dummyTasks[index].title,
              ),
              subtitle: dummyTasks[index].description == null
                  ? null
                  : Text(
                      dummyTasks[index].description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            footer: GridTileBar(
              title: const Text("Added:"),
              subtitle: Text(
                dummyTasks[index].dateAdded.getDashedDate(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            //TODO ADD COLOUR BASED ON TAG
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

List<Task> dummyTasks = [
  Task(
    "Make a to-do app!",
    "Oh I can't wait for it to happen, I'll finally be able to keep track of my tasks!",
    DateTime.parse("2021-09-10"),
    DateTime.parse("2021-10-07"),
    Status.inProgress,
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    Status.inProgress,
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    Status.inProgress,
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    Status.inProgress,
  ),
  Task(
    "Make a to-do app!",
    "Oh I can't wait for it to happen, I'll finally be able to keep track of my tasks!",
    DateTime.parse("2021-09-10"),
    DateTime.parse("2021-10-07"),
    Status.inProgress,
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    Status.inProgress,
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    Status.inProgress,
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    Status.inProgress,
  ),
  Task(
    "Make a to-do app!",
    "Oh I can't wait for it to happen, I'll finally be able to keep track of my tasks!",
    DateTime.parse("2021-09-10"),
    DateTime.parse("2021-10-07"),
    Status.inProgress,
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    Status.inProgress,
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    Status.inProgress,
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    Status.inProgress,
  ),
  Task(
    "Make a to-do app!",
    "Oh I can't wait for it to happen, I'll finally be able to keep track of my tasks!",
    DateTime.parse("2021-09-10"),
    DateTime.parse("2021-10-07"),
    Status.inProgress,
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    Status.inProgress,
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    Status.inProgress,
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    Status.inProgress,
  ),
];
