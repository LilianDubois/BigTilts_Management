class AppUser {
  final String uid;

  AppUser({this.uid});
}

class AppUserData {
  final String uid;
  final String name;
  final int state;
  final String token;

  AppUserData({this.uid, this.name, this.state, this.token});
}
