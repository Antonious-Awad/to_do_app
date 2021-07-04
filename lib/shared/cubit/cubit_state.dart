part of 'cubit_cubit.dart';

@immutable
abstract class AppState {}

class AppInitialState extends AppState {}
class AppChangeNavBarState extends AppState {}
class AppOpenDBState extends AppState {}
class AppSelectDBState extends AppState {}
class AppInsertDBState extends AppState {}
class AppChangeBottomSheetState extends AppState {}
class AppSelectDBLoadState extends AppState {}
class AppUpdateDBState extends AppState {}
class AppDeleteDBState extends AppState {}

