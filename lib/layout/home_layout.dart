
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/modules/archived_tasks/archivedTasksScreen.dart';
import 'package:to_do_app/modules/done_tasks/doneTasksScreen.dart';
import 'package:to_do_app/modules/new%20_tasks/newTasksScreen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/components/constants.dart';
import 'package:to_do_app/shared/cubit/cubit_cubit.dart';

// flutter run --no-sound-null-safety
class homeLayout extends StatelessWidget {
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  var formKey = new GlobalKey<FormState>();

  var titleController = new TextEditingController();
  var dateController = new TextEditingController();
  var timeController = new TextEditingController();
  var statusController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is AppInsertDBState) Navigator.pop(context);
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.currentIndex],
              ),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.onBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDB(titleController.text, dateController.text,
                        timeController.text);
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
                                                    initialTime:
                                                        TimeOfDay.now())
                                                .then((value) =>
                                                    timeController.text =
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
                                                    lastDate: DateTime.parse(
                                                        '2021-10-09'))
                                                .then((value) =>
                                                    dateController.text =
                                                        DateFormat.yMMMd()
                                                            .format(value!));
                                          },
                                          label: "Date",
                                          preIcon:
                                              Icons.calendar_today_outlined),
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
                    cubit.setBottomSheet(false, Icons.edit);
                  });
                  cubit.setBottomSheet(true, Icons.add);
                }
              },
              child: Icon(
                cubit.fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
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
              condition: state is! AppSelectDBLoadState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
