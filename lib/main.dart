import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'application/bloc/student_bloc.dart';
import 'domain/hive_model/model.dart';
import 'presentation/screens/homescreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(StudentModelAdapter().typeId)) {
    Hive.registerAdapter(StudentModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentBloc>(
      create: (context) => StudentBloc(),
      child: MaterialApp(
        theme:
            ThemeData(primaryColor: Colors.green, primarySwatch: Colors.green),
        title: 'StudentList',
        debugShowCheckedModeBanner: false,
        home: const MyHome(),
      ),
    );
  }
}


