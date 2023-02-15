import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:bigtitlss_management/models/problems.dart';
import 'package:bigtitlss_management/screen/problems/update_problem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProblemList extends StatefulWidget {
  @override
  _ProblemListState createState() => _ProblemListState();
}

class _ProblemListState extends State<ProblemList> {
  @override
  Widget build(BuildContext context) {
    final problem = Provider.of<List<AppProblemsData>>(context) ?? [];

    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: problem.length,
              itemBuilder: (context, index) {
                print(problem.length);
                return ProblemTile(element: problem[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProblemTile extends StatelessWidget {
  final AppProblemsData element;

  ProblemTile({this.element});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.orange,
              width: 5.0,
            )),
        margin:
            EdgeInsets.only(top: 12.0, bottom: 6.0, left: 20.0, right: 20.0),
        child: ListTile(
            title: Text(
              element.bigtilt,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
            subtitle: Text('Créer le ${element.date_create}'),
            trailing: Wrap(
              spacing: 12, // space between two icons
              children: <Widget>[
                Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                ), // icon-2
              ],
            ),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => UpdateProblem(
                          element.uid,
                          element.bigtilt,
                          element.problem_description,
                          element.problem_solution,
                          element.date_maj,
                          element.date_create,
                          element.file_url)));
            }),
      ),
    );
  }
}
