import 'package:flutter/material.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/components/constants.dart';

class newTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) => buildTaskItem(tasks[index]),
        separatorBuilder: (context, index) => Container(
              width: double.infinity,
              height: 1.0,
              color: Colors.grey[300],
            ),
        itemCount: tasks.length
        );
  }
}
