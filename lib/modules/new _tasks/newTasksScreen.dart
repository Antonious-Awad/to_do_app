import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/components/constants.dart';
import 'package:to_do_app/shared/cubit/cubit_cubit.dart';

class newTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return ConditionalBuilder(
            condition: AppCubit.get(context).newTasks.length > 0,
            builder: (BuildContext context) {
              return BlocConsumer<AppCubit, AppState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  var cubit = AppCubit.get(context);
                  return ListView.separated(
                      itemBuilder: (context, index) =>
                          buildTaskItem(cubit.newTasks[index], context),
                      separatorBuilder: (context, index) => Container(
                            width: double.infinity,
                            height: 1.0,
                            color: Colors.grey[300],
                          ),
                      itemCount: cubit.newTasks.length);
                },
              );
            },
            fallback: (context) => buildNoTaskItem());
      },
    );
  }
}
