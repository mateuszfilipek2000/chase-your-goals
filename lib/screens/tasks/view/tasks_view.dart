import 'package:chase_your_goals/data/extensions/date_helpers.dart';
import 'package:chase_your_goals/data/models/task.dart';
import 'package:chase_your_goals/data/models/task_status.dart';
import 'package:chase_your_goals/data/repositories/database_repository.dart';
import 'package:chase_your_goals/screens/tasks/bloc/tasks_viewing_bloc.dart';
import 'package:chase_your_goals/screens/tasks/bloc/tasks_viewing_events.dart';
import 'package:chase_your_goals/screens/tasks/bloc/tasks_viewing_state.dart';
import 'package:chase_your_goals/screens/tasks/widgets/task_card.dart';
import 'package:chase_your_goals/widgets/dimensional_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chase_your_goals/screens/tasks/cubit/tasks_cubit.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskViewingBloc(context.read<DatabaseRepository>())
        ..add(const TaskViewingRequestNotes()),
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
                        onPressed: () => Navigator.of(context)
                            .pushNamed('/task_adding')
                            .then(
                              (value) => context.read<TaskViewingBloc>().add(
                                    const TaskViewingRequestNotes(),
                                  ),
                            ),
                        icon: const Icon(
                          Icons.add_rounded,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context
                    .read<TaskViewingBloc>()
                    .add(const TaskViewingRequestNotes()),
                child: Text(
                  "Notes",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              TextButton(
                onPressed: () => context
                    .read<TaskViewingBloc>()
                    .add(const TaskViewingRequestEvents()),
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
          BlocBuilder<TaskViewingBloc, TaskViewingState>(
            builder: (context, state) {
              if (state is TaskViewingLoading) {
                return const Expanded(
                  child: Center(
                    child: DimensionalCircularProgressIndicator(),
                  ),
                );
              } else if (state is TaskViewingLoadingSuccess) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: DatabaseRepository.instance.getNotes,
                          child: GridTile(
                            header: GridTileBar(
                              title: Text(
                                state.tasks[index].title,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              subtitle: state.tasks[index].description == null
                                  ? null
                                  : Text(
                                      state.tasks[index].description!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                            ),
                            footer: GridTileBar(
                              title: Text(
                                "Added:",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              subtitle: Text(
                                state.tasks[index].dateAdded.getDashedDate(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            //TODO ADD COLOUR BASED ON TAG
                            child: Container(
                              decoration: BoxDecoration(
                                color: state.tasks[index].color == null
                                    ? Colors.yellowAccent
                                    : Color(
                                        int.parse(
                                          state.tasks[index].color!,
                                          radix: 16,
                                        ),
                                      ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .shadowColor
                                        .withOpacity(0.4),
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
                );
              } else {
                return const Center(
                  child: Text(
                      "There's been some kind of problem with loading your tasks, sorry :c"),
                );
              }
            },
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
    NoteStatus.inProgress,
    ["Programming", "Learning"],
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    NoteStatus.inProgress,
    ["Free time"],
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    NoteStatus.inProgress,
    ["Friends", "Social"],
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    NoteStatus.inProgress,
    ["Math", "Uni"],
  ),
  Task(
    "Make a to-do app!",
    "Oh I can't wait for it to happen, I'll finally be able to keep track of my tasks!",
    DateTime.parse("2021-09-10"),
    DateTime.parse("2021-10-07"),
    NoteStatus.inProgress,
    ["Programming", "Learning"],
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    NoteStatus.inProgress,
    ["Free time"],
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    NoteStatus.inProgress,
    ["Friends", "Social"],
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    NoteStatus.inProgress,
    ["Math", "Uni"],
  ),
  Task(
    "Make a to-do app!",
    "Oh I can't wait for it to happen, I'll finally be able to keep track of my tasks!",
    DateTime.parse("2021-09-10"),
    DateTime.parse("2021-10-07"),
    NoteStatus.inProgress,
    ["Programming", "Learning"],
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    NoteStatus.inProgress,
    ["Free time"],
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    NoteStatus.inProgress,
    ["Friends", "Social"],
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    NoteStatus.inProgress,
    ["Math", "Uni"],
  ),
  Task(
    "Make a to-do app!",
    "Oh I can't wait for it to happen, I'll finally be able to keep track of my tasks!",
    DateTime.parse("2021-09-10"),
    DateTime.parse("2021-10-07"),
    NoteStatus.inProgress,
    ["Programming", "Learning"],
  ),
  Task(
    "Watch some tv",
    null,
    DateTime.parse("2021-10-01"),
    null,
    NoteStatus.inProgress,
    ["Free time"],
  ),
  Task(
    "Write a letter to Mon",
    "It's been a really long time since I last spoke to Monica, I should let her know how things are here, maybe send her a gift!",
    DateTime.parse("2021-10-02"),
    DateTime.parse("2021-10-13"),
    NoteStatus.inProgress,
    ["Friends", "Social"],
  ),
  Task(
    "Learn integrals",
    "It's time for some math!",
    DateTime.parse("2021-10-03"),
    DateTime.parse("2021-10-05"),
    NoteStatus.inProgress,
    ["Math", "Uni"],
  ),
];
