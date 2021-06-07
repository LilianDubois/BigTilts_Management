import 'dart:math';

import 'package:bigtitlss_management/models/bigtilts.dart';

import 'package:bigtitlss_management/screen/admin/udpate_bigtilt_admin.dart';
import 'package:bigtitlss_management/screen/atelier/update_bigtilt_atelier.dart';
import 'package:bigtitlss_management/screen/commerciaux/udpate_bigtilt_Commerciaux.dart';
import 'package:bigtitlss_management/screen/dev/udpate_bigtilt_dev.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BigtiltsList extends StatefulWidget {
  var stateUser;
  var page;
  BigtiltsList(this.stateUser, this.page);
  @override
  _BigtiltsListState createState() => _BigtiltsListState();
}

class _BigtiltsListState extends State<BigtiltsList> {
  @override
  Widget build(BuildContext context) {
    final bigtiltlist = Provider.of<List<AppBigTiltsData>>(context) ?? [];

    var now = DateTime.now();

    int date;

    var previousid;

    var allbigtilts = [];
    var allbigtiltsbydate = [];
    var distinctIds = [];

    void choisir() {
      for (var i = 0; i < bigtiltlist.length; i++) {
        if (widget.page == 'todo') {
          if (bigtiltlist[i].date_exp == 'Non renseignée' ||
              now.isBefore(DateTime.parse(bigtiltlist[i].date_exp))) {
            allbigtiltsbydate.add((bigtiltlist[i].date_exp).toString());
          }
        } else if (widget.page == 'all') {
          allbigtilts.add((bigtiltlist[i].id).toString());
        } else if (widget.page == 'shipped') {
          if (bigtiltlist[i].date_exp != 'Non renseignée' &&
              now.isAfter(DateTime.parse(bigtiltlist[i].date_exp)) &&
              bigtiltlist[i].archived == false) {
            allbigtilts.add((bigtiltlist[i].id).toString());
          }
        } else if (widget.page == 'archived') {
          if (bigtiltlist[i].archived == true) {
            allbigtilts.add((bigtiltlist[i].id).toString());
          }
        }
      }
    }

    choisir();
    if (widget.page == 'todo') {
      allbigtiltsbydate.sort((a, b) => a.compareTo(b));
      for (var c = 0; c < allbigtiltsbydate.length; c++) {
        for (var i = 0; i < bigtiltlist.length; i++) {
          if (bigtiltlist[i].date_exp == allbigtiltsbydate[c]) {
            distinctIds.add((bigtiltlist[i].id).toString());
          }
        }
      }
      allbigtilts = distinctIds.toSet().toList();
    }

    print(allbigtilts);
    return ListView.builder(
        itemCount: allbigtilts.length,
        itemBuilder: (context, index) {
          AppBigTiltsData currentselection;
          var indexx = 0;

          var idd;
          var previousid;

          if (widget.page == 'todo') {
            //allbigtilts.sort((a, b) => a.compareTo(b));

            while (bigtiltlist[indexx].id != int.parse(allbigtilts[index])) {
              indexx++;
            }
          } else {
            while (bigtiltlist[indexx].id != int.parse(allbigtilts[index])) {
              indexx++;
            }
          }

          currentselection = bigtiltlist[indexx];

          bool expediee = true;
          bool emergency = false;

          switchWithString() {
            switch (currentselection.vendue) {
              case true:
                return 'Vendue';
                break;

              case false:
                return 'En stock';
                break;
            }
          }

          if (currentselection.date_exp != 'Non renseignée') {
            expediee = now.isAfter(DateTime.parse(currentselection.date_exp));
            date = DateTime.parse(currentselection.date_exp)
                .difference(now)
                .inDays;
            if (date < 8) emergency = true;
          }

          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: expediee
                            ? Colors.orange
                            : emergency
                                ? Colors.red
                                : Colors.orange,
                        width: 5.0,
                      )),
                  margin: EdgeInsets.only(
                      top: 12.0, bottom: 6.0, left: 20.0, right: 20.0),
                  child: ListTile(
                      title: Text(
                        'BigTilt : ${currentselection.nomclient}',
                        style: TextStyle(),
                      ),
                      subtitle: Text(
                        switchWithString(),
                        style: TextStyle(),
                      ),
                      trailing: Wrap(
                        spacing: 12, // space between two icons
                        children: <Widget>[
                          Text(
                            'N°${(currentselection.id).toString()}',
                          ), // icon-1
                          Icon(
                            const IconData(58800, fontFamily: 'MaterialIcons'),
                          ), // icon-2
                        ],
                      ),
                      onTap: () {
                        if (widget.stateUser == 1)
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UpdateBigtiltAdmin(
                                          currentselection.id,
                                          currentselection.vendue,
                                          currentselection.nomclient,
                                          currentselection.chassit,
                                          currentselection.materiaux,
                                          currentselection.plancher,
                                          currentselection.deco_module,
                                          currentselection.taille,
                                          currentselection.tapis,
                                          currentselection.tapistype,
                                          currentselection.pack_marketing,
                                          currentselection.transport_type,
                                          currentselection.date_exp,
                                          currentselection.date_valid,
                                          currentselection.videoproj,
                                          currentselection.videoproj_type,
                                          currentselection.archived,
                                          currentselection.infos)));
                        if (widget.stateUser == 2)
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UpdateBigtiltAtelier(
                                          currentselection.id,
                                          currentselection.vendue,
                                          currentselection.nomclient,
                                          currentselection.chassit,
                                          currentselection.materiaux,
                                          currentselection.plancher,
                                          currentselection.deco_module,
                                          currentselection.taille,
                                          currentselection.tapis,
                                          currentselection.tapistype,
                                          currentselection.pack_marketing,
                                          currentselection.transport_type,
                                          currentselection.date_exp,
                                          currentselection.date_valid,
                                          currentselection.videoproj,
                                          currentselection.videoproj_type,
                                          currentselection.archived,
                                          currentselection.infos)));
                        if (widget.stateUser == 3)
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UpdateBigtiltCommerciaux(
                                          currentselection.id,
                                          currentselection.vendue,
                                          currentselection.nomclient,
                                          currentselection.chassit,
                                          currentselection.materiaux,
                                          currentselection.plancher,
                                          currentselection.deco_module,
                                          currentselection.taille,
                                          currentselection.tapis,
                                          currentselection.tapistype,
                                          currentselection.pack_marketing,
                                          currentselection.transport_type,
                                          currentselection.date_exp,
                                          currentselection.date_valid,
                                          currentselection.videoproj,
                                          currentselection.videoproj_type,
                                          currentselection.archived,
                                          currentselection.infos)));
                        if (widget.stateUser == 4)
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UpdateBigtiltDev(
                                          currentselection.id,
                                          currentselection.vendue,
                                          currentselection.nomclient,
                                          currentselection.chassit,
                                          currentselection.materiaux,
                                          currentselection.plancher,
                                          currentselection.deco_module,
                                          currentselection.taille,
                                          currentselection.tapis,
                                          currentselection.tapistype,
                                          currentselection.pack_marketing,
                                          currentselection.transport_type,
                                          currentselection.date_exp,
                                          currentselection.date_valid,
                                          currentselection.videoproj,
                                          currentselection.videoproj_type,
                                          currentselection.archived,
                                          currentselection.infos)));
                      }),
                ),
                if (currentselection.date_exp != 'Non renseignée' &&
                    widget.page == 'todo')
                  Text(
                    'Date d\'expedition dans $date jours',
                    style: TextStyle(
                      color: emergency ? Colors.red : Colors.orange,
                    ),
                  ),
              ],
            ),
          );
        });
  }
}
