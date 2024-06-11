import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_management/functions/functions.dart';
import 'package:student_management/screens/student_list.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'STUDENT ',
      home: StudentInfo(),
    );
  }
}
