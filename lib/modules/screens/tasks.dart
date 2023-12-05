import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/cubit/cubit.dart';
import 'package:tasks_app/cubit/states.dart';

import '../../components/components.dart';
import '../../components/constants.dart';


class TasksScreen extends StatelessWidget {
  //هعمل متغير نوعه ليست ماب علشان امررله الداتا من الداتا بيز اللي انا عاملها في صفحة اللي اوت وابدأ استخدمها في اسكرين التاسك

  TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCupit, AppStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = BlocProvider.of<AppCupit>(context);
        return ListView.separated(
          itemBuilder: (context, index) {
            //هممر الليست اوف ماب داخل البيلد تاسك واكسس ع الانديكس علشان اوصل للماب اللي داخل كل انديكس واخد منها البيانات
            return buildTaskItem(cubit.tasks[index]);
          },
          separatorBuilder: (context, index) {
            return Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[600],
            );
          },
          itemCount: cubit.tasks.length,
        );
      },
    );
  }
}
