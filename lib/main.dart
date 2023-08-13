import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:to_do/shared/bloc.dart';

import 'layout/home_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      home: HomeLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}

