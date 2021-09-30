import 'package:chase_your_goals/data/models/event.dart';
import 'package:chase_your_goals/data/models/event_repeat_modes.dart';
import 'package:chase_your_goals/data/models/note.dart';
import 'package:chase_your_goals/data/repositories/database_repository.dart';
import 'package:chase_your_goals/screens/task_adding/bloc/task_adding_bloc.dart';
import 'package:chase_your_goals/screens/task_adding/bloc/task_events.dart';
import 'package:chase_your_goals/screens/task_adding/bloc/task_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'package:chase_your_goals/data/extensions/date_helpers.dart';

class TaskAddingPage extends StatelessWidget {
  const TaskAddingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskAddingBloc(context.read<DatabaseRepository>()),
      child: const TaskAddingView(),
    );
  }
}

//TODO ADD TEXT FIELD VERIFICATION, AUTO DETECTION OF TAGS WHEN USER USES HASHTAGS
class TaskAddingView extends StatelessWidget {
  const TaskAddingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adding new task"),
        actions: [
          IconButton(
            onPressed: () async {
              TaskState state = context.read<TaskAddingBloc>().state;
              if (state.title.replaceAll(" ", "") == "") {
                print("title can not be empty");
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      "Don't forget to set title for your task!",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                );
              } else {
                //creating object to add to db
                if (state.dueDate != null) {
                  //if due date is not null then the object is an event
                  await context.read<DatabaseRepository>().addTask(
                        Event.fromTaskState(state),
                      );
                } else {
                  //adding note
                  await context.read<DatabaseRepository>().addTask(
                        Note.fromTaskState(state),
                      );
                }
              }
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.check_rounded,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              autocorrect: true,
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(
                  color: Theme.of(context).disabledColor,
                ),
              ),
              style: Theme.of(context).textTheme.button,
              onChanged: (val) =>
                  context.read<TaskAddingBloc>().add(TitleChanged(val)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                autocorrect: true,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                maxLines: null,
                expands: true,
                minLines: null,
                style: Theme.of(context).textTheme.button,
                onChanged: (val) =>
                    context.read<TaskAddingBloc>().add(DescriptionChanged(val)),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.08,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 1000),
                        ),
                      );

                      if (date != null) {
                        TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          date = DateTime(date.year, date.month, date.day,
                              time.hour, time.minute);
                        }
                        context.read<TaskAddingBloc>().add(
                              DateDueChanged(date),
                            );
                      }
                    },
                    child: const Text("Date due"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BlocBuilder<TaskAddingBloc, TaskState>(
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: state.dueDate == null
                            ? [
                                const Text("DD-MM-YYYY"),
                                const Text("HH:MM"),
                              ]
                            : [
                                Text(
                                  state.dueDate!.getDashedDate(),
                                ),
                                Text(
                                  state.dueDate!.time,
                                ),
                              ],
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: BlocBuilder<TaskAddingBloc, TaskState>(
                      builder: (context, state) {
                        return DropdownButton(
                          value: state.repeatMode ?? EventRepeatMode.values[0],
                          onChanged: state.dueDate == null
                              ? null
                              : (val) => context.read<TaskAddingBloc>().add(
                                    RepeatModeChanged(val as EventRepeatMode),
                                  ),
                          items: EventRepeatMode.values
                              .map(
                                (e) => DropdownMenuItem(
                                    child: Text(repeatValues[e]!), value: e),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(
              thickness: 2.0,
            ),
          ),
          SizedBox(
            height: size.height * 0.08,
            //width: size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                autocorrect: true,
                decoration: InputDecoration(
                  hintText: "Tags, separate tags using commas.",
                  hintStyle: TextStyle(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
                style: Theme.of(context).textTheme.button,
                onChanged: (val) =>
                    context.read<TaskAddingBloc>().add(TagsChanged(val)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget taskAddingChip(BuildContext context) => ActionChip(
//       label: const Icon(
//         Icons.add,
//       ),
//       onPressed: () {
//         //TODO implement adding new tag
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: const Text("New tag"),
//               content: TextField(
//                 autocorrect: true,
//                 decoration: InputDecoration(
//                   hintText: "Tag name",
//                   hintStyle: TextStyle(
//                     color: Theme.of(context).disabledColor,
//                   ),
//                 ),
//                 style: Theme.of(context).textTheme.button,
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Cancel"),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     context.read<TaskAddingBloc>().add(TagsChanged(context.read<TaskAddingBloc>().state.tags == null ? []))
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Add"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );

// class TagBox extends StatelessWidget {
//   const TagBox(
//     this.name, {
//     Key? key,
//     required this.height,
//   }) : super(key: key);

//   final String name;
//   final double height;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       // wid
//       // padding: const EdgeInsets.all(8.0),
//       margin: const EdgeInsets.only(right: 5.0),
//       decoration: const BoxDecoration(
//         color: Colors.blue,
//       ),
//       child: Center(child: Text(name)),
//     );
//   }
// }
