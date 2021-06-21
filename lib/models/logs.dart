class AppLogs {
  final String uid;

  AppLogs({this.uid});
}

class AppLogsData {
  final String uid;
  final String name;
  final String action;
  final String date;
  final String relatedElementUid;

  AppLogsData(
      {this.uid, this.name, this.action, this.date, this.relatedElementUid});
}
