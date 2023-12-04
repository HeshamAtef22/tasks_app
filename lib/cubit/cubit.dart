import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/cubit/states.dart';


class CounterCubit extends Cubit<CounterStates> {
  //الحالة الاساسية للكيوبيت هتساوي CounterInitialState
  CounterCubit() : super(CounterInitialState());
 //اوبجيكت ثابت للكلاس لاستخدامه مباشر في اي فايل 
  static CounterCubit get(context) => BlocProvider.of(context);

  int counter = 1;

  //هعمل ميثود للتحكم في الكاونتر
  void minus() {
    counter--;
    //هبعتله هنا في الفانكشن الحالة اللي هيبعتها او السيت استيت اللي هيبعته لما استخدم الفانكشن دا
    //علشان لما استخدم الفانكشن فيستدعي الاستيت او الحالة الجديده اللي بتبلد الكود من تاني فيظهر التغيير
    //همررله الكلاس الخاص بحالة اني نقصت عل الكونتر
    emit(CounterMinusState(counter));
  }

  void pluss() {
    counter++;
    emit(CounterPlussState(counter));
  }
}
 
