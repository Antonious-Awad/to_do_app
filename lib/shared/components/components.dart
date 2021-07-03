import 'package:flutter/material.dart';

Widget defaultButton({
  double? width = double.infinity,
  Color? background = Colors.blue,
  required Function function,
  required String? text,
}) =>
    Container(
      width: width,
      color: background,
      child: MaterialButton(
        onPressed: () => function(),
        child: Text(
          "${text!.toUpperCase()}",
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget textField({
  required TextEditingController Controller,
  required TextInputType keyboard,
  Function? onSubmit,
  Function? onChange,
  Function? onTap,
  required Function(String?) valide,
  required String label,
  required IconData preIcon,
  IconData? sufficon,
  bool password = false,
  Function? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      enabled: isClickable,
      controller: Controller,
      obscureText: password,
      keyboardType: keyboard,
      onFieldSubmitted: (value) => onSubmit!(value),
      onChanged: (value) => onChange!(value),
      validator: (value) => valide(value),
      decoration: InputDecoration(
        //hintText: "Enter your email address",
        labelText: "$label",
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          preIcon,
        ),
        suffixIcon: sufficon != null
            ? IconButton(
                onPressed: () => suffixPressed!(),
                icon: Icon(
                  sufficon,
                ),
              )
            : null,
      ),
      onTap: () => onTap!(),
    );

Widget buildTaskItem(Map model) => Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
              "${model['time']}",
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model['title']}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  "${model['date']}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
