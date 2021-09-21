import 'package:chase_your_goals/core/config/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

//TODO ADD INTERNATIONALIZATION
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale("en", "US"),
        Locale("pl", "PL"),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/home",
      onGenerateRoute: AppRoutes.onGeneratedRoute,
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   const MyHomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SimpleLinearGraph(
//           height: 130.0,
//           width: 250.0,
//           graphPoints: graphPoints,
//           maxX: 50,
//           maxY: 115,
//           minX: 0,
//           minY: 20,
//         ),
//       ),
//     );
//   }
// }

// List<List<Offset>> graphPoints = [
//   [
//     const Offset(10, 100),
//     const Offset(30, 60),
//     const Offset(35, 50),
//     const Offset(40, 30),
//     const Offset(20, 50),
//     const Offset(15, 70),
//   ],
// ];
