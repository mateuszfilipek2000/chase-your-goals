import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chase_your_goals/screens/task_adding/cubit/task_adding_cubit.dart';
import 'dart:math' as math;

class TaskAddingPage extends StatelessWidget {
  const TaskAddingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => Task_addingCubit(),
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
            onPressed: () => print(":)"),
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
                      }
                    },
                    child: const Text("Date due"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text("DD-MM-YYYY"),
                      Text("HH:MM"),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: DropdownButton(
                      //TODO MAKE BUTTON DISABLED WHEN USER CHOOSES DATE, DISABLE DATE PICKER BUTTON WHEN THIS OPTION IS SELECTED
                      value: 0,
                      onChanged: (dynamic value) {},
                      //onChanged: null,
                      items: const <DropdownMenuItem>[
                        DropdownMenuItem(child: Text("Don't repeat"), value: 0),
                        DropdownMenuItem(child: Text("Daily"), value: 1),
                        DropdownMenuItem(child: Text("Weekly"), value: 2),
                        DropdownMenuItem(child: Text("Monthly"), value: 3),
                        DropdownMenuItem(child: Text("Yearly"), value: 4),
                      ],
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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  for (var i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        onPressed: () {},
                        avatar: const Icon(Icons.highlight_off_rounded),
                        shadowColor: Theme.of(context).shadowColor,
                        label: Text(
                          "tag$i",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        backgroundColor: Colors.primaries[
                            math.Random().nextInt(Colors.primaries.length)],
                      ),
                    ),
                  ActionChip(
                    label: const Icon(
                      Icons.add,
                    ),
                    onPressed: () {
                      //TODO implement adding new tag
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("New tag"),
                            content: TextField(
                              autocorrect: true,
                              decoration: InputDecoration(
                                hintText: "Tag name",
                                hintStyle: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                              style: Theme.of(context).textTheme.button,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TagBox extends StatelessWidget {
  const TagBox(
    this.name, {
    Key? key,
    required this.height,
  }) : super(key: key);

  final String name;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      // wid
      // padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(right: 5.0),
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Center(child: Text(name)),
    );
  }
}
