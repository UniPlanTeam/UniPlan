/// Academic term view screen
/// View, create, edit academic terms
/// @author Julian Vu
import 'package:flutter/material.dart';
import 'package:cognito/models/academic_term.dart';
import 'package:cognito/views/add_term_view.dart';
import 'dart:async';

class AcademicTermView extends StatefulWidget {
  static String tag = "academic-term-view";
  @override
  _AcademicTermViewState createState() => _AcademicTermViewState();
}

class _AcademicTermViewState extends State<AcademicTermView> {
  List<AcademicTerm> _terms = List();

  void removeTerm(AcademicTerm termToRemove) {
    setState(() {
      _terms.remove(termToRemove);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Academic Terms",
          style: Theme.of(context).primaryTextTheme.title,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              print("Pressed plug button.");
            },
          ),
        ],
      ),
      body: _terms.isNotEmpty
          ? ListView.builder(
              itemCount: _terms.length,
              itemBuilder: (BuildContext context, int index) {
                final AcademicTerm term = _terms[index];
                return Container(
                  margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: SizedBox(
                    height: 256.0,
                    child: InkWell(
                      onTap: () {
                        print("Tapped on Card");
                      },
                      child: Dismissible(
                        key: Key(_terms[index].termName),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _terms.remove(term);
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${term.termName} deleted"),
                            )
                          );
                          setState(() {

                          });
                        },
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                  leading: Icon(Icons.label),
                                  title: Text(term.termName),
                                  trailing: PopupMenuButton(
                                    itemBuilder: (BuildContext context) {
                                      return <PopupMenuItem<String>>[
                                        PopupMenuItem(
                                          child: Text("Edit"),
                                          value: "Edit",
                                        ),
                                        PopupMenuItem(
                                          child: Text("Delete"),
                                          value: "Delete",
                                        )
                                      ];
                                    },
                                    onSelected: (_) {
                                      switch (_) {
                                        case "Edit":
                                          print("Edit");
                                          break;
                                        case "Delete":
                                          removeTerm(term);
                                          break;
                                        default:
                                          print("Dunno");
                                      }
                                    },
                                  )),
                              Divider(),
                              ListTile(
                                leading: Icon(Icons.calendar_today),
                                title: Text(term.startDateAsString),
                                subtitle: Text("Start Date"),
                              ),
                              Divider(),
                              ListTile(
                                leading: Icon(Icons.calendar_today),
                                title: Text(term.endDateAsString),
                                subtitle: Text("End Date"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Retrieve Academic Term object from AddTermView
          final result = await Navigator.of(context).pushNamed(AddTermView.tag);
          if (result != null) {
            _terms.add(result);
          }
        },
        child: Icon(
          Icons.add,
          size: 42.0,
        ),
        backgroundColor: Theme.of(context).accentColor,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
