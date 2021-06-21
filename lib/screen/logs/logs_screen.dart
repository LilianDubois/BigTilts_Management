import 'package:bigtitlss_management/Services/database_logs.dart';

import 'package:bigtitlss_management/models/logs.dart';

import 'package:bigtitlss_management/screen/home/AppDrawer.dart';
import 'package:bigtitlss_management/screen/logs/logs_list.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogsScreen extends StatefulWidget {
  @override
  _LogsScreenState createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  @override
  Widget build(BuildContext context) {
    final database = DatabaseLogs();

    return StreamBuilder<AppLogsData>(
        stream: database.logs,
        builder: (context, snapshot) {
          AppLogsData logsData = snapshot.data;
          return StreamProvider<List<AppLogsData>>.value(
              initialData: [],
              value: database.logslist,
              child: StreamBuilder<AppLogsData>(
                  stream: database.logs,
                  builder: (context, snapshot) {
                    return Scaffold(
                        body: Container(
                      child: StreamBuilder<AppLogsData>(
                        stream: database.logs,
                        builder: (context, snapshot) {
                          AppLogsData logsData = snapshot.data;

                          return StreamProvider<List<AppLogsData>>.value(
                            initialData: [],
                            value: database.logslist,
                            child: Scaffold(
                                body: Container(
                              // decoration: new BoxDecoration(color: Colors.white),
                              child: StreamBuilder<AppLogsData>(
                                stream: database.logs,
                                builder: (context, snapshot) {
                                  return LogsList();
                                },
                              ),
                            )),
                          );
                        },
                      ),
                    ));
                  }));
        });
  }
}
