import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../components/components.dart';
import '../components/constants.dart';
import '../modules/screens/archive.dart';
import '../modules/screens/done.dart';
import '../modules/screens/tasks.dart';


class HomeLayOut extends StatefulWidget {
  const HomeLayOut({super.key});

  @override
  State<HomeLayOut> createState() => _HomeLayOutState();
}

class _HomeLayOutState extends State<HomeLayOut> {
  int currentIndex = 0;


  List<Widget> _screens = [
    TasksScreen(),
    DoneScreen(),
    ArchiveScreen(),
  ];

  //createDatabase هستدعيها في بداية الصفحة
  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  //متغير لتمرير وحفظ الدات بيز بداخله
  late Database database;

  // كاي للسكافولد لعمل بوتن شيت
  var scaffoldKey = GlobalKey<ScaffoldState>();

  //فورم كاي لعمل فالديت للفورمفيلد
  var formKey = GlobalKey<FormState>();

  //متغير للتحكم في ظهور واخفاء البوتن شيت
  bool isBottomSheetShow = false;

  //متغير للتحكم في ايقون البوتن شيت
  IconData fabIcon = Icons.edit;

  // متغيرات للكنترول ع التيكست فيلد
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  //هعمل ليست احفظ فيه الداتا عند الجيت
  //List<Map> tasks = [];
  //هنقل الليست داخل ملف الكونستنس علشان اقدر ااكسس عليها من باقي الملفات

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
          child: Icon(fabIcon),
          onPressed: () {
            /*//هخليه يعمل انسيرت  للداتا لما اضغط ع البوتن
            insertToDatabase();*/

            //هعمل شرط هنا علشان اقدر افتح البوتن شيت واقفله من الضغط ع البوتن
            if (isBottomSheetShow) {
              //هقوله هنا لو الفالديت اتنفذ اقفل البوتن شيت
              if (formKey.currentState!.validate()) {
                //وبعد ماتنفذ الفالديت وتقفل البوتن شيت هخليه يعملي انسيرت للبيانات دي داخل الداتا بيز بتاعتي
                //هستدعي الفانكشن اللي عملتها اللي بتعمل انسيرت للداتا وامررلها الداتا بتاعتي علشان تحفظها
                insertToDatabase(
                  title: titleController.text,
                  time: timeController.text,
                  date: dateController.text,
                ).then((value) {
                  //لو المتغير بترو اقفل الشيت وخلي قيمة المتغير بفولس
                  Navigator.pop(context);
                  isBottomSheetShow = false;

                  setState(() {
                    //نقلت الميثود اللي بتعمل جيت للداتا هنا علشان اول ما ااقفل البوتن شيت واسيف الداتا اخليه يعملها
                    //جيت اول ما يتقفل البوتن شيت فالداتا تظهر قدامي في نفس الوقت
                    //هعمل جيت للداتا بعد ما افتح الداتا بيز عن طريق الانت ستيت
                    getDataFromDatabase(database).then((value) {
                      //هممر الفاليو اللي هي الداتا اللي في الداتا بيز داخل المتغير الليست ماب
                      tasks = value;});
                    fabIcon = Icons.edit;
                  });
                });
              }
            } else {
              //هظهر البوتن شيت عند الضغط ع الفولتن بوتن
              scaffoldKey.currentState!.showBottomSheet((context) {
                return Container(
                  color:  Colors.grey[100],
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
                              timeController.text = value.format(context).toString();
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
                              dateController.text = DateFormat.yMMMd().format(value);

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
              }).closed.then((value) {

                isBottomSheetShow = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });
              isBottomSheetShow = true;
              setState(() {
                fabIcon = Icons.add;
              });
            }
          }),
      appBar: AppBar(
        title: const Text('Home Screen'),
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
        currentIndex: currentIndex,
        //value هو الانديكس اخاص بليست الايتم
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      //مررة المتغير اللي بياخد قيمة الانديكس الخاص بالتاب وخليته يبقي هو الايندكس
      //الخاص برده بالليست بحيث لما يبق في ايتم 0يعرض اسكرين رقم 0 وهكذا
     //هعمل كونديشن في البادي لو الليست علشان يعملي علامة تحميل هقول لو الليست بتساوي صفر اظهر العلامه لحد ما تبقي الليست اكبر من صفر اخفيها
      //ممكن استخدم باكيدج اسمه conditiolBuilder
      body:tasks.length ==0?Center(child: CircularProgressIndicator()): _screens[currentIndex],
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

//الافضل وككلين كود اني اعمل ميثود لكل حاجه بعملها يعني اكريت داتا بيز بميثود اعدل بميثود اضيف وهكذا

//
  void createDatabase() async {
    //openDatabase برتجعلي قيمة نوعها فيوتشير داتا بيز فانا طبعا هستخدم معاها اسينك واويت وكمان هعمل متغير احفظ فيه القيمة دا
    database = await openDatabase(
      //في ريكوايرد باص يعني عنوان للداتا بيز بتاعتك ودا اجباري اكتب اي اسم وفي الاخر . دي بي
      'todo.db',
      //version دا الاصدار طبعا طالما لسه بتبدأ داتا بيز تبقي فيرجن واحد طيب ضيفت عليها جدول جديد او غيرت فيها حاجات يبقي تزود الاصدار
      version: 1,
      //onCreate بتديني اتنين فاليو اوبجيكت من الداتا بيز اللي عملتها والفيرجين بتاعه ودي بتستدعي لو بكريت داتا بيز جديده
      //انما لو بعدل ع داتا بيز موجوده بالفعل مش هتظهر لانها اصلا موجوده هيظلي الاون اوبن علي طول
      //استخدمها في اني بعمل فيها الجدول الاساسي اللي هيفضل ثابت معايا في الداتا بيز يعني بكريت فيها ثوابت مش قيم متغيره علشان كدا
      //كل ما افتح نفس الداتا بيز مش هتظهر بعد كدا لانها خلاص شئ ثابت وانت بتملاه او بتعدل في القيم اللي بداخله
      onCreate: (database, version) {
        print("database created");
        //execute بتاخد قيم نوعها فيوتشير فهستخدم معاها اسينك واويت او ممكن استخدم معاها زن زي ماشرحناها في التراي كاتش
        //العواميد او العنوانين الثابته الرئيسية اللي هكريتها للجدول
        //id integer
        //title String
        //date String
        //time String
        //status String
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print("table created");
        }).catchError((onError) {
          print("Error when creating table ${onError.toString()}");
        });
      },
      //onOpen
      onOpen: (database) {
        print("database opened");
        //هعمل جيت للداتا بعد ما افتح الداتا بيز عن طريق الانت ستيت
        getDataFromDatabase(database).then((value) {
          //هممر الفاليو اللي هي الداتا اللي في الداتا بيز داخل المتغير الليست ماب
          tasks = value;
        });
      },
    );
  }

  //هنعمل انسيؤت او هندخل بيانات للداتا بيز
  Future insertToDatabase({
    required String title,
    required String date,
    required String time,
}) async {
   return await database.transaction((txn) {
      //هستدعي اسم  التابل والعواميد اللي فيه اللي هدخل فيها البيانات طبعا مش هستدعي الااي دي لانه بريماري كي يعني هو هياخد كاي لواحده مع كل داتا هتدخل
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","new")')
          .then((value) {
        print("$value inserted successfully");
      }).catchError((onError) {
        print("Error when inserting ${onError.toString()}");
      });

      return Future(() => null);
    });
  }


  //Get from database
  //همرر الداتا بيز في البراميتر علشانلما استدعي الداتا بتاعتي ميعملش ايرور لانه بينفئ الميثود الخاصه بالداتا بيز الاول وبعدين بيروح يعمل سيف للناتج داخل متغير الداتا بيز
  //فكاني بقوله استني لما تخلص كل الميثود الخاصه بيك ولما تخلص وتحفظها في الداتا بيز  وبعدين اعملي ليها جيت
Future<List<Map>> getDataFromDatabase(database) async{
   return tasks = await database.rawQuery('SELECT * FROM tasks');


}
}

