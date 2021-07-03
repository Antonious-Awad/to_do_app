import 'package:flutter/material.dart';
import 'package:to_do_app/shared/components/components.dart';

class newTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context , index) => buildTaskItem(), 
      separatorBuilder: (context, index)=> SizedBox(height: 15,), 
      itemCount: 10
      );
  }
}
