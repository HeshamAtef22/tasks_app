// ignore_for_file: public_member_api_docs, sort_constructors_first
//هعمل كلاس واحد بيعبر عن الحاله او الاستيت علشان امرره للكيوبيت لانه مش بياخد غير كلاس او حاله واحده
//عن طريق الكلاس دا هورث منه اي حالة انا عايزها
abstract class CounterStates {}

//هعمل كلاس ابدأ به يعني يبقي الكلاس الخاص بالحالة الاساسية للبرنامج وبعدين اتنقل لاي حالة او كلاس غيره بعد كده
class CounterInitialState extends CounterStates {}

//كلاس في حالة اي نقصت من الكاونتر
class CounterPlussState extends CounterStates {
  //ممكن ابعت قيمة مع الحالة او الاستيت لما استدعيها
  final int counter;
  CounterPlussState(
     this.counter,
  );
}

//كلاس لحالة اضافة او تزويد الكاونتر
class CounterMinusState extends CounterStates {
  final int counter;
  CounterMinusState(this.counter);

}
