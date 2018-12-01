import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/models/class.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

/// Assessment creation view
/// @author Praneet Singh
///
enum Day { M, Tu, W, Th, F, Sat, Sun }

class AddAssessmentView extends StatefulWidget {
  final Class aClass;
  AddAssessmentView({Key key, @required this.aClass}) : super(key: key);
  @override
  _AddAssessmentViewState createState() => _AddAssessmentViewState();
}

class _AddAssessmentViewState extends State<AddAssessmentView> {
  Category category;
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _earnedController = TextEditingController();
  final _possibleController = TextEditingController();
  final TextEditingController _categoryTitle = TextEditingController();
  final TextEditingController _categoryWeight = TextEditingController();
  final TextEditingController _categoryTitleEdit = TextEditingController();
  final TextEditingController _categoryWeightEdit = TextEditingController();
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

  String _categoryListTitle = "Select a category";
  List<Widget> _listOfCategories() {
    List<Widget> listCategories = List();
    if (widget.aClass.categories.isNotEmpty) {
      for (Category c in widget.aClass.categories) {
        listCategories.add(
          ListTile(
            title: Text(
              c.title + ": " + c.weightInPercentage.toString() + "%",
              style: Theme.of(context).accentTextTheme.body2,
            ),
            onTap: () async {
              setState(
                () {
                  _categoryListTitle =
                      c.title + ": " + c.weightInPercentage.toString() + "%";
                  category = c;
                },
              );
            },
            onLongPress: () {
              setState(() {
                _categoryTitleEdit.text = c.title;
                _categoryWeightEdit.text = c.weightInPercentage.toString();
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text("Edit category"),
                      children: <Widget>[
                        TextFormField(
                          controller: _categoryTitleEdit,
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Category title",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),

                          //Navigator.pop(context);
                          textInputAction: TextInputAction.done,
                        ),
                        TextFormField(
                          controller: _categoryWeightEdit,
                          style: Theme.of(context).accentTextTheme.body2,
                          decoration: InputDecoration(
                            hintText: "Category Weight",
                            hintStyle: TextStyle(color: Colors.black45),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          ),
                          textInputAction: TextInputAction.done,
                        ),
                        RaisedButton(
                          child: Text("Done"),
                          onPressed: () {
                            setState(() {
                              c.title = _categoryTitleEdit.text;
                              c.weightInPercentage =
                                  double.parse(_categoryWeightEdit.text);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        );
      }
    } else {
      listCategories.add(ListTile(
        title: Text(
          "No Categories so far",
          style: Theme.of(context).accentTextTheme.body2,
        ),
      ));
    }
    listCategories.add(
      ListTile(
        title: Text(
          "Add a new Category",
          style: Theme.of(context).accentTextTheme.body2,
        ),
        leading: Icon(Icons.add),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                Category cat = Category();
                return SimpleDialog(
                  title: Text("Create a new category"),
                  children: <Widget>[
                    TextFormField(
                      controller: _categoryTitle,
                      style: Theme.of(context).accentTextTheme.body2,
                      decoration: InputDecoration(
                        hintText: "Category title",
                        hintStyle: TextStyle(color: Colors.black45),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      ),

                      //Navigator.pop(context);
                      textInputAction: TextInputAction.done,
                    ),
                    TextFormField(
                      controller: _categoryWeight,
                      style: Theme.of(context).accentTextTheme.body2,
                      decoration: InputDecoration(
                        hintText: "Category Weight",
                        hintStyle: TextStyle(color: Colors.black45),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                    RaisedButton(
                      child: Text("Done"),
                      onPressed: () {
                        setState(() {
                          cat.title = _categoryTitle.text;
                          cat.weightInPercentage =
                              double.parse(_categoryWeight.text);
                          try {
                            widget.aClass.addCategory(cat);
                          } catch (e) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(e),
                              duration: Duration(seconds: 7),
                            ));
                          }
                        });
                        _categoryTitle.text = "";
                        _categoryWeight.text = "";
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
      ),
    );
    return listCategories;
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
            } else {
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

  Future<Null> _selectTime(BuildContext context) async {
    // Hide keyboard before showing time picker
    FocusScope.of(context).requestFocus(FocusNode());

    // Add delay to be sure keyboard is no longer visible
    await Future.delayed(Duration(milliseconds: 200));

    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now()
    );

    if (picked != null) {
      setState(() {
        dueDate = DateTime(dueDate.year, dueDate.month, dueDate.day, picked.hour, picked.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Assessment"),
          backgroundColor: Theme.of(context).primaryColorDark,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pop(_titleController != null
                    ? Assignment(
                        category: category,
                        pointsEarned: double.parse(_earnedController.text),
                        pointsPossible: double.parse(_possibleController.text),
                        title: _titleController.text,
                        isAssessment: true,
                        location: _locationController.text,
                        description: _descriptionController.text,
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
              title: TextFormField(
                controller: _earnedController,
                autofocus: false,
                style: Theme.of(context).accentTextTheme.body1,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    hintText: "Points earned",
                    hintStyle: TextStyle(color: Colors.black45)),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: _possibleController,
                autofocus: false,
                style: Theme.of(context).accentTextTheme.body1,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    hintText: "Possible points",
                    hintStyle: TextStyle(color: Colors.black45)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(
                "Exam/Quiz Date",
                style: Theme.of(context).accentTextTheme.body1,
              ),
              trailing: Text(
                dueDate != null
                    ? DateFormat.yMd().format(dueDate)
                    : "",
              ),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text(
                "Exam/Quiz Time",
                style: Theme.of(context).accentTextTheme.body1,
              ),
              trailing: Text(
                dueDate != null
                    ? DateFormat.jm().format(dueDate)
                    : "",
              ),
              onTap: () => _selectTime(context),
            ),
            ExpansionTile(
                leading: Icon(Icons.category),
                title: Text(
                  _categoryListTitle,
                  style: Theme.of(context).accentTextTheme.body2,
                ),
                children: _listOfCategories()),
          ],
        ));
  }
}
