import sys
import argparse
import pathlib
import fileinput

newScreenBasePath = "lib/screens/"

packageName = "package:chase_your_goals/"


def createNewScreen(name):
    newScreenPath = newScreenBasePath + name
    print("Creating new screen " + name)
    #os.mkdir(os.path.join(newScreenBasePath, name))
    pathlib.Path(newScreenPath).mkdir(parents=True)
    pathlib.Path(newScreenPath + "/view").mkdir(parents=True)
    pathlib.Path(newScreenPath + "/bloc").mkdir(parents=True)
    pathlib.Path(newScreenPath + "/cubit").mkdir(parents=True)
    pathlib.Path(newScreenPath + "/widgets").mkdir(parents=True)
    createCubit(name)
    createView(name)
    addRoutes(name)

def createBloc():
    ""

def createCubit(name):
    print(name)
    file = open(newScreenBasePath + name + "/cubit/" + name + "_cubit.dart", "w")
    file.write("""import 'package:bloc/bloc.dart';
    
class """+name.capitalize()+"""Cubit extends Cubit<int> {
"""+name.capitalize()+"""Cubit() : super(0);

    //TODO IMPLEMENT CUBIT
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
    """)
    file.close()

def createView(name):
    file = open(newScreenBasePath + name + "/view/" + name + "_view.dart", "w")
    file.write("""import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chase_your_goals/screens/"""+name+"""/cubit/"""+name+"""_cubit.dart';

class """+name.capitalize()+"""Page extends StatelessWidget {
  const """+name.capitalize()+"""Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => """+name.capitalize()+"""Cubit(),
      child: const """+name.capitalize()+"""View(),
    );
  }
}

class """+name.capitalize()+"""View extends StatelessWidget {
  const """+name.capitalize()+"""View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
""")
    file.close()


def addRoutes(name):
  routesFileName = "lib/core/config/routes/app_routes.dart"
  
  with open(routesFileName, 'r+') as f:
        content = f.read()
        f.seek(0, 0)
        f.write("import 'package:chase_your_goals/screens/"+name+"/view/"+name+"_view.dart';" + '\n' + content)

  #routesFile = open(routesFileName, "r+")

  contents = []
  index = 0

  lineIndex = 0
  f = open(routesFileName, "r")
  for line in f :
    if "default" in line:
      index = lineIndex
    lineIndex+=1
    contents.append(line)
  f.close()

  contents.insert(index, "      case '/"+ name +"': \n        return MaterialPageRoute(builder: (_) => const "+ name.capitalize() +"Page());" + '\n')

  f = open(routesFileName, "w")
  contents = "".join(contents)
  f.write(contents)
  f.close()


parser = argparse.ArgumentParser(
    description="Basic flutter helper to create with generated routing etc"
)

parser.add_argument('-n', "--new_page", type=str, help="creates new page folder, adds necessary inputs to app routes")

args = parser.parse_args()

if (args.new_page):
    createNewScreen(args.new_page)
