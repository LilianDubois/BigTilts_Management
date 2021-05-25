class AppStock {
  final String uid;

  AppStock({this.uid});
}

class AppStockData {
  final String uid;
  final String name;
  final String quantity_500_200;
  final String quantity_400_200;
  final String quantity_300_200;
  final String real_quantity;

  AppStockData(
      {this.uid,
      this.name,
      this.quantity_500_200,
      this.quantity_400_200,
      this.quantity_300_200,
      this.real_quantity});
}
