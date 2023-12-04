import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/cubit/states.dart';
import 'package:tasks_app/modules/screens/archive.dart';
import 'package:tasks_app/modules/screens/done.dart';
import 'package:tasks_app/modules/screens/tasks.dart';

class AppCupit extends Cubit<AppStates> {
  AppCupit() : super(AppInitialState());

  //اوبجيكت من الكلاس علشان اقدر انادي عليه من اي فايل باسمه
  static AppCupit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    TasksScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }
}
 
