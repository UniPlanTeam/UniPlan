/// Task creation view
/// @author Praneet Singh

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cognito/models/task.dart';

enum Day { M, Tu, W, Th, F, Sat, Sun }

class AddTaskView extends StatefulWidget {
  @override
  _AddTaskViewState createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isRepeated = false;
  DateTime dueDate;
  List<int> daysOfEvent = List();
  ListTile textFieldTile(
      {Widget leading,
      Widget trailing,
      TextInputType keyboardType,
      String hint,
      Widget subtitle,
      TextEditingController controller}) {
    return ListTile(
      leading: leading,
      trailing: trailing,
      title: TextFormField(
        controller: controller,
        autofocus: false,
        keyboardType: keyboardType,
        style: Theme.of(context).accentTextTheme.body1,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black45),
        ),
      ),
      subtitle: subtitle,
    );
  }

  void selectDay(Day day) {
    setState(() {
      daysOfEvent.add(day.index + 1);
    });
  }

  void deselectDay(Day day) {
    setState(() {
      daysOfEvent.remove(day.index + 1);
    });
  }

  Column daySelectionColumn(Day day) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(day.toString().substring(4)),
        Checkbox(
          value: daysOfEvent.contains(day.index + 1),
          onChanged: (bool e) {
            daysOfEvent.contains(day.index + 1)
                ? deselectDay(day)
                : selectDay(day);
            if (daysOfEvent.isEmpty) {
              _isRepeated = false;
            } 
            else {
              _isRepeated = true;
            }
            print(_isRepeated);
          },
        ),
      ],
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    // Hide keyboard before showing date picker
    FocusScope.of(context).requestFocus(FocusNode());

    // Add delay to be sure keyboard is no longer visible
    await Future.delayed(Duration(milliseconds: 200));

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(3000));

    if (picked != null) {
      print("Date selected: ${picked.toString()}");
      setState(() {
        dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Task"),
          backgroundColor: Theme.of(context).primaryColorDark,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pop(_titleController != null
                    ? Task(
                        title: _titleController.text,
                        location: _locationController.text,
                        description: _descriptionController.text,
                        daysOfEvent: daysOfEvent,
                        isRepeated: _isRepeated,
                        dueDate: dueDate)
                    : null);
              },
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(0.0)),
            textFieldTile(hint: "Title", controller: _titleController),
            textFieldTile(hint: "Location", controller: _locationController),
            ListTile(
              title: TextFormField(
                controller: _descriptionController,
                autofocus: false,
                style: Theme.of(context).accentTextTheme.body1,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                maxLines: 5,
                decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(color: Colors.black45)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                "Select Due Date",
                style: Theme.of(context).accentTextTheme.body2,
              ),
              trailing: Text(
                dueDate != null
                    ? "${dueDate.month.toString()}/${dueDate.day.toString()}/${dueDate.year.toString()}"
                    : "",
              ),
              onTap: () => _selectDate(context),
            ),
          ],
        ));
  }
}