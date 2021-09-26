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
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextField(
                        autocorrect: true,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.search_outlined),
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/task_adding'),
                        icon: const Icon(
                          Icons.add_rounded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Tasks",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Events",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Theme.of(context).disabledColor),
                ),
              ),
            ],
          ),
          const Divider(
            //color: Theme.of(context).disabledColor,
            height: 2.0,
            thickness: 1.5,
          ),
          Expanded(
            child: GridView.builder(
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
                              maxLines: 2,
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
                        color: dummyTasks[index].color,
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.4),
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
            ),
          ),
        ],
      ),
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
    ["Programming", "Learning"],
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    Status.inProgress,
    ["Free time"],
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    Status.inProgress,
    ["Friends", "Social"],
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    Status.inProgress,
    ["Math", "Uni"],
  ),
  Task(
    "Make a to-do app!",
    "Oh I can't wait for it to happen, I'll finally be able to keep track of my tasks!",
    DateTime.parse("2021-09-10"),
    DateTime.parse("2021-10-07"),
    Status.inProgress,
    ["Programming", "Learning"],
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    Status.inProgress,
    ["Free time"],
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    Status.inProgress,
    ["Friends", "Social"],
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    Status.inProgress,
    ["Math", "Uni"],
  ),
  Task(
    "Make a to-do app!",
    "Oh I can't wait for it to happen, I'll finally be able to keep track of my tasks!",
    DateTime.parse("2021-09-10"),
    DateTime.parse("2021-10-07"),
    Status.inProgress,
    ["Programming", "Learning"],
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    Status.inProgress,
    ["Free time"],
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    Status.inProgress,
    ["Friends", "Social"],
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    Status.inProgress,
    ["Math", "Uni"],
  ),
  Task(
    "Make a to-do app!",
    "Oh I can't wait for it to happen, I'll finally be able to keep track of my tasks!",
    DateTime.parse("2021-09-10"),
    DateTime.parse("2021-10-07"),
    Status.inProgress,
    ["Programming", "Learning"],
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    Status.inProgress,
    ["Free time"],
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    Status.inProgress,
    ["Friends", "Social"],
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    Status.inProgress,
    ["Math", "Uni"],
  ),
];
