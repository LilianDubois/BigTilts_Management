import 'package:bigtitlss_management/models/bigtilts.dart';

import 'package:bigtitlss_management/screen/admin/udpate_bigtilt_admin.dart';
import 'package:bigtitlss_management/screen/atelier/update_bigtilt_atelier.dart';
import 'package:bigtitlss_management/screen/commerciaux/udpate_bigtilt_Commerciaux.dart';
import 'package:bigtitlss_management/screen/dev/udpate_bigtilt_dev.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BigtiltsList extends StatefulWidget {
  var stateUser;
  BigtiltsList(this.stateUser);
  @override
  _BigtiltsListState createState() => _BigtiltsListState();
}

class _BigtiltsListState extends State<BigtiltsList> {
  @override
  Widget build(BuildContext context) {
    final bigtiltlist = Provider.of<List<AppBigTiltsData>>(context);

    return ListView.builder(
        itemCount: bigtiltlist.length,
        itemBuilder: (context, index) {
          return BigTiltTile(
            bigtilt: bigtiltlist[index],
            state: widget.stateUser,
          );
        });
  }
}

class BigTiltTile extends StatelessWidget {
  var state;
  final AppBigTiltsData bigtilt;

  bool expediee = true;

  var now = DateTime.now();

  BigTiltTile({this.bigtilt, this.state});

  switchWithString() {
    switch (bigtilt.vendue) {
      case true:
        return 'Vendue';
        break;

      case false:
        return 'En stock';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (bigtilt.date_exp != 'Non renseignée') {
      expediee = now.isAfter(DateTime.parse(bigtilt.date_exp));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: expediee ? Colors.orange : Colors.red,
              width: 5.0,
            )),
        margin:
            EdgeInsets.only(top: 12.0, bottom: 6.0, left: 20.0, right: 20.0),
        child: ListTile(
            title: Text(
              'BigTilt : ${bigtilt.nomclient}',
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
                  'N°${bigtilt.uid}',
                ), // icon-1
                Icon(
                  const IconData(58800, fontFamily: 'MaterialIcons'),
                ), // icon-2
              ],
            ),
            onTap: () {
              if (state == 1)
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => UpdateBigtiltAdmin(
                              bigtilt.uid,
                              bigtilt.vendue,
                              bigtilt.nomclient,
                              bigtilt.chassit,
                              bigtilt.materiaux,
                              bigtilt.plancher,
                              bigtilt.deco_module,
                              bigtilt.taille,
                              bigtilt.tapis,
                              bigtilt.tapistype,
                              bigtilt.transport_type,
                              bigtilt.date_exp,
                              bigtilt.date_valid,
                              bigtilt.videoproj,
                              bigtilt.videoproj_type,
                            )));
              if (state == 2)
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => UpdateBigtiltAtelier(
                              bigtilt.uid,
                              bigtilt.vendue,
                              bigtilt.nomclient,
                              bigtilt.chassit,
                              bigtilt.materiaux,
                              bigtilt.plancher,
                              bigtilt.deco_module,
                              bigtilt.taille,
                              bigtilt.tapis,
                              bigtilt.tapistype,
                              bigtilt.transport_type,
                              bigtilt.date_exp,
                              bigtilt.date_valid,
                              bigtilt.videoproj,
                              bigtilt.videoproj_type,
                            )));
              if (state == 3)
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            UpdateBigtiltCommerciaux(
                              bigtilt.uid,
                              bigtilt.vendue,
                              bigtilt.nomclient,
                              bigtilt.chassit,
                              bigtilt.materiaux,
                              bigtilt.plancher,
                              bigtilt.deco_module,
                              bigtilt.taille,
                              bigtilt.tapis,
                              bigtilt.tapistype,
                              bigtilt.transport_type,
                              bigtilt.date_exp,
                              bigtilt.date_valid,
                              bigtilt.videoproj,
                              bigtilt.videoproj_type,
                            )));
              if (state == 4)
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => UpdateBigtiltDev(
                              bigtilt.uid,
                              bigtilt.vendue,
                              bigtilt.nomclient,
                              bigtilt.chassit,
                              bigtilt.materiaux,
                              bigtilt.plancher,
                              bigtilt.deco_module,
                              bigtilt.taille,
                              bigtilt.tapis,
                              bigtilt.tapistype,
                              bigtilt.transport_type,
                              bigtilt.date_exp,
                              bigtilt.date_valid,
                              bigtilt.videoproj,
                              bigtilt.videoproj_type,
                            )));
            }),
      ),
    );
  }
}
