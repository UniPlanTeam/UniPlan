import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/models/class.dart';
import 'package:flutter/material.dart';
import 'dart:async';

/// Assignment creation view
/// @author Praneet Singh

enum Day { M, Tu, W, Th, F, Sat, Sun }

class AddAssignmentView extends StatefulWidget {
  final Class aClass;
  AddAssignmentView({Key key, @required this.aClass}) : super(key: key);

  @override
  _AddAssignmentViewState createState() => _AddAssignmentViewState();
}

class _AddAssignmentViewState extends State<AddAssignmentView> {
  DataBase database = DataBase();
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

  //  Stepper
  //  init step to 0th position
  int currentStep = 0;
  List<Step> getSteps() {
    return [
      Step(
          title: Text(
            "Assignment title",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "Assignment title", controller: _titleController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Description",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: ListTile(
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
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Points earned",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "Points earned", controller: _earnedController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text(
            "Points possible",
            style: Theme.of(context).accentTextTheme.body1,
          ),
          content: textFieldTile(
              hint: "Points possible", controller: _possibleController),
          state: StepState.indexed,
          isActive: true),
      Step(
          title: Text("Select due date"),
          content: ListTile(
            title: Text(
              "Due Date",
              style: Theme.of(context).accentTextTheme.body2,
            ),
            trailing: Text(
              dueDate != null
                  ? "${dueDate.month.toString()}/${dueDate.day.toString()}/${dueDate.year.toString()}"
                  : "",
            ),
            onTap: () => _selectDate(context),
          ),
          state: StepState.indexed,
          isActive: true),
      Step(
        title: Text("Select a category"),
        state: StepState.indexed,
        isActive: true,
        content: ExpansionTile(
            title: Text(
              _categoryListTitle,
              style: Theme.of(context).accentTextTheme.body2,
            ),
            children: _listOfCategories()),
      )
    ];
  }

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

  String _categoryListTitle = "Category";
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
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                        title:
                            Text("Are you sure you want to delete " + c.title),
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                color: Colors.white,
                                child: Text("Yes"),
                                onPressed: () {
                                  setState(() {
                                    widget.aClass.deleteCategory(c);
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                              RaisedButton(
                                color: Colors.white,
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              RaisedButton(
                                color: Colors.white,
                                child: Text("Edit"),
                                onPressed: () {
                                  setState(() {
                                    _categoryTitleEdit.text = c.title;
                                    _categoryWeightEdit.text =
                                        c.weightInPercentage.toString();
                                  });
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SimpleDialog(
                                          title: Text("Edit category"),
                                          children: <Widget>[
                                            TextFormField(
                                              controller: _categoryTitleEdit,
                                              style: Theme.of(context)
                                                  .accentTextTheme
                                                  .body2,
                                              decoration: InputDecoration(
                                                hintText: "Category title",
                                                hintStyle: TextStyle(
                                                    color: Colors.black45),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 10.0),
                                              ),

                                              //Navigator.pop(context);
                                              textInputAction:
                                                  TextInputAction.done,
                                            ),
                                            TextFormField(
                                              controller: _categoryWeightEdit,
                                              style: Theme.of(context)
                                                  .accentTextTheme
                                                  .body2,
                                              decoration: InputDecoration(
                                                hintText: "Category Weight",
                                                hintStyle: TextStyle(
                                                    color: Colors.black45),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 10.0),
                                              ),
                                              textInputAction:
                                                  TextInputAction.done,
                                            ),
                                            RaisedButton(
                                              color: Colors.white,
                                              child: Text("Done"),
                                              onPressed: () {
                                                setState(() {
                                                  c.title =
                                                      _categoryTitleEdit.text;
                                                  c.weightInPercentage =
                                                      double.parse(
                                                          _categoryWeightEdit
                                                              .text);
                                                });
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                },
                              )
                            ],
                          )
                        ]);
                  });
            },
            onTap: () async {
              setState(
                () {
                  _categoryListTitle =
                      c.title + ": " + c.weightInPercentage.toString() + "%";
                  category = c;
                },
              );
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
        initialDate: dueDate != null
            ? DateTime(dueDate.year, dueDate.month, dueDate.day)
            : DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(3000));

    if (picked != null) {
      print("Date selected: ${picked.toString()}");
      setState(() {
        dueDate = picked;
      });
    }
  }

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        return term;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Assignment"),
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
                        dueDate: dueDate,
                        id: getCurrentTerm().getID())
                    : null);
              },
            )
          ],
        ),
        body: Stepper(
          currentStep: this.currentStep,
          type: StepperType.vertical,
          steps: getSteps(),
          onStepTapped: (step) {
            setState(() {
              currentStep = step;
            });
          },
          onStepCancel: () {
            setState(() {
              if (currentStep > 0) {
                currentStep--;
              } else {
                currentStep = 0;
              }
            });
          },
          onStepContinue: () {
            setState(() {
              if (currentStep < getSteps().length - 1) {
                currentStep++;
              } else {
                Navigator.of(context).pop(_titleController != null
                    ? Assignment(
                        category: category,
                        pointsEarned: double.parse(_earnedController.text),
                        pointsPossible: double.parse(_possibleController.text),
                        title: _titleController.text,
                        isAssessment: true,
                        location: _locationController.text,
                        description: _descriptionController.text,
                        dueDate: dueDate,
                        id: getCurrentTerm().getID())
                    : null);
              }
            });
          },
        ));
  }
}
