import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../components/constants.dart';


class TasksScreen extends StatelessWidget {
  //هعمل متغير نوعه ليست ماب علشان امررله الداتا من الداتا بيز اللي انا عاملها في صفحة اللي اوت وابدأ استخدمها في اسكرين التاسك

   TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          //هممر الليست اوف ماب داخل البيلد تاسك واكسس ع الانديكس علشان اوصل للماب اللي داخل كل انديكس واخد منها البيانات
        return buildTaskItem(tasks[index]);
        },
        separatorBuilder: (context, index) {
          return Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[600],
          );
        },
        itemCount: tasks.length,
    );
  }
}
