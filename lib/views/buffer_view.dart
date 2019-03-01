import 'package:cognito/database/database.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/academic_term_view.dart';
import 'package:cognito/views/agenda_view.dart';
import 'package:flutter/material.dart';
import 'package:cognito/database/notifications.dart';

class BufferView extends StatefulWidget {
  @override
  _BufferViewState createState() => _BufferViewState();
}

class _BufferViewState extends State<BufferView> {
  DataBase database = DataBase();
  Notifications noti =Notifications();

  AcademicTerm getCurrentTerm() {
    for (AcademicTerm term in database.allTerms.terms) {
      if (DateTime.now().isAfter(term.startTime) &&
          DateTime.now().isBefore(term.endTime)) {
        return term;
      }
    }
    return null;
  }
  Future<bool> _initializeDatabase() async {
    String p = await database.initializeFireStore();
    if(p == '[]' || p == '{}' || p == null || p == '{"terms":[],"subjects":[]}' || getCurrentTerm() == null){
       Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AcademicTermView()),
        ModalRoute.withName("/Home"));
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AgendaView()),
        ModalRoute.withName("/Home"));
    }
   
  }
Future<bool> _initializeNotifications() async {
  noti.initialize(context);
}
  @override
  void initState() {
    super.initState();
    _initializeDatabase();
    _initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Padding(padding: EdgeInsets.all(5.0)),
        Text(
          "Loading your hard work...",
          style: TextStyle(color: Theme.of(context).primaryColor),
        )
      ],
    )));
  }
}
