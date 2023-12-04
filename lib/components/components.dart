//defaultTextFormFiled
import 'package:flutter/material.dart';

Widget defaultTextFormFiled ({
  required TextEditingController controller,
  required TextInputType keyboardtype,
  Function? onSubmit,
  Function? onChanged,
  //لو حصل مشكلة في نوع الفانكشن عند الكتابة اقف بالماوس علي الفانكشن اللي انت عايزها واطبع نوعها بالظبط في البراميتر
  required String? Function(String?)? validate,
  void Function(String?)? onSaved,
  required String label,
  required String hint,
  required IconData prefix,
  Widget? suffixicon,
  bool isPassword = false,
  int? maxLength,
  void Function()? onTap,
  bool isClickable = true,



})=>TextFormField(
  //controller لحفظ القيمة او الداتا داخل المتغير واقدر اكنترول عليها او استخدمها
  controller: controller,
  keyboardType: keyboardtype,
  //علشان استدعي الفانشكن من البراميتر لازم ااكده انه بيرجع داتا من نفس النوع
  onFieldSubmitted: onSubmit as void Function(String)?,
  onChanged: onChanged as void Function(String)?,
  onSaved: onSaved,
  onTap: onTap,
  //قابل للكتابه او لا
  enabled: isClickable,
  //validator بيخزن التكست او الداتا اليي بيدخلها المستخدم في المتغير فاليو اللي هو المتغير الخاص بالفانكشن بتاعته
  //ليه مزايا كتير منها انه لو المستخدم مدخلش داتا في البورد يقدر يظهرله رسالة ان الحقل فارغ
  //او مثلا حددتله نوع داتا ودخل عكسها او عدد حروف اكبر هنا الفاليديتور بيظهر رسالة للمستخدم بالخطأ اللي بيعمله
  //تابع الكود علشان تعرف الاستخدام
  validator: validate,
  obscureText: isPassword,

  maxLength: maxLength,
  decoration:  InputDecoration(
    alignLabelWithHint: true,
    border: OutlineInputBorder(),
    labelText: label,
    hintText: hint,
    prefixIcon: Icon(prefix),
    //  suffix: suffix,
    suffixIcon: suffixicon,
  ),


);



//build task item
Widget buildTaskItem(Map model)=> Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          child: Text("${model['time']}"),
        ),
        SizedBox(width: 20),
        Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${model['title']}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
              Text("${model['date']}"),
            ]
        ),
      ]
  ),
);