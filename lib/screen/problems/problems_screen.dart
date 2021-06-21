import 'package:bigtitlss_management/Services/database_bigtilts.dart';
import 'package:bigtitlss_management/Services/database_problems.dart';
import 'package:bigtitlss_management/models/bigtilts.dart';
import 'package:bigtitlss_management/models/problems.dart';
import 'package:bigtitlss_management/screen/home/AppDrawer.dart';
import 'package:bigtitlss_management/screen/problems/create_problem.dart';
import 'package:bigtitlss_management/screen/problems/problem_list.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Problems_Screen extends StatefulWidget {
  @override
  _Problems_ScreenState createState() => _Problems_ScreenState();
}

class _Problems_ScreenState extends State<Problems_Screen> {
  @override
  Widget build(BuildContext context) {
    final database = DatabaseProblems();

    return MultiProvider(
        providers: [
          StreamProvider<List<AppBigTiltsData>>.value(
              value: DatabaseBigtilts().bigtilts, initialData: []),
          StreamProvider<List<AppProblemsData>>.value(
            initialData: [],
            value: database.problemslist,
          )
        ],
        child: StreamBuilder<AppProblemsData>(
            stream: database.problems,
            builder: (context, snapshot) {
              AppProblemsData problemData = snapshot.data;
              return StreamProvider<List<AppProblemsData>>.value(
                  initialData: [],
                  value: database.problemslist,
                  child: StreamBuilder<AppProblemsData>(
                      stream: database.problems,
                      builder: (context, snapshot) {
                        return Scaffold(
                            appBar: AppBar(
                              brightness: Brightness.dark,
                              backgroundColor: Colors.black,
                              title: Text('Problems',
                                  style: TextStyle(fontFamily: 'Spaceage')),
                              actions: <Widget>[
                                TextButton.icon(
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    label: Text('',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () async {
                                      return Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateProblemScreen()));
                                    })
                              ],
                            ),
                            drawer: AppDrawer(),
                            body: Container(
                              child: StreamBuilder<AppProblemsData>(
                                stream: database.problems,
                                builder: (context, snapshot) {
                                  AppProblemsData problemData = snapshot.data;

                                  return StreamProvider<
                                      List<AppProblemsData>>.value(
                                    initialData: [],
                                    value: database.problemslist,
                                    child: Scaffold(
                                        body: Container(
                                      // decoration: new BoxDecoration(color: Colors.white),
                                      child: StreamBuilder<AppProblemsData>(
                                        stream: database.problems,
                                        builder: (context, snapshot) {
                                          return ProblemList();
                                        },
                                      ),
                                    )),
                                  );
                                },
                              ),
                            ));
                      }));
            }));
  }
}
