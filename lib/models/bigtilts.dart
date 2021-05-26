class AppBigTilts {
  final String uid;

  AppBigTilts({this.uid});
}

class AppBigTiltsData {
  final String uid;
  final bool vendue;
  final String nomclient;
  final String chassit;
  final String materiaux;
  // ignore: non_constant_identifier_names
  final String deco_module;
  final String plancher;
  final String taille;
  final String tapis;
  final String tapistype;
  final String date_exp;
  final bool date_valid;
  final String transport_type;
  final bool videoproj;
  final String videoproj_type;

  AppBigTiltsData(
      {this.uid,
      this.vendue,
      this.nomclient,
      this.chassit,
      this.materiaux,
      this.deco_module,
      this.plancher,
      this.taille,
      this.tapis,
      this.tapistype,
      this.date_exp,
      this.date_valid,
      this.transport_type,
      this.videoproj,
      this.videoproj_type});
}
