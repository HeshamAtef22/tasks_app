import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_app/cubit/cubit.dart';
import 'package:tasks_app/cubit/states.dart';
import 'package:tasks_app/main.dart';
import '../components/components.dart';
import '../components/constants.dart';
import '../modules/screens/archive.dart';
import '../modules/screens/done.dart';
import '../modules/screens/tasks.dart';

class HomeLayOut extends StatelessWidget {




  // كاي للسكافولد لعمل بوتن شيت
  var scaffoldKey = GlobalKey<ScaffoldState>();

  //فورم كاي لعمل فالديت للفورمفيلد
  var formKey = GlobalKey<FormState>();



  // متغيرات للكنترول ع التيكست فيلد
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  //هعمل ليست احفظ فيه الداتا عند الجيت
  //List<Map> tasks = [];
  //هنقل الليست داخل ملف الكونستنس علشان اقدر ااكسس عليها من باقي الملفات


  /*//createDatabase هستدعيها في بداية الصفحة
  @override
  void initState() {
    super.initState();
    createDatabase();
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCupit()..createDatabase(),
      child: BlocConsumer<AppCupit, AppStates>(
        listener: (context, state) {
          if(state is AppInsertDataBaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {

          //هعمل اوبجيكت من الكيوبت علشان استخدمه بدل ما انادي علي الكيوبت
          AppCupit cubit = AppCupit.get(context);
          return Scaffold(
            key: scaffoldKey,
            floatingActionButton: FloatingActionButton(
                child: Icon(cubit.fabIcon),
                onPressed: () {
                  /*//هخليه يعمل انسيرت  للداتا لما اضغط ع البوتن
            insertToDatabase();*/

