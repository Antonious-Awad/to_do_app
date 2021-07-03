import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/modules/archived_tasks/archivedTasksScreen.dart';
import 'package:to_do_app/modules/done_tasks/doneTasksScreen.dart';
import 'package:to_do_app/modules/new%20_tasks/newTasksScreen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/components/constants.dart';

// flutter run --no-sound-null-safety
class homeLayout extends StatefulWidget {
  @override
  _homeLayoutState createState() => _homeLayoutState();
}

class _homeLayoutState extends State<homeLayout> {
  List<String> titles = ["New Tasks", "Done Tasks", "Archived Tasks"];
  List<Widget> screens = [newTask(), doneTask(), archivedTask()];
  int currentIndex = 0;
  Database? database;
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  var formKey = new GlobalKey<FormState>();
  bool onBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  var titleController = new TextEditingController();
  var dateController = new TextEditingController();
  var timeController = new TextEditingController();
  var statusController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    createDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () /*async*/ {
          // try{
          // var name = await getName();
          // print(name);
          // }catch(error){
          //   print("${error.toString()}");
          // }
          // getName().then((value) {
          //   print(value);
          //   print("tony awad");
          // }).catchError((error) {
          //   print("${error.toString()}");
          // });
          if (onBottomSheetShow) {
            if (formKey.currentState!.validate()) {
              insertToDB(titleController.text, dateController.text,
                      timeController.text)
                  .then((value) {
                selectFromDB(database!).then((value) {
                  Navigator.pop(context);
                  onBottomSheetShow = false;
                  setState(() {
                    fabIcon = Icons.edit;
                    tasks = value;
                    print(tasks);
                  });
                });
              });
            }
          } else {
            scaffoldKey.currentState!
                .showBottomSheet(
                    (context) => Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //title
                                textField(
                                    Controller: titleController,
                                    keyboard: TextInputType.text,
                                    valide: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter title";
                                      }
                                      return null;
                                    },
                                    label: "Title of The Task",
                                    preIcon: Icons.title),
                                SizedBox(
                                  height: 10.0,
                                ),
                                //time
                                textField(
                                    Controller: timeController,
                                    keyboard: TextInputType.datetime,
                                    valide: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter time ";
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) => timeController.text =
                                              value!.format(context));
                                    },
                                    label: "Time",
                                    preIcon: Icons.timelapse),
                                SizedBox(
                                  height: 10.0,
                                ),
                                //date
                                textField(
                                    Controller: dateController,
                                    keyboard: TextInputType.datetime,
                                    valide: (value) {
                                      if (value!.isEmpty) {
                                        return "Enter date ";
                                      }
                                      return null;
                                    },
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2021-10-09'))
                                          .then((value) => dateController.text =
                                              DateFormat.yMMMd()
                                                  .format(value!));
                                    },
                                    label: "Date",
                                    preIcon: Icons.calendar_today_outlined),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                    elevation: 20.0)
                .closed
                .then((value) {
              onBottomSheetShow = false;
              setState(() {
                fabIcon = Icons.edit;
              });
            });
            onBottomSheetShow = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(
          fabIcon,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Tasks",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: "Done"),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: "Archive"),
        ],
      ),
      body: ConditionalBuilder(
        condition: tasks.length > 0,
        builder: (context) => screens[currentIndex],
        fallback: (context) => CircularProgressIndicator(),
      ),
    );
  }

  Future<String> getName() async {
    return "Tony";
  }

  void createDB() async {
    String sql = """CREATE TABLE tasks(
      id INTEGER PRIMARY KEY,
      title TEXT,
      date TEXT,
      time TEXT,
      status TEXT
    )""";
    database = await openDatabase("todo.db", version: 1,
        onCreate: (database, version) {
      print("Database Created");
      database.execute(sql).then((value) {
        print("Table Created");
      }).catchError((error) {
        print("Error while creating DB ${error.toString()}");
      });
    }, onOpen: (database) {
      selectFromDB(database).then((value) {
        setState(() {
          tasks = value;
        });
        print(tasks);
      }).catchError(
          (error) => print("Error getting values: ${error.toString()}"));
    });
  }

  Future insertToDB(String title, String date, String time) async {
    String sql = """
    INSERT INTO tasks(title , date ,time ,status)
    VALUES("$title" , "$date" , "$time" , "new")
    """;
    return await database!.transaction((txn) {
      txn.rawInsert(sql).then((value) {
        print("$value inserted successfully");
      }).catchError((error) {
        print("Error adding values: ${error.toString()}");
      });
      return null;
    });
  }

  Future<List<Map>> selectFromDB(Database database) async {
    String sql = "SELECT * FROM tasks";
    return await database.rawQuery(sql);
  }

  void updateDB() {}
}
