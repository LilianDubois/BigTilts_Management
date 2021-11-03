import 'package:flutter/material.dart';

class CheckList extends StatefulWidget {
  var btuid;
  CheckList(this.btuid);
  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          title: Text('Check List'),
          elevation: 0.0,
        ),
        body: Container(
            child: Column(
          children: [Text(widget.btuid)],
        )));
  }
}