                  //هعمل شرط هنا علشان اقدر افتح البوتن شيت واقفله من الضغط ع البوتن
                  if (cubit.isBottomSheetShow) {
                    //هقوله هنا لو الفالديت اتنفذ اقفل البوتن شيت
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(title: titleController.text, date: timeController.text, time: dateController.text);
                      /*//وبعد ماتنفذ الفالديت وتقفل البوتن شيت هخليه يعملي انسيرت للبيانات دي داخل الداتا بيز بتاعتي
                      //هستدعي الفانكشن اللي عملتها اللي بتعمل انسيرت للداتا وامررلها الداتا بتاعتي علشان تحفظها
                      insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      ).then((value) {
                        //لو المتغير بترو اقفل الشيت وخلي قيمة المتغير بفولس
                        Navigator.pop(context);
                        isBottomSheetShow = false;

                        *//*setState(() {
                    //نقلت الميثود اللي بتعمل جيت للداتا هنا علشان اول ما ااقفل البوتن شيت واسيف الداتا اخليه يعملها
                    //جيت اول ما يتقفل البوتن شيت فالداتا تظهر قدامي في نفس الوقت
                    //هعمل جيت للداتا بعد ما افتح الداتا بيز عن طريق الانت ستيت
                    getDataFromDatabase(database).then((value) {
                      //هممر الفاليو اللي هي الداتا اللي في الداتا بيز داخل المتغير الليست ماب
                      tasks = value;
                    });
                    fabIcon = Icons.edit;
                  });*//*
                      });*/
                    }
                  } else {
                    //هظهر البوتن شيت عند الضغط ع الفولتن بوتن
                    scaffoldKey.currentState!
                        .showBottomSheet((context) {
                      return Container(
                        color: Colors.grey[100],
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              //هعمل تيكست فيلد ادخل من خلالها داتا للداتا بيز
                              //تيكست فيلد للتايتل
                              defaultTextFormFiled(
                                controller: titleController,
                                keyboardtype: TextInputType.text,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "title must not be empty";
                                  }
                                  return null;
                                },
                                onTap: () {
                                  print("title tapped");
                                },
                                label: "Task Title",
                                hint: "your task title",
                                prefix: Icons.title,
                              ),
                              SizedBox(height: 15),
                              //تيكست فيلد للتايم
                              defaultTextFormFiled(
                                controller: timeController,
                                keyboardtype: TextInputType.datetime,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Time must not be empty";
                                  }
                                  return null;
                                },
                                onTap: () {
                                  //دي ميثود جاهزة بتظهرلي مربع يظهر فيه داتا زي التايم مثلا او غيرها
                                  //دي بتفتحلي ويدجيت فيها التايم الحالي واقدر احدد منها اي تايم محتاجه
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    //المفروض بعد ما افتح التايم بيكر اختار التايم والمفروض اني احفظه علشان اقدر اعمل عليه اي اكشن محتاجه
                                    //التايم بيكر لانها في بتاخد قيمة مستقبلا فهي بترجعي قيمة نوعها فيوتشير
                                    //فهستخم معاها زن او تراي كاتش
                                  ).then((value) {
                                    //format بستخدمها مع التايم علشان ترجعهولي متهندل  زي تو سترينج كدا
                                    print(value!.format(context));
                                    //همرر القيمة اللي دخلتها من الفاليو للتايم كونترولر علشان اقدر اتحكم فيها وتبقي محفوظه معايا وكمان اقدر اظهرها
                                    timeController.text =
                                        value.format(context).toString();
                                  });
                                },
                                label: "Time",
                                hint: "insert time",
                                prefix: Icons.watch_later_outlined,
                              ),
                              SizedBox(height: 15),
                              //تيكسن فيلد للديت
                              defaultTextFormFiled(
                                controller: dateController,
                                keyboardtype: TextInputType.datetime,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Date must not be empty";
                                  }
                                  return null;
                                },
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse("2023-12-31"),
                                  ).then((value) {
                                    //التو سترينج مش بتظهر التاريخ بالشكل الافضل فعلشان اقدر اهندل التاريخ واظهره هستخدم باكيدج اسمها انتيل intl
                                    // print(value.toString());

                                    //هستخدم الباكيدج واهندل بيه التاريخ
                                    print(DateFormat.yMMMd().format(value!));
                                    //هممر القيمة للديت كونترول علشان يحفظها واظهرها ع التيكست فيلد
                                    dateController.text =
                                        DateFormat.yMMMd().format(value);
                                  });
                                },
                                label: "Date",
                                hint: "insert date",
                                prefix: Icons.calendar_today,
                              ),
                            ],
                          ),
                        ),
                      );
                      //هساخدم فيوتشير كلوسد علشان لو اليوزر قفل الشيت بايده من غير البوتن ميعملش ايرور لا هخليه ينفذ نفذ الامر اللي بعمل لما يقفله من البوتن
                    })
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
                      /*setState(() {
                      fabIcon = Icons.edit;
                    });*/
                    });
                    cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                    /*cubit.isBottomSheetShow = true;*/
                    /*setState(() {
                fabIcon = Icons.add;
              });*/
                  }
                }),
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: "tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archive"),
              ],

              //some Option

              selectedIconTheme: IconThemeData(size: 31, color: Colors.red),
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              //value هو الانديكس اخاص بليست الايتم
              onTap: (index) {
                cubit.changeIndex(index);
                /* setState(() {
            currentIndex = index;
          });*/
              },
            ),
            //مررة المتغير اللي بياخد قيمة الانديكس الخاص بالتاب وخليته يبقي هو الايندكس
            //الخاص برده بالليست بحيث لما يبق في ايتم 0يعرض اسكرين رقم 0 وهكذا
            //هعمل كونديشن في البادي لو الليست علشان يعملي علامة تحميل هقول لو الليست بتساوي صفر اظهر العلامه لحد ما تبقي الليست اكبر من صفر اخفيها
            //ممكن استخدم باكيدج اسمه conditiolBuilder
            body: cubit.tasks.length == 0
                ? Center(child: CircularProgressIndicator())
                : cubit.screens[cubit.currentIndex],
          );
        },
      ),
    );
  }

  //دي الخطوات او طريقة استخدامي للداتا بيز
//1. create database
//2. create table
//3. open database //بعملها اوبن علشان اقدر اخد منها اوبجيكت فاقدر اني ادخلها داتا
//او اخد منها داتا او اعدل عليها او احذفها
//4. insert to database
//5. get from database
//6. update in database
//7. delete in database


}
