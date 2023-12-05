import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks_app/components/constants.dart';
import 'package:tasks_app/cubit/states.dart';
import 'package:tasks_app/modules/screens/archive.dart';
import 'package:tasks_app/modules/screens/done.dart';
import 'package:tasks_app/modules/screens/tasks.dart';

class AppCupit extends Cubit<AppStates> {
  AppCupit() : super(AppInitialState());

  //اوبجيكت من الكلاس علشان اقدر انادي عليه من اي فايل باسمه
  static AppCupit get(context) => BlocProvider.of(context);

  //الجزء الخاص بالناف بار
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
  /**********************************************/

  //الجزء الخاص بالداتا بيز

//متغير لتمرير وحفظ الدات بيز بداخله
  late Database database;

  //هعمل ليست احفظ فيه الداتا عند الجيت
  List<Map> tasks = [];

  //متغير للتحكم في ظهور واخفاء البوتن شيت
  bool isBottomSheetShow = false;

  //متغير للتحكم في ايقون البوتن شيت
  IconData fabIcon = Icons.edit;

  //الافضل وككلين كود اني اعمل ميثود لكل حاجه بعملها يعني اكريت داتا بيز بميثود اعدل بميثود اضيف وهكذا

//
  void createDatabase()  {
    //openDatabase برتجعلي قيمة نوعها فيوتشير داتا بيز فانا طبعا هستخدم معاها اسينك واويت وكمان هعمل متغير احفظ فيه القيمة دا
    openDatabase(
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
          emit(AppGetDataBaseState());
        });
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  //هنعمل انسيؤت او هندخل بيانات للداتا بيز
  insertToDatabase({
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
        emit(AppInsertDataBaseState());

        getDataFromDatabase(database).then((value) {
          //هممر الفاليو اللي هي الداتا اللي في الداتا بيز داخل المتغير الليست ماب
          tasks = value;
          emit(AppGetDataBaseState());
        });

      }).catchError((onError) {
        print("Error when inserting ${onError.toString()}");
      });

      return Future(() => null);
    });
  }

  //Get from database
  //همرر الداتا بيز في البراميتر علشانلما استدعي الداتا بتاعتي ميعملش ايرور لانه بينفئ الميثود الخاصه بالداتا بيز الاول وبعدين بيروح يعمل سيف للناتج داخل متغير الداتا بيز
  //فكاني بقوله استني لما تخلص كل الميثود الخاصه بيك ولما تخلص وتحفظها في الداتا بيز  وبعدين اعملي ليها جيت
  Future<List<Map>> getDataFromDatabase(database) async {

    emit(AppGetDataBaseLodingState());
    return tasks = await database.rawQuery('SELECT * FROM tasks');
  }

  //   يمثود لتغيير قيمة البوتن شيت من ترو لفولس اوالعكس وتغيير الايقون
 void changeBottomSheetState(
  {@required bool? isShow, @required IconData? icon}
     )
 {
   isBottomSheetShow = isShow!;
   fabIcon = icon!;
   emit(AppChangeBottomSheetState());
 }

}
 
