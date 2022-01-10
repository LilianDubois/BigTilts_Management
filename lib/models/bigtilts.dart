class AppBigTilts {
  final String uid;

  AppBigTilts({this.uid});
}

class AppBigTiltsData {
  final int id;

  final String nomclient;
  final String chassit;
  final String materiaux;
  // ignore: non_constant_identifier_nameshhh
  final String deco_module;
  final String plancher;
  final String taille;
  final String tapis;
  final String tapistype;
  // ignore: non_constant_identifier_names
  final bool pack_marketing;
  final String date_atelier;
  final String date_exp;
  final bool date_valid;
  final String transport_type;
  final bool videoproj;
  final String videoproj_type;

  final String infos;

  final String status;

  AppBigTiltsData(
      {this.id,
      this.nomclient,
      this.chassit,
      this.materiaux,
      this.deco_module,
      this.plancher,
      this.taille,
      this.tapis,
      this.tapistype,
      this.pack_marketing,
      this.date_atelier,
      this.date_exp,
      this.date_valid,
      this.transport_type,
      this.videoproj,
      this.videoproj_type,
      this.infos,
      this.status});
}
