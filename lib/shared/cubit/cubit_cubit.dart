import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks/archivedTasksScreen.dart';
import 'package:to_do_app/modules/done_tasks/doneTasksScreen.dart';
import 'package:to_do_app/modules/new%20_tasks/newTasksScreen.dart';

part 'cubit_state.dart';

class AppCubit extends Cubit<AppState> {
  List<String> titles = ["New Tasks", "Done Tasks", "Archived Tasks"];
  List<Widget> screens = [newTask(), doneTask(), archivedTask()];
  int currentIndex = 0;

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archTasks = [];

  bool onBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  void createDB() {
    String sql = """CREATE TABLE tasks(
      id INTEGER PRIMARY KEY,
      title TEXT,
      date TEXT,
      time TEXT,
      status TEXT
    )""";
    openDatabase("todo.db", version: 1, onCreate: (database, version) {
      print("Database Created");
      database.execute(sql).then((value) {
        print("Table Created");
      }).catchError((error) {
        print("Error while creating DB ${error.toString()}");
      });
    }, onOpen: (database) {
      selectFromDB(database);
    }).then((value) {
      database = value;
      emit(AppOpenDBState());
    });
  }

  insertToDB(String title, String date, String time) async {
    String sql = """
    INSERT INTO tasks(title , date ,time ,status)
    VALUES("$title" , "$date" , "$time" , "new")
    """;
    return await database!.transaction((txn) {
      txn.rawInsert(sql).then((value) {
        print("$value inserted successfully");
        emit(AppInsertDBState());

        selectFromDB(database!);
      }).catchError((error) {
        print("Error adding values: ${error.toString()}");
      });
      return null;
    });
  }

  void selectFromDB(Database database) {
    newTasks = [];
    doneTasks = [];
    archTasks = [];
    emit(AppSelectDBLoadState());
    String sql = "SELECT * FROM tasks";
    database.rawQuery(sql).then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') newTasks.add(element);
        if (element['status'] == 'done') doneTasks.add(element);
        if (element['status'] == 'archived') archTasks.add(element);
      });
      emit(AppSelectDBState());
    }).catchError(
        (error) => print("Error getting values: ${error.toString()}"));
  }

  Future<int> updateDB(String status, int id) {
    String sql = "UPDATE tasks SET status= ?  WHERE id = ?";
    return database!.rawUpdate(
      sql,
      ['$status', id],
    ).then((value) {
      selectFromDB(database!);
      emit(AppUpdateDBState());
      return 0;
    });
  }

  void setBottomSheet(bool isShown, IconData fabIcon) {
    onBottomSheetShow = isShown;
    this.fabIcon = fabIcon;
    emit(AppChangeBottomSheetState());
  }

  void deletefromDB(int id) {
    String sql = "DELETE FROM tasks WHERE id = ?";
    database!.rawDelete(sql, [id]).then((value) {
      selectFromDB(database!);
      emit(AppDeleteDBState());
    });
  }
}
