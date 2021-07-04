import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/cubit/cubit_cubit.dart';

class doneTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      builder: (BuildContext context) {
      return BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return ListView.separated(
              itemBuilder: (context, index) =>
                  buildTaskItem(cubit.doneTasks[index], context),
              separatorBuilder: (context, index) => Container(
                    width: double.infinity,
                    height: 1.0,
                    color: Colors.grey[300],
                  ),
              itemCount: cubit.doneTasks.length);
        },
      );
    }, 
      condition: AppCubit.get(context).doneTasks.length>0,
      fallback: (context)=>buildNoTaskItem(),
      );
  }
}
