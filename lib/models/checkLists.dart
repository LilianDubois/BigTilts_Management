class AppCheckLists {
  final String uid;

  AppCheckLists({this.uid});
}

class AppCheckListsData {
  final int id;

  final int palette;
  final int caisse;
  final int taillebt;
  final bool planchers;
  final bool tapisWP;
  final bool check1;
  final bool check2;
  final String check2user;
  final String check1user;

  // ignore: non_constant_identifier_names

  AppCheckListsData(
      {this.id,
      this.palette,
      this.caisse,
      this.taillebt,
      this.planchers,
      this.tapisWP,
      this.check1,
      this.check2,
      this.check1user,
      this.check2user});
}
