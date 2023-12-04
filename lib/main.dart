import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/cubit/bloc_observser.dart';

import 'layout/home_layout.dart';




void main(){
  Bloc.observer = MyBlocObserver();
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeLayOut(),
    );
  }
}