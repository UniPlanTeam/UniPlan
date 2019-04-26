import 'package:cognito/models/assignment.dart';
import 'package:cognito/models/category.dart';
import 'package:cognito/models/class.dart';
import 'package:flutter/material.dart';

/// Assignment details view
/// @author Praneet Singh

class AssignmentDetailsView extends StatefulWidget {
  // Hold academic term object
  final Assignment assignment;
  final Class aClass;
  // Constructor that takes in an academic term object
  AssignmentDetailsView(
      {Key key, @required this.assignment, @required this.aClass})
      : super(key: key);
  @override
  _AssignmentDetailsViewState createState() => _AssignmentDetailsViewState();
}

class _AssignmentDetailsViewState extends State<AssignmentDetailsView> {
  TextEditingController _descriptionController;
  TextEditingController _earnedController;
  TextEditingController _possibleController;
  TextEditingController _titleController;
  TextEditingController _categoryTitle = TextEditingController();
  TextEditingController _categoryWeight = TextEditingController();
  TextEditingController _categoryTitleEdit = TextEditingController();
  TextEditingController _categoryWeightEdit = TextEditingController();
  //  Stepper
  //  init step to 0th position
  int currentStep = 0;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.assignment.title);
    _descriptionController =
        TextEditingController(text: widget.assignment.description);
    _earnedController =
        TextEditingController(text: widget.assignment.pointsEarned.toString());
    _possibleController = TextEditingController(
        text: widget.assignment.pointsPossible.toString());

    _categoryListTitle = widget.assignment.category.title +
        ": " +
        widget.assignment.category.weightInPercentage.toString() +
        "%";
  }

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
          content: DateRow(widget.assignment),
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

  ListTile textFieldTile(
      {String intiialText,
      Widget leading,
      Widget trailing,
      TextInputType keyboardType,
      String hint,
      Widget subtitle,
      TextEditingController controller}) {
    return ListTile(
      leading: leading,
      trailing: trailing,
      title: TextFormField(
        initialValue: intiialText,
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
                  widget.assignment.category = c;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: BackButtonIcon(),
            onPressed: () {
              print("Returning a assignment");
              widget.assignment.title = _titleController.text;
              widget.assignment.description = _descriptionController.text;
              widget.assignment.pointsEarned =
                  double.parse(_earnedController.text);
              widget.assignment.pointsPossible =
                  double.parse(_possibleController.text);

              Navigator.of(context).pop(widget.assignment);
            },
          ),
          title: Text(
            widget.assignment.title,
            style: Theme.of(context).primaryTextTheme.title,
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
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
                print("Returning a assignment");
                widget.assignment.title = _titleController.text;
                widget.assignment.description = _descriptionController.text;
                widget.assignment.pointsEarned =
                    double.parse(_earnedController.text);
                widget.assignment.pointsPossible =
                    double.parse(_possibleController.text);

                Navigator.of(context).pop(widget.assignment);
              }
            });
          },
        ));
  }
}

// Helper class to modularize date row creation
class DateRow extends StatefulWidget {
  // Flag for whether this date is start date
  final Assignment assignment;

  DateRow(this.assignment);

  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  String getDueDateAsString() {
    return "${widget.assignment.dueDate.month}/${widget.assignment.dueDate.day}/${widget.assignment.dueDate.year}";
  }

  Future<Null> _selectDate(BuildContext context) async {
    // Make sure keyboard is hidden before showing date picker
    FocusScope.of(context).requestFocus(FocusNode());

    await Future.delayed(Duration(milliseconds: 200));

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.assignment.dueDate != null
          ? DateTime(widget.assignment.dueDate.year,
              widget.assignment.dueDate.month, widget.assignment.dueDate.day)
          : DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(3000),
    );

    if (picked != null) {
      print("Date selected: ${picked.toString()}");
      setState(() {
        widget.assignment.dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "Due Date",
        style: Theme.of(context).accentTextTheme.body2,
      ),
      trailing: Text(getDueDateAsString()),
      onTap: () {
        print("Tapped on Due date");
        _selectDate(context);
      },
    );
  }
}
