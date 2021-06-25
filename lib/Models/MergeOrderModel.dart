import 'package:RestaurantAppMobile/Models/OrderItem.dart';

class MergeOrderModel {
  List<OrderItem> items;

  MergeOrderModel({this.items});

  MergeOrderModel.fromJson(Map<String, dynamic> json) {
    if (json['ITEMS'] == null)
      items = [];
    else
      items = [];
    json['ITEMS'].forEach((v) {
      items.add(new OrderItem.fromJson(v));
    });
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();

    if (this.items == null)
      json['ITEMS'] = null;
    else
      json['ITEMS'] = this.items.map((v) => v.toJson()).toList();
    return json;
  }
}
