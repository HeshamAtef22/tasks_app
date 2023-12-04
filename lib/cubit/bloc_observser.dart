import 'package:bloc/bloc.dart';

//البلوك اوبسيرفر دا بيستخدم لمتابعة حالة البلوك وحالة الاستيت بتاعتك والكود دا بيبقي جاهز في الباكيد بتاخده كوبي وتضيفه

class MyBlocObserver extends BlocObserver {

  //onCreate لما اكريت البلوك فبيقولك انت عملت اوبجيكت من اي بلوك
  //او شغال باي بلوك دلوقتي
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }
//بيقولك البلوك اللي حصل فيه تغيير وايه هو التغيير اللي حصل
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }
//الايرورو بيديلك البلوك والايرور عبارة عن ايه وطريقه اصلاحه
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }
//لما اقفل البلوك بيقولك ان البلوك اتقفل
  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}

//علشان تستخدم البلوك اوبسيرفر ليه كود بيتكتب في الmain
//تابع كوده في الmain