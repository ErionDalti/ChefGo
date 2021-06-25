class OrderMeta {
  String table_id;
  String seat_used;

  OrderMeta({this.table_id, this.seat_used});

  OrderMeta.fromJson(Map<String, dynamic> json) {
    table_id = json['table_id'];
    seat_used = json['seats_used'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['table_id'] = this.table_id;
    data['seats_used'] = this.seat_used;
    return data;
  }
}
