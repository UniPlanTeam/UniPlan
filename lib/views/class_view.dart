// Copyright 2019 UniPlan. All rights reserved.

import 'package:cognito/database/database.dart';
import 'package:cognito/database/notifications.dart';
import 'package:cognito/views/gradebook_view.dart';
import 'package:flutter/material.dart';
import 'package:cognito/models/class.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/main_drawer.dart';
import 'package:cognito/views/add_class_view.dart';
import 'package:cognito/views/class_details_view.dart';

/// Class view
/// Displays list of Class cards
/// [author] Julian Vu
class ClassView extends StatefulWidget {
  @override
  _ClassViewState createState() => _ClassViewState();
}

class _ClassViewState extends State<ClassView> {
  Notifications noti = Notifications();
  AcademicTerm term;
  Class undoClass;
  DataBase database = DataBase();

  void removeClass(Class classToRemove) {
    setState(() {
      term.removeClass(classToRemove);
    });
  }

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        this.term = term;
        return term;
      }
    }
    return null;
  }

  /// Shows bottom modal sheet for creating a [Class]
  Future<Class> _showModalSheet() async {
    final classToReturn = await showModalBottomSheet(
        context: context,
        builder: (builder) {
          return AddClassView();
        });
    return classToReturn;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getCurrentTerm();
    });
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  void undo(Class undo) {
    setState(() {
      term.addClass(undo);
    });
  }

  String calculateGrade(Class c) {
    return "Grade: " + c.getGrade();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          term.termName + " - Classes",
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          IconButton(
            tooltip: "Grades",
            icon: Icon(
              Icons.poll,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GradeBookView()));
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Class result = await _showModalSheet();
          if (result != null) {
            term.addClass(result);
            database.allTerms.updateTerm(term);
            database.updateDatabase();
            setState(() {});
            for (int i in result.daysOfEvent) {
              noti.showWeeklyAtDayAndTime(
                  title: result.title,
                  body: result.title + " is starting in 15 mins",
                  id: result.id,
                  dayToRepeat: i,
                  timeToRepeat:
                      result.startTime.subtract(Duration(minutes: 15)));
            }
          }
        },
        child: Icon(
          Icons.add,
          size: 42.0,
        ),
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.black,
      ),
      body: term.classes.isNotEmpty
          ? ListView.builder(
              itemCount: term.classes.length,
              itemBuilder: (BuildContext context, int index) {
                Class classObj = term.classes[index];

                return Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: InkWell(
                    onTap: () async {
                      for (int i in classObj.daysOfEvent) {
                        noti.cancelNotification(classObj.id);
                      }
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ClassDetailsView(classObj: classObj)));
                      database.allTerms.updateTerm(term);
                      database.updateDatabase();

                      for (int i in classObj.daysOfEvent) {
                        noti.showWeeklyAtDayAndTime(
                            title: classObj.title,
                            body: classObj.title + " is starting in 15 mins",
                            id: classObj.id,
                            dayToRepeat: i,
                            timeToRepeat: classObj.startTime
                                .subtract(Duration(minutes: 15)));
                      }
                    },
                    child: Dismissible(
                      key: Key(term.classes[index].toString()),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        for (int i in classObj.daysOfEvent) {
                          noti.cancelNotification(
                              term.classes.indexOf(classObj) + i);
                        }

                        undoClass = classObj;
                        removeClass(classObj);
                        database.allTerms.updateTerm(term);
                        database.updateDatabase();
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("${classObj.title} deleted"),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              undo(undoClass);
                              database.updateDatabase();
                            },
                          ),
                          duration: Duration(seconds: 7),
                        ));
                      },
                      child: Card(
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.label,
                                color: Colors.white,
                              ),
                              subtitle: Text(
                                calculateGrade(classObj),
                                style: Theme.of(context).primaryTextTheme.body1,
                              ),
                              title: Text(
                                classObj.subjectArea +
                                    " " +
                                    classObj.courseNumber +
                                    " - " +
                                    classObj.title,
                                style: Theme.of(context).primaryTextTheme.body1,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
