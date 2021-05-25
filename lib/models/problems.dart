class AppProblems {
  final String uid;

  AppProblems({this.uid});
}

class AppProblemsData {
  final String uid;
  final String bigtilt;
  final String problem_description;
  final String problem_solution;
  final String date_maj;
  final String date_create;
  final String file_url;

  AppProblemsData(
      {this.uid,
      this.bigtilt,
      this.problem_description,
      this.problem_solution,
      this.date_maj,
      this.date_create,
      this.file_url});
}
