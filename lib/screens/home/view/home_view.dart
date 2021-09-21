import 'package:chase_your_goals/screens/home/widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chase_your_goals/screens/home/cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavbar(
        onPageChanged: (int i) => print(i),
        buttonTexts: const [
          "Home",
          "Tasks",
          "Lists",
          "About",
        ],
      ),
      body: const Center(
        child: Text("asd"),
      ),
    );
  }
}
