import 'package:bigtitlss_management/screen/admin/admin_user_manage.dart';
import 'package:flutter/material.dart';
import 'package:bigtitlss_management/models/user.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<AppUserData>>(context) ?? [];

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return UserTile(userr: users[index]);
        });
  }
}

class UserTile extends StatelessWidget {
  final AppUserData userr;

  switchWithString() {
    switch (userr.state) {
      case 1:
        return 'Administrateur';
        break;

      case 2:
        return 'Atelier';
        break;

      case 3:
        return 'Commerciaux';
        break;

      case 4:
        return 'Dev';
        break;

      default:
        return 'Invité';
    }
  }

  UserTile({this.userr});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.orange,
              width: 3.0,
            )),
        margin:
            EdgeInsets.only(top: 12.0, bottom: 6.0, left: 20.0, right: 20.0),
        child: ListTile(
            title: Text(userr.name),
            subtitle: Text(switchWithString()),
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => UserManage(
                          uid: userr.uid,
                          name: userr.name,
                          state: switchWithString())));
            }),
      ),
    );
  }
}
