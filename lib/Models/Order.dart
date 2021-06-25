import 'package:RestaurantAppMobile/Models/OrderMeta.dart';

import 'OrderItem.dart';
import 'Shipping.dart';

class Order {
  String total;
  String net_total;
  String remise_type;
  String remise_percent;
  String remise;
  String rebais;
  String ristourne;
  String iva;
  String ref_tax;
  String ref_client;
  String payment_type;
  String group_discount;
  String date_creation;

  List<OrderItem> items;

  String discount_type;
  String hmb_discount;
  String register_id;
  List<String> editable_orders;
  String description;
  String titre;
  OrderMeta metas;
  String somme_percu;
  List<String> payments;
  String restaurant_order_type;
  String restaurant_order_status;
  Shipping shipping;

  Order(
      {this.total,
      this.net_total,
      this.remise_type,
      this.remise_percent,
      this.remise,
      this.rebais,
      this.ristourne,
      this.iva,
      this.ref_tax,
      this.ref_client,
      this.payment_type,
      this.group_discount,
      this.date_creation,
      this.items,
      this.discount_type,
      this.description,
      this.shipping,
      this.metas,
      this.editable_orders,
      this.restaurant_order_type,
      this.somme_percu,
      this.hmb_discount,
      this.payments,
      this.register_id,
      this.restaurant_order_status,
      this.titre});

  Order.fromJson(Map<String, dynamic> json) {
    total = json['TOTAL'];
    net_total = json['NET_TOTAL'];
    remise_type = json['REMISE_TYPE'];
    remise_percent = json['REMISE_PERCENT'];
    remise = json['REMISE'];
    rebais = json['RABAIS'];
    ristourne = json['RISTOURNE'];
    iva = json['TVA'];
    ref_tax = json['REF_TAX'];
    ref_client = json['REF_CLIENT'];
    payment_type = json['PAYMENT_TYPE'];
    group_discount = json['GROUP_DISCOUNT'];
    date_creation = json['DATE_CREATION'];
    if (json['ITEMS'] == null)
      items = [];
    else
      items = [];
    json['ITEMS'].forEach((v) {
      items.add(new OrderItem.fromJson(v));
    });
    discount_type = json['DISCOUNT_TYPE'];
    hmb_discount = json['HMB_DISCOUNT'];
    register_id = json['REGISTER_ID'];
    if (json['EDITABLE_ORDERS'] == null)
      editable_orders = [];
    else
      editable_orders = [];
    json['EDITABLE_ORDERS'].forEach((v) {
      editable_orders.add(v);
    });
    description = json['DESCRIPTION'];
    titre = json['TITRE'];
    if (json['metas'] == null)
      metas = new OrderMeta(seat_used: "", table_id: "");
    else {
      metas = new OrderMeta(seat_used: "", table_id: "");
      metas = new OrderMeta.fromJson(json['metas']);
    }
    somme_percu = json['SOMME_PERCU'];
    if (json['payments'] == null)
      payments = [];
    else
      payments = [];
    json['payments'].forEach((v) {
      payments.add(v);
    });
    restaurant_order_type = json['RESTAURANT_ORDER_TYPE'];
    restaurant_order_status = json['RESTAURANT_ORDER_STATUS'];
    if (json['shipping'] == null)
      shipping = null;
    else
      shipping = Shipping.fromJson(json['shipping']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['TOTAL'] = (total == null) ? "" : total;
    json['NET_TOTAL'] = (net_total == null) ? "" : net_total;
    json['REMISE_TYPE'] =
        (remise_type == null || remise_type == "") ? "" : remise_type;
    json['REMISE_PERCENT'] = remise_percent;
    json['REMISE'] = remise;
    json['RABAIS'] = rebais;
    json['RISTOURNE'] = ristourne;
    json['TVA'] = iva;
    json['REF_TAX'] = ref_tax;
    json['REF_CLIENT'] = ref_client;
    json['PAYMENT_TYPE'] = payment_type;
    json['GROUP_DISCOUNT'] = group_discount;
    json['DATE_CREATION'] = date_creation;

    if (this.items == null)
      json['ITEMS'] = null;
    else
      json['ITEMS'] = this.items.map((v) => v.toJson()).toList();
    json['DISCOUNT_TYPE'] = discount_type;
    json['HMB_DISCOUNT'] = hmb_discount;
    json['REGISTER_ID'] = register_id;
    if (this.editable_orders == null)
      json['EDITABLE_ORDERS'] = [];
    else
      json['EDITABLE_ORDERS'] = this.editable_orders.map((v) => v).toList();
    json['DESCRIPTION'] = description;
    json['TITRE'] = titre;
    if (this.metas == null)
      json['metas'] = null;
    else
      json['metas'] = this.metas.toJson();
    json['SOMME_PERCU'] = somme_percu;
    if (this.payments == null)
      json['payments'] = [];
    else
      json['payments'] = this.payments.map((v) => v).toList();
    json['RESTAURANT_ORDER_TYPE'] = restaurant_order_type;
    json['RESTAURANT_ORDER_STATUS'] = restaurant_order_status;
    if (this.shipping == null)
      json['shipping'] = null;
    else
      json['shipping'] = this.shipping.toJson();
    return json;
  }
}
