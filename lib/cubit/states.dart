
abstract class AppStates {}

class AppInitialState extends AppStates {}

//ستيت خاصه بالبوتن بار
class AppChangeBottomNavBarState extends AppStates{}

// 3 حالات او ستيتس خاصه ب الداتا بيز
class AppCreateDataBaseState extends AppStates{}

class AppGetDataBaseState extends AppStates{}

class AppGetDataBaseLodingState extends AppStates{}

class AppInsertDataBaseState extends AppStates{}

//استيت خاصة بالتغيير في البوتن شيت
class AppChangeBottomSheetState extends AppStates{}